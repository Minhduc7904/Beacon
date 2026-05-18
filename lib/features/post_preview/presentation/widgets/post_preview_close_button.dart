import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';

class PostPreviewCloseButton extends ConsumerWidget {
  const PostPreviewCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUploading = ref.watch(
      postPreviewNotifierProvider.select((value) => value.isUploading),
    );

    return InkWell(
      onTap: isUploading ? null : () => context.pop(false),
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 48,
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isUploading ? AppColors.sky300 : AppColors.sky100,
            shape: BoxShape.circle,
            border: Border.all(
              color: isUploading ? AppColors.sky400 : AppColors.teal300,
              width: 1.4,
            ),
          ),
          child: AppIcon(
            AppIcons.close,
            color: isUploading ? AppColors.sky600 : AppColors.ink500,
            size: 22,
          ),
        ),
      ),
    );
  }
}
