import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';

class CameraFlashButton extends ConsumerWidget {
  const CameraFlashButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(homeNotifierProvider.notifier).cameraController;
    final isEnabled = controller != null && controller.value.isInitialized;

    return SizedBox(
      width: 60,
      height: 60,
      child: Material(
        color: AppColors.sky100,
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: isEnabled
              ? () => ref.read(homeNotifierProvider.notifier).toggleFlash()
              : null,
          icon: const Icon(
            Icons.bolt_rounded,
            size: 36,
            color: AppColors.amber400,
          ),
        ),
      ),
    );
  }
}
