import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  static const Duration _cameraInitTimeout = Duration(seconds: 10);

  CameraController? _cameraController;
  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;
  bool _isInitializingCamera = false;

  HomeNotifier() : super(const HomeState.initial());

  CameraController? get cameraController => _cameraController;

  Future<void> initializeCamera() async {
    if (!mounted || _isInitializingCamera) {
      return;
    }

    _isInitializingCamera = true;
    state = state.copyWith(isCameraInitializing: true, clearCameraError: true);

    try {
      _cameras = await availableCameras().timeout(_cameraInitTimeout);
      if (_cameras.isEmpty) {
        throw CameraException('NO_CAMERA', 'Device has no camera');
      }

      _cameraIndex = _cameras.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      if (_cameraIndex < 0) {
        _cameraIndex = 0;
      }

      await _initializeCameraAtIndex(_cameraIndex);
      if (!mounted) {
        return;
      }

      state = state.copyWith(
        isCameraInitializing: false,
        clearCameraError: true,
      );
    } on TimeoutException {
      if (!mounted) {
        return;
      }
      _cameraController = null;
      state = state.copyWith(
        isCameraInitializing: false,
        cameraError: 'Mo camera qua lau. Vui long thu lai.',
      );
    } on CameraException catch (error) {
      if (!mounted) {
        return;
      }

      _cameraController = null;
      final code = error.code;
      final message = switch (code) {
        'CameraAccessDenied' ||
        'CameraAccessDeniedWithoutPrompt' => 'Ban chua cap quyen camera.',
        'CameraAccessRestricted' => 'Camera bi han che tren thiet bi nay.',
        'AudioAccessDenied' ||
        'AudioAccessDeniedWithoutPrompt' => 'Khong co quyen microphone.',
        _ => 'Khong the khoi tao camera. Vui long thu lai.',
      };
      state = state.copyWith(isCameraInitializing: false, cameraError: message);
    } catch (_) {
      if (!mounted) {
        return;
      }
      _cameraController = null;
      state = state.copyWith(
        isCameraInitializing: false,
        cameraError: 'Khong the khoi tao camera. Vui long thu lai.',
      );
    } finally {
      _isInitializingCamera = false;
    }
  }

  Future<void> switchCamera() async {
    if (!mounted || _isInitializingCamera || _cameras.length < 2) {
      return;
    }

    _isInitializingCamera = true;
    state = state.copyWith(isCameraInitializing: true, clearCameraError: true);

    try {
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
      await _initializeCameraAtIndex(_cameraIndex);
      if (!mounted) {
        return;
      }
      state = state.copyWith(
        isCameraInitializing: false,
        clearCameraError: true,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      state = state.copyWith(
        isCameraInitializing: false,
        cameraError: 'Khong the doi camera. Vui long thu lai.',
      );
    } finally {
      _isInitializingCamera = false;
    }
  }

  Future<void> toggleFlash() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    try {
      _flashMode = _flashMode == FlashMode.off
          ? FlashMode.torch
          : FlashMode.off;
      await controller.setFlashMode(_flashMode);
    } catch (_) {
      _flashMode = FlashMode.off;
      await controller.setFlashMode(FlashMode.off);
    }
  }

  Future<void> onLifecycleChanged(AppLifecycleState appState) async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (appState == AppLifecycleState.inactive ||
        appState == AppLifecycleState.paused ||
        appState == AppLifecycleState.detached) {
      await controller.dispose();
      _cameraController = null;
      return;
    }

    if (appState == AppLifecycleState.resumed && !state.hasCapturedImage) {
      if (!_isInitializingCamera) {
        await initializeCamera();
      }
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

    state = state.copyWith(isCapturing: true, clearCameraError: true);
    final startedAt = DateTime.now();

    try {
      final imageFile = await controller.takePicture();
      final croppedPath = await _cropSquareImage(imageFile.path);

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
        capturedImagePath: croppedPath,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      state = state.copyWith(
        isCapturing: false,
        cameraError: 'Chup anh that bai. Vui long thu lai.',
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
    _cameraController?.dispose();
    _cameraController = null;
  }

  void reset() => state = const HomeState.initial();

  Future<String> _cropSquareImage(String sourcePath) async {
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
    final controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize().timeout(_cameraInitTimeout);
    await controller.setFlashMode(_flashMode);

    await _cameraController?.dispose();
    _cameraController = controller;
  }
}
