import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';

class CameraBox extends ConsumerWidget {
  const CameraBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraBoxSize = _cameraBoxSize(context);

    return Container(
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
      child: _HomeCameraPreview(cameraBoxSize: cameraBoxSize),
    );
  }

  double _cameraBoxSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width - 48).clamp(240.0, 360.0);
  }
}

class _HomeCameraPreview extends ConsumerWidget {
  const _HomeCameraPreview({required this.cameraBoxSize});

  final double cameraBoxSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final controller = ref.read(homeNotifierProvider.notifier).cameraController;

    if (state.isCameraInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.cameraError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            state.cameraError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      );
    }

    if (controller == null || !controller.value.isInitialized) {
      return _HomeCameraPlaceholder(cameraBoxSize: cameraBoxSize);
    }

    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return _HomeCameraPlaceholder(cameraBoxSize: cameraBoxSize);
    }

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

class _HomeCameraPlaceholder extends StatelessWidget {
  const _HomeCameraPlaceholder({required this.cameraBoxSize});

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
