import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../controllers/home_state.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitializing = true;
  String? _cameraError;
  String? _capturedImagePath;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      controller.dispose();
      _cameraController = null;
      return;
    }

    if (state == AppLifecycleState.resumed && _capturedImagePath == null) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isCameraInitializing = true;
      _cameraError = null;
    });

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('NO_CAMERA', 'Thiết bị không có camera');
      }

      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      await _cameraController?.dispose();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isCameraInitializing = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _cameraController = null;
        _cameraError = 'Không thể khởi tạo camera. Vui lòng thử lại.';
        _isCameraInitializing = false;
      });
    }
  }

  Future<void> _capturePhoto() async {
    final controller = _cameraController;
    if (_isCapturing ||
        _isCameraInitializing ||
        controller == null ||
        !controller.value.isInitialized) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final imageFile = await controller.takePicture();
      if (!mounted) {
        return;
      }

      setState(() {
        _capturedImagePath = imageFile.path;
      });
      ref.read(homeNotifierProvider.notifier).reset();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraError = 'Chụp ảnh thất bại. Vui lòng thử lại.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  void _clearCapturedImage() {
    if (_capturedImagePath == null) {
      return;
    }

    setState(() {
      _capturedImagePath = null;
    });
    ref.read(homeNotifierProvider.notifier).reset();

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      _initializeCamera();
    }
  }

  Future<void> _submitPost() async {
    final filePath = _capturedImagePath;
    if (filePath == null || filePath.trim().isEmpty) {
      return;
    }

    await ref
        .read(homeNotifierProvider.notifier)
        .uploadPostMedia(filePath: filePath);
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final isUploading = homeState is HomeUploading;
    final size = MediaQuery.sizeOf(context);
    final cameraBoxSize = (size.width - 48).clamp(240.0, 360.0);
    final hasCapturedImage =
        _capturedImagePath != null && _capturedImagePath!.isNotEmpty;
    final showBusy = _isCapturing || isUploading;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: cameraBoxSize,
                height: cameraBoxSize,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: hasCapturedImage
                    ? Stack(
                        children: [
                          Positioned.fill(
                            child: Image.file(
                              File(_capturedImagePath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _CameraPlaceholder(
                                  cameraBoxSize: cameraBoxSize,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Material(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: showBusy ? null : _clearCapturedImage,
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : _buildCameraPreview(cameraBoxSize),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: cameraBoxSize,
                child: FilledButton.icon(
                  onPressed: showBusy
                      ? null
                      : (_cameraError != null && !hasCapturedImage)
                      ? _initializeCamera
                      : hasCapturedImage
                      ? _submitPost
                      : _capturePhoto,
                  icon: showBusy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          (_cameraError != null && !hasCapturedImage)
                              ? Icons.refresh_rounded
                              : hasCapturedImage
                              ? Icons.cloud_upload_rounded
                              : Icons.camera_alt_rounded,
                        ),
                  label: Text(
                    showBusy
                        ? 'Đang xử lý...'
                        : (_cameraError != null && !hasCapturedImage)
                        ? 'Mở lại camera'
                        : hasCapturedImage
                        ? 'Đăng'
                        : 'Chụp',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (homeState is HomeUploadSuccess)
                Text(
                  'Đăng thành công: ${homeState.media.objectKey}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (homeState is HomeError)
                Text(
                  homeState.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview(double cameraBoxSize) {
    if (_isCameraInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cameraError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _cameraError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      );
    }

    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return _CameraPlaceholder(cameraBoxSize: cameraBoxSize);
    }

    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return _CameraPlaceholder(cameraBoxSize: cameraBoxSize);
    }

    // Fill the square and crop overflow so the camera preview height
    // always matches the square height.
    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.center,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}

class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder({required this.cameraBoxSize});

  final double cameraBoxSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey.shade900, Colors.grey.shade800],
              ),
            ),
          ),
        ),
        Center(
          child: Icon(
            Icons.camera_alt_rounded,
            color: Colors.white70,
            size: cameraBoxSize * 0.18,
          ),
        ),
      ],
    );
  }
}
