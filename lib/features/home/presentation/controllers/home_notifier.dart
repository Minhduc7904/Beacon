import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import '../../../../core/messages/app_message_notifier.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  static const Duration _cameraInitTimeout = Duration(seconds: 10);
  static const ResolutionPreset _cameraResolutionPreset =
      ResolutionPreset.veryHigh;

  CameraController? _cameraController;
  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  bool _isFlashEnabled = false;
  bool _isInitializingCamera = false;
  double _minZoomLevel = 1;
  double _maxZoomLevel = 1;
  double _zoomLevel = 1;
  double? _scaleStartZoomLevel;
  _CameraRetakeSnapshot? _retakeSnapshot;
  final AppMessageNotifier? _messageNotifier;

  HomeNotifier([this._messageNotifier]) : super(const HomeState.initial());

  CameraController? get cameraController => _cameraController;

  Future<void> initializeCamera({
    int? preferredCameraIndex,
    CameraLensDirection? preferredLensDirection,
    bool preserveSelectedCamera = false,
  }) async {
    if (!mounted || _isInitializingCamera) {
      return;
    }

    _isInitializingCamera = true;
    state = state.copyWith(
      isCameraInitializing: true,
      isCameraReady: false,
      isScreenFlashVisible: false,
      clearCameraError: true,
    );

    try {
      _cameras = await availableCameras().timeout(_cameraInitTimeout);
      if (_cameras.isEmpty) {
        throw CameraException('NO_CAMERA', 'Device has no camera');
      }

      _cameraIndex = _resolveCameraIndex(
        preferredCameraIndex: preferredCameraIndex,
        preferredLensDirection: preferredLensDirection,
        preserveSelectedCamera: preserveSelectedCamera,
      );

      await _initializeCameraAtIndex(_cameraIndex);
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: true,
        isFlashEnabled: _isFlashEnabled,
        isUsingFrontCamera: _isUsingFrontCamera,
        isScreenFlashVisible: false,
        clearCameraError: true,
      );
    } on TimeoutException {
      if (!mounted) {
        return;
      }
      _cameraController = null;
      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: false,
        isScreenFlashVisible: false,
        cameraError: 'Không thể khởi tạo camera. Vui lòng thử lại.',
      );
    } on CameraException catch (error) {
      if (!mounted) {
        return;
      }

      _cameraController = null;
      final code = error.code;
      final message = switch (code) {
        'CameraAccessDenied' ||
        'CameraAccessDeniedWithoutPrompt' => 'Bạn chưa cấp quyền camera.',
        'CameraAccessRestricted' => 'Camera bị hạn chế trên thiết bị này.',
        'AudioAccessDenied' ||
        'AudioAccessDeniedWithoutPrompt' => 'Không có quyền microphone.',
        _ => 'Không thể khởi tạo camera. Vui lòng thử lại.',
      };
      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: false,
        isScreenFlashVisible: false,
        cameraError: message,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      _cameraController = null;
      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: false,
        isScreenFlashVisible: false,
        cameraError: 'Không thể khởi tạo camera. Vui lòng thử lại.',
      );
    } finally {
      _isInitializingCamera = false;
    }
  }

  Future<void> switchCamera() async {
    if (!mounted || _isInitializingCamera || _cameras.length < 2) {
      return;
    }

    final previousIndex = _cameraIndex;
    final currentCamera = _selectedCamera;
    final targetLensDirection =
        currentCamera?.lensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;
    final targetIndex = _findCameraIndexByLensDirection(targetLensDirection);
    final nextIndex = targetIndex >= 0
        ? targetIndex
        : (_cameraIndex + 1) % _cameras.length;

    if (nextIndex == previousIndex) {
      return;
    }

    _isInitializingCamera = true;
    state = state.copyWith(
      isCameraInitializing: true,
      isCameraReady: false,
      isScreenFlashVisible: false,
      clearCameraError: true,
    );

    try {
      await _initializeCameraAtIndex(nextIndex);
      if (!mounted) {
        return;
      }

      _cameraIndex = nextIndex;
      await _applyFlashToCurrentCamera();
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: true,
        isFlashEnabled: _isFlashEnabled,
        isUsingFrontCamera: _isUsingFrontCamera,
        isScreenFlashVisible: false,
        clearCameraError: true,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _cameraIndex = previousIndex;
      final didRestoreCamera = await _restoreCameraAtIndex(previousIndex);
      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: didRestoreCamera,
        isFlashEnabled: _isFlashEnabled,
        isUsingFrontCamera: _isUsingFrontCamera,
        isScreenFlashVisible: false,
        cameraError: didRestoreCamera
            ? null
            : 'Không thể đổi camera. Vui lòng thử lại.',
        clearCameraError: didRestoreCamera,
      );
    } finally {
      _isInitializingCamera = false;
    }
  }

  Future<void> toggleFlash() async {
    final controller = _cameraController;
    final selectedCamera = _selectedCamera;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (selectedCamera == null) {
      return;
    }

    if (selectedCamera.lensDirection != CameraLensDirection.back) {
      _isFlashEnabled = false;
      await _setFlashModeSafely(controller, FlashMode.off);
      if (mounted) {
        state = state.copyWith(
          isFlashEnabled: false,
          isScreenFlashVisible: false,
        );
      }
      return;
    }

    final nextFlashEnabled = !_isFlashEnabled;
    final didApply = await _setFlashEnabledForCamera(
      controller,
      selectedCamera,
      enabled: nextFlashEnabled,
    );
    if (!mounted) {
      return;
    }

    if (!didApply) {
      _isFlashEnabled = false;
      state = state.copyWith(
        isFlashEnabled: false,
        isScreenFlashVisible: false,
      );
      _messageNotifier?.addWarning('Thiết bị này không hỗ trợ flash.');
      return;
    }

    _isFlashEnabled = nextFlashEnabled;
    state = state.copyWith(
      isCameraReady: true,
      isFlashEnabled: _isFlashEnabled,
      isUsingFrontCamera: _isUsingFrontCamera,
      isScreenFlashVisible: false,
    );
  }

  Future<void> deactivateCameraForNavigation({
    bool waitForPreviewDetach = true,
  }) async {
    final controller = _cameraController;
    _cameraController = null;
    _isFlashEnabled = false;

    if (mounted) {
      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: false,
        isFlashEnabled: false,
        isScreenFlashVisible: false,
        clearCameraError: true,
      );
    }

    if (waitForPreviewDetach) {
      await _waitForCameraPreviewDetach();
    }

    await _disposeController(controller);
  }

  Future<void> deactivateCameraForPreview() async {
    final selectedCamera = _selectedCamera;
    _retakeSnapshot = _CameraRetakeSnapshot(
      cameraIndex: _cameraIndex,
      lensDirection: selectedCamera?.lensDirection ?? CameraLensDirection.back,
      isFlashEnabled:
          selectedCamera?.lensDirection == CameraLensDirection.back &&
          _isFlashEnabled,
    );

    final controller = _cameraController;
    _cameraController = null;

    if (mounted) {
      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: false,
        isScreenFlashVisible: false,
        clearCameraError: true,
      );
    }

    await _waitForCameraPreviewDetach();
    await _disposeController(controller);
  }

  Future<void> restoreCameraForRetake() async {
    final snapshot = _retakeSnapshot;
    _retakeSnapshot = null;

    if (snapshot != null) {
      _cameraIndex = snapshot.cameraIndex;
      _isFlashEnabled = snapshot.isFlashEnabled;
    }

    if (mounted) {
      state = state.copyWith(
        isFlashEnabled: _isFlashEnabled,
        clearCapturedImagePath: true,
        clearCameraError: true,
      );
    }

    await initializeCamera(
      preferredCameraIndex: snapshot?.cameraIndex,
      preferredLensDirection: snapshot?.lensDirection,
    );
  }

  void discardRetakeCameraState() {
    _retakeSnapshot = null;
    _isFlashEnabled = false;
    if (mounted) {
      state = state.copyWith(
        isFlashEnabled: false,
        isScreenFlashVisible: false,
      );
    }
  }

  Future<void> setZoomLevel(double zoomLevel) async {
    final controller = _cameraController;
    if (controller == null ||
        !controller.value.isInitialized ||
        _maxZoomLevel <= _minZoomLevel) {
      return;
    }

    final clampedZoomLevel = zoomLevel
        .clamp(_minZoomLevel, _maxZoomLevel)
        .toDouble();

    try {
      await controller.setZoomLevel(clampedZoomLevel);
      _zoomLevel = clampedZoomLevel;
    } catch (_) {
      // Some devices report a zoom range that rejects edge values. Keep the
      // current working zoom instead of surfacing a transient camera error.
    }
  }

  void startZoomGesture() {
    _scaleStartZoomLevel = _zoomLevel;
  }

  Future<void> updateZoomGesture(double scale) async {
    final startZoomLevel = _scaleStartZoomLevel;
    if (startZoomLevel == null || scale <= 0) {
      return;
    }

    await setZoomLevel(startZoomLevel * scale);
  }

  Future<void> onLifecycleChanged(AppLifecycleState appState) async {
    if (appState == AppLifecycleState.resumed && !state.hasCapturedImage) {
      if (!_isInitializingCamera) {
        await initializeCamera();
      }
      return;
    }

    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (appState == AppLifecycleState.inactive ||
        appState == AppLifecycleState.paused ||
        appState == AppLifecycleState.detached) {
      await deactivateCameraForNavigation(waitForPreviewDetach: false);
      return;
    }
  }

  Future<void> capturePhoto({
    Duration minimumPublishDelay = Duration.zero,
  }) async {
    final controller = _cameraController;
    if (state.isCapturing ||
        state.isCameraInitializing ||
        controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    state = state.copyWith(
      isCapturing: true,
      isScreenFlashVisible: false,
      clearCameraError: true,
    );
    final startedAt = DateTime.now();

    try {
      final imageFile = await controller.takePicture();
      final croppedPath = await _cropSquareImage(
        imageFile.path,
        flipHorizontal: _isUsingFrontCamera,
      );

      final elapsed = DateTime.now().difference(startedAt);
      final remainingDelay = minimumPublishDelay - elapsed;
      if (remainingDelay > Duration.zero) {
        await Future<void>.delayed(remainingDelay);
      }

      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isCapturing: false,
        isScreenFlashVisible: false,
        capturedImagePath: croppedPath,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      state = state.copyWith(
        isCapturing: false,
        isScreenFlashVisible: false,
        cameraError: 'Chụp ảnh thất bại. Vui lòng thử lại.',
      );
    }
  }

  void clearCapturedImage() {
    if (!state.hasCapturedImage) {
      return;
    }

    state = state.copyWith(clearCapturedImagePath: true);

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      initializeCamera();
    }
  }

  void disposeCamera() {
    final controller = _cameraController;
    _cameraController = null;
    _isFlashEnabled = false;
    _retakeSnapshot = null;
    unawaited(_disposeController(controller));
    if (mounted) {
      state = state.copyWith(
        isCameraInitializing: false,
        isCameraReady: false,
        isFlashEnabled: false,
        isScreenFlashVisible: false,
      );
    }
  }

  void reset() {
    _isFlashEnabled = false;
    _retakeSnapshot = null;
    state = const HomeState.initial();
  }

  bool get _isUsingFrontCamera =>
      _selectedCamera?.lensDirection == CameraLensDirection.front;

  CameraDescription? get _selectedCamera {
    if (_cameras.isEmpty ||
        _cameraIndex < 0 ||
        _cameraIndex >= _cameras.length) {
      return null;
    }

    return _cameras[_cameraIndex];
  }

  int _findCameraIndexByLensDirection(CameraLensDirection lensDirection) {
    return _cameras.indexWhere(
      (camera) => camera.lensDirection == lensDirection,
    );
  }

  int _resolveCameraIndex({
    int? preferredCameraIndex,
    CameraLensDirection? preferredLensDirection,
    bool preserveSelectedCamera = false,
  }) {
    if (_isValidCameraIndex(preferredCameraIndex) &&
        (preferredLensDirection == null ||
            _cameras[preferredCameraIndex!].lensDirection ==
                preferredLensDirection)) {
      return preferredCameraIndex!;
    }

    if (preferredLensDirection != null) {
      final preferredLensIndex = _findCameraIndexByLensDirection(
        preferredLensDirection,
      );
      if (preferredLensIndex >= 0) {
        return preferredLensIndex;
      }
    }

    if (preserveSelectedCamera && _isValidCameraIndex(_cameraIndex)) {
      return _cameraIndex;
    }

    final backCameraIndex = _findCameraIndexByLensDirection(
      CameraLensDirection.back,
    );
    if (backCameraIndex >= 0) {
      return backCameraIndex;
    }

    return 0;
  }

  bool _isValidCameraIndex(int? index) =>
      index != null && index >= 0 && index < _cameras.length;

  Future<String> _cropSquareImage(
    String sourcePath, {
    required bool flipHorizontal,
  }) async {
    final bytes = await File(sourcePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return sourcePath;
    }

    final squareSize = math.min(decoded.width, decoded.height);
    final offsetX = (decoded.width - squareSize) ~/ 2;
    final offsetY = (decoded.height - squareSize) ~/ 2;

    final squareImage = img.copyCrop(
      decoded,
      x: offsetX,
      y: offsetY,
      width: squareSize,
      height: squareSize,
    );

    if (flipHorizontal) {
      img.flipHorizontal(squareImage);
    }

    final lastDot = sourcePath.lastIndexOf('.');
    final pathPrefix = lastDot == -1
        ? sourcePath
        : sourcePath.substring(0, lastDot);
    final croppedPath = '${pathPrefix}_square.jpg';

    await File(
      croppedPath,
    ).writeAsBytes(img.encodeJpg(squareImage, quality: 92), flush: true);

    return croppedPath;
  }

  Future<void> _initializeCameraAtIndex(int index) async {
    final selectedCamera = _cameras[index];
    final previousController = _cameraController;
    _cameraController = null;
    await _disposeController(previousController);

    final controller = CameraController(
      selectedCamera,
      _cameraResolutionPreset,
      enableAudio: false,
    );

    try {
      await controller.initialize().timeout(_cameraInitTimeout);
      await _setFlashModeForCamera(controller, selectedCamera);
      _minZoomLevel = await controller.getMinZoomLevel();
      _maxZoomLevel = await controller.getMaxZoomLevel();
      _zoomLevel = _minZoomLevel;
      _debugLogCameraMetrics(controller);
      _cameraController = controller;
    } catch (_) {
      await controller.dispose();
      rethrow;
    }
  }

  Future<bool> _restoreCameraAtIndex(int index) async {
    try {
      await _initializeCameraAtIndex(index);
      return true;
    } catch (_) {
      _cameraController = null;
      return false;
    }
  }

  Future<void> _setFlashModeForCamera(
    CameraController controller,
    CameraDescription camera,
  ) async {
    if (camera.lensDirection != CameraLensDirection.back) {
      _isFlashEnabled = false;
      await _setFlashModeSafely(controller, FlashMode.off);
      return;
    }

    final didApply = await _setFlashEnabledForCamera(
      controller,
      camera,
      enabled: _isFlashEnabled,
    );

    if (!didApply) {
      _isFlashEnabled = false;
      _messageNotifier?.addWarning('Thiết bị này không hỗ trợ flash.');
    }
  }

  Future<void> _applyFlashToCurrentCamera() async {
    final controller = _cameraController;
    final selectedCamera = _selectedCamera;
    if (controller == null ||
        !controller.value.isInitialized ||
        selectedCamera == null) {
      return;
    }

    await _setFlashModeForCamera(controller, selectedCamera);
  }

  Future<bool> _setFlashEnabledForCamera(
    CameraController controller,
    CameraDescription camera, {
    required bool enabled,
  }) async {
    if (!enabled) {
      await _setFlashModeSafely(controller, FlashMode.off);
      return true;
    }

    if (camera.lensDirection != CameraLensDirection.back) {
      await _setFlashModeSafely(controller, FlashMode.off);
      return false;
    }

    var didApply = await _setFlashModeSafely(controller, FlashMode.torch);
    if (!didApply) {
      didApply = await _setFlashModeSafely(controller, FlashMode.always);
    }

    if (!didApply) {
      await _setFlashModeSafely(controller, FlashMode.off);
    }

    return didApply;
  }

  Future<void> _disposeController(CameraController? controller) async {
    if (controller == null) {
      return;
    }

    await _setFlashModeSafely(controller, FlashMode.off);
    await controller.dispose();
  }

  Future<void> _waitForCameraPreviewDetach() async {
    await Future<void>.delayed(Duration.zero);
    await WidgetsBinding.instance.endOfFrame;
  }

  Future<bool> _setFlashModeSafely(
    CameraController controller,
    FlashMode mode,
  ) async {
    try {
      await controller.setFlashMode(mode);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _debugLogCameraMetrics(CameraController controller) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      'HomeNotifier camera '
      'preset=$_cameraResolutionPreset, '
      'previewSize=${controller.value.previewSize}, '
      'controllerAspectRatio=${controller.value.aspectRatio}, '
      'zoomLevel=$_zoomLevel, '
      'minZoomLevel=$_minZoomLevel, '
      'maxZoomLevel=$_maxZoomLevel',
    );
  }
}

class _CameraRetakeSnapshot {
  final int cameraIndex;
  final CameraLensDirection lensDirection;
  final bool isFlashEnabled;

  const _CameraRetakeSnapshot({
    required this.cameraIndex,
    required this.lensDirection,
    required this.isFlashEnabled,
  });
}
