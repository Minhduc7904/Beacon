import 'package:flutter/material.dart';

import '../../../../../core/widgets/image/user_avatar.dart';

class HomeAvatarButton extends StatelessWidget {
  const HomeAvatarButton({
    super.key,
    required this.avatarUrl,
    required this.givenName,
    required this.onPressed,
    this.circleSize = 40,
    this.avatarSize = 36,
    this.circleColor,
    this.avatarBackgroundColor,
    this.borderColor,
    this.borderWidth = 0,
  });

  final String? avatarUrl;
  final String? givenName;
  final VoidCallback onPressed;
  final double circleSize;
  final double avatarSize;
  final Color? circleColor;
  final Color? avatarBackgroundColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveCircleColor = circleColor ?? colorScheme.surfaceVariant;
    final effectiveAvatarBackground =
        avatarBackgroundColor ?? colorScheme.surface;
    final effectiveBorderColor =
        borderColor ?? colorScheme.outline.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: effectiveCircleColor,
          border: borderWidth > 0
              ? Border.all(color: effectiveBorderColor, width: borderWidth)
              : null,
        ),
        alignment: Alignment.center,
        child: UserAvatar(
          avatarUrl: avatarUrl,
          givenName: givenName,
          size: avatarSize,
          backgroundColor: effectiveAvatarBackground,
        ),
      ),
    );
  }
}
