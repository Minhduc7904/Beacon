import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/widgets/button/icon_circle_button.dart';
import 'unread_badge.dart';

class HomeChatButton extends StatelessWidget {
  const HomeChatButton({
    super.key,
    required this.unreadCount,
    required this.onPressed,
    this.size = 40,
    this.iconSize = 24,
    this.backgroundColor,
    this.iconColor,
  });

  final int unreadCount;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final effectiveBackground = backgroundColor ?? AppColors.sky400;
    final effectiveIcon = iconColor ?? AppColors.ink400;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: IconCircleButton(
              icon: AppIcons.chat,
              size: size,
              iconSize: iconSize,
              backgroundColor: effectiveBackground,
              borderColor: effectiveBackground,
              borderWidth: 0,
              iconColor: effectiveIcon,
              onPressed: onPressed,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -2,
              right: -4,
              child: UnreadBadge(count: unreadCount),
            ),
        ],
      ),
    );
  }
}
