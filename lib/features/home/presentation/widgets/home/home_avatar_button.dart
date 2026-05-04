import 'package:flutter/material.dart';

import '../../../../../core/widgets/image/user_avatar.dart';

class HomeAvatarButton extends StatelessWidget {
  const HomeAvatarButton({
    super.key,
    required this.avatarUrl,
    required this.givenName,
    required this.onPressed,
  });

  final String? avatarUrl;
  final String? givenName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        child: UserAvatar(
          avatarUrl: avatarUrl,
          givenName: givenName,
          size: 34,
          backgroundColor: colorScheme.surface,
        ),
      ),
    );
  }
}
