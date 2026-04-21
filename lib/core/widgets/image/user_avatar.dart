import 'package:flutter/material.dart';

import '../../theme/color/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? givenName;
  final double size;
  final TextStyle? initialStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const UserAvatar({
    super.key,
    required this.avatarUrl,
    required this.givenName,
    this.size = 40,
    this.initialStyle,
    this.backgroundColor,
    this.foregroundColor,
  });

  String get _initial {
    final trimmed = givenName?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '?';
    }

    return trimmed.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? colorScheme.primaryContainer,
      ),
      child: hasAvatar
          ? Image.network(
              avatarUrl!.trim(),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _AvatarInitial(
                initial: _initial,
                style: initialStyle,
                foregroundColor: foregroundColor,
              ),
            )
          : _AvatarInitial(
              initial: _initial,
              style: initialStyle,
              foregroundColor: foregroundColor,
            ),
    );
  }
}

class _AvatarInitial extends StatelessWidget {
  final String initial;
  final TextStyle? style;
  final Color? foregroundColor;

  const _AvatarInitial({
    required this.initial,
    required this.style,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Text(
        initial,
        style:
            style ??
            textTheme.titleMedium?.copyWith(
              color: foregroundColor ?? AppColors.ink500,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
