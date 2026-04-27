import 'package:flutter/material.dart';

class IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? iconColor;

  const IconCircleButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 44,
    this.iconSize = 20,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBackground = backgroundColor ?? colorScheme.surface;
    final effectiveBorder = borderColor ?? colorScheme.outline;
    final effectiveIcon = iconColor ?? colorScheme.onSurface;

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: effectiveBackground,
              border: Border.all(color: effectiveBorder, width: borderWidth),
            ),
            child: Icon(icon, size: iconSize, color: effectiveIcon),
          ),
        ),
      ),
    );
  }
}
