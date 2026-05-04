import 'package:flutter/material.dart';

import 'home_avatar_button.dart';
import 'home_chat_button.dart';
import 'home_streak_chip.dart';

class HomeAppBarContent extends StatelessWidget {
  const HomeAppBarContent({
    super.key,
    required this.avatarUrl,
    required this.givenName,
    required this.streakDays,
    required this.unreadMessages,
    required this.onOpenProfile,
    required this.onOpenMessages,
  });

  final String? avatarUrl;
  final String? givenName;
  final int streakDays;
  final int unreadMessages;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenMessages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeAvatarButton(
              avatarUrl: avatarUrl,
              givenName: givenName,
              onPressed: onOpenProfile,
            ),
            HomeStreakChip(days: streakDays),
            HomeChatButton(
              unreadCount: unreadMessages,
              onPressed: onOpenMessages,
            ),
          ],
        ),
      ),
    );
  }
}
