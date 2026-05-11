import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/widgets/button/icon_circle_button.dart';

class HomeActionRow extends StatelessWidget {
  const HomeActionRow({
    super.key,
    required this.isCheckingIn,
    required this.canCheckin,
    required this.onCheckin,
    required this.onMoodPressed,
    required this.onCameraPressed,
  });

  final bool isCheckingIn;
  final bool canCheckin;
  final VoidCallback? onCheckin;
  final VoidCallback onMoodPressed;
  final VoidCallback onCameraPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconCircleButton(
          icon: AppIcons.moodHappyPhosphor,
          size: 60,
          iconSize: 32,
          backgroundColor: AppColors.sky100,
          borderColor: AppColors.teal100,
          iconColor: AppColors.teal400,
          borderWidth: 4,
          onPressed: onMoodPressed,
        ),
        _HomeCheckinActionButton(
          isLoading: isCheckingIn,
          isEnabled: canCheckin,
          onPressed: onCheckin,
        ),
        IconCircleButton(
          icon: AppIcons.camera,
          size: 60,
          iconSize: 32,
          backgroundColor: AppColors.sky100,
          borderColor: AppColors.teal100,
          iconColor: AppColors.teal400,
          borderWidth: 4,
          onPressed: onCameraPressed,
        ),
      ],
    );
  }
}

class _HomeCheckinActionButton extends StatelessWidget {
  const _HomeCheckinActionButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final transparentSurface = AppColors.sky100.withValues(alpha: 0);
    final stateAlpha = isEnabled ? 1.0 : 0.45;
    final outerColor = AppColors.teal200.withValues(alpha: stateAlpha);
    final innerColor = AppColors.teal400.withValues(alpha: stateAlpha);
    final iconColor = AppColors.sky100.withValues(alpha: stateAlpha);

    return SizedBox(
      width: 128,
      height: 128,
      child: Material(
        color: transparentSurface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: outerColor, width: 4),
                ),
              ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: innerColor,
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(iconColor),
                          ),
                        )
                      : AppIcon(
                          AppIcons.shieldPhosphor,
                          size: 60,
                          color: iconColor,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
