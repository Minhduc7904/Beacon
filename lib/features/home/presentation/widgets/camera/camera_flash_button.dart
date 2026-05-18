import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';

class CameraFlashButton extends ConsumerWidget {
  const CameraFlashButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final isEnabled = state.canToggleFlash;
    final isFlashEnabled = state.isFlashEnabled;

    return SizedBox(
      width: 60,
      height: 60,
      child: Material(
        color: isFlashEnabled ? AppColors.amber400 : AppColors.sky100,
        shape: const CircleBorder(),
        child: IconButton(
          tooltip: isFlashEnabled ? 'Tắt flash' : 'Bật flash',
          onPressed: isEnabled
              ? () => ref.read(homeNotifierProvider.notifier).toggleFlash()
              : null,
          icon: Icon(
            isFlashEnabled ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            size: 36,
            color: isEnabled
                ? (isFlashEnabled ? AppColors.sky100 : AppColors.amber400)
                : AppColors.sky600,
          ),
        ),
      ),
    );
  }
}
