import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';

class CameraSwitchButton extends ConsumerWidget {
  const CameraSwitchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Material(
        color: AppColors.sky100,
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: () =>
              ref.read(homeNotifierProvider.notifier).switchCamera(),
          icon: const Icon(
            Icons.cameraswitch_rounded,
            size: 36,
            color: AppColors.teal400,
          ),
        ),
      ),
    );
  }
}
