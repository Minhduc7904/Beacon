import 'package:flutter/material.dart';

import '../../../../../core/widgets/button/icon_circle_button.dart';
import 'unread_badge.dart';

class HomeChatButton extends StatelessWidget {
  const HomeChatButton({
    super.key,
    required this.unreadCount,
    required this.onPressed,
  });

  final int unreadCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.center,
            child: IconCircleButton(
              icon: Icons.chat_bubble_outline_rounded,
              size: 42,
              iconSize: 19,
              backgroundColor: colorScheme.surface,
              borderColor: colorScheme.outline.withValues(alpha: 0.7),
              iconColor: colorScheme.onSurface,
              onPressed: onPressed,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -1,
              right: -1,
              child: UnreadBadge(count: unreadCount),
            ),
        ],
      ),
    );
  }
}
