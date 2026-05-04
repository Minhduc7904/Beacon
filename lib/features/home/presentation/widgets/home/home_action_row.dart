import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconCircleButton(
          icon: Icons.emoji_emotions_rounded,
          size: 52,
          iconSize: 22,
          backgroundColor: colorScheme.surface,
          borderColor: colorScheme.outline,
          iconColor: colorScheme.onSurface,
          onPressed: onMoodPressed,
        ),
        _HomeCheckinActionButton(
          isLoading: isCheckingIn,
          isEnabled: canCheckin,
          onPressed: onCheckin,
        ),
        IconCircleButton(
          icon: Icons.camera_alt_rounded,
          size: 52,
          iconSize: 22,
          backgroundColor: colorScheme.surface,
          borderColor: colorScheme.outline,
          iconColor: colorScheme.onSurface,
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
    final colorScheme = Theme.of(context).colorScheme;
    final transparentSurface = colorScheme.surface.withValues(alpha: 0);
    final outerColor = isEnabled
        ? colorScheme.primary
        : colorScheme.outline.withValues(alpha: 0.6);
    final innerRing = isEnabled
        ? colorScheme.primary.withValues(alpha: 0.2)
        : colorScheme.outline.withValues(alpha: 0.2);
    final centerColor = isEnabled ? colorScheme.primary : colorScheme.outline;
    final iconColor = isEnabled ? colorScheme.onPrimary : colorScheme.onSurface;

    return SizedBox(
      width: 92,
      height: 92,
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
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: outerColor, width: 2),
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: innerRing,
                  border: Border.all(
                    color: outerColor.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: centerColor,
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(iconColor),
                          ),
                        )
                      : Icon(
                          Icons.shield_rounded,
                          size: 24,
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
