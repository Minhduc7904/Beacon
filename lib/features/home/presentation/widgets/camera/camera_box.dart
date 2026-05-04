import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';

class CameraBox extends ConsumerWidget {
  const CameraBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraBoxSize = _cameraBoxHeight(context);

    return Container(
      width: double.infinity,
      height: cameraBoxSize,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: _HomeCameraPreview(cameraBoxSize: cameraBoxSize),
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: AppColors.sky400, width: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _cameraBoxHeight(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width - 40).clamp(240.0, 420.0);
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
