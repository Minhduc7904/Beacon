import 'package:flutter/material.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';

class PostPreviewLocationButton extends StatelessWidget {
  const PostPreviewLocationButton({
    super.key,
    required this.isEnabled,
    required this.isLoading,
    required this.isSelected,
    required this.onPressed,
  });

  final bool isEnabled;
  final bool isLoading;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected ? AppColors.teal100 : AppColors.sky100;
    final borderColor = isSelected ? AppColors.teal500 : AppColors.teal300;
    final iconColor = isSelected ? AppColors.teal500 : AppColors.ink500;

    return InkWell(
      onTap: isEnabled ? onPressed : null,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 48,
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isEnabled ? backgroundColor : AppColors.sky300,
            shape: BoxShape.circle,
            border: Border.all(
              color: isEnabled ? borderColor : AppColors.sky400,
              width: 1.4,
            ),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.teal500,
                    ),
                  )
                : AppIcon(
                    AppIcons.mapPin,
                    color: isEnabled ? iconColor : AppColors.sky600,
                    size: 22,
                    semanticLabel: isSelected
                        ? 'Bỏ chia sẻ vị trí'
                        : 'Chia sẻ vị trí',
                  ),
          ),
        ),
      ),
    );
  }
}
