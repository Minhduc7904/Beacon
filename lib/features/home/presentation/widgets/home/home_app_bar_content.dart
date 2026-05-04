import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeAvatarButton(
              avatarUrl: avatarUrl,
              givenName: givenName,
              onPressed: onOpenProfile,
              circleSize: 40,
              avatarSize: 28,
              circleColor: AppColors.sky400,
            ),
            HomeStreakChip(days: streakDays),
            HomeChatButton(
              unreadCount: unreadMessages,
              onPressed: onOpenMessages,
              size: 40,
              iconSize: 20,
              backgroundColor: AppColors.sky400,
              iconColor: AppColors.ink400,
            ),
          ],
        ),
      ),
    );
  }
}
