import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../../friends/domain/entities/friend_profile.dart';

class HomeFeedFilterAllFriendsItem extends StatelessWidget {
  const HomeFeedFilterAllFriendsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeFeedFilterMenuRow(
      leading: _AllFriendsIcon(),
      label: 'Tất cả bạn bè',
    );
  }
}

class HomeFeedFilterMyPostsItem extends StatelessWidget {
  const HomeFeedFilterMyPostsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeFeedFilterMenuRow(leading: _MyPostsIcon(), label: 'Tôi');
  }
}

class HomeFeedFilterFriendItem extends StatelessWidget {
  const HomeFeedFilterFriendItem({super.key, required this.friend});

  final FriendProfile friend;

  @override
  Widget build(BuildContext context) {
    final name = friend.fullName.trim().isEmpty
        ? 'Bạn bè'
        : friend.fullName.trim();

    return _HomeFeedFilterMenuRow(
      leading: UserAvatar(
        avatarUrl: friend.avatarUrl,
        givenName: friend.givenName,
        size: 36,
      ),
      label: name,
    );
  }
}

class HomeFeedFilterStatusItem extends StatelessWidget {
  const HomeFeedFilterStatusItem({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Center(
        child: AppText(
          label,
          size: AppTextSize.small,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.regular,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _HomeFeedFilterMenuRow extends StatelessWidget {
  const _HomeFeedFilterMenuRow({required this.leading, required this.label});

  final Widget leading;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 58,
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              label,
              size: AppTextSize.small,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.medium,
              color: colorScheme.onSurface,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppIcon(
            AppIcons.caretRight,
            size: 18,
            color: colorScheme.onSurface.withValues(alpha: 0.52),
          ),
        ],
      ),
    );
  }
}

class _AllFriendsIcon extends StatelessWidget {
  const _AllFriendsIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.sky100,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: AppIcon(AppIcons.users, size: 18, color: AppColors.ink500),
      ),
    );
  }
}

class _MyPostsIcon extends StatelessWidget {
  const _MyPostsIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.sky100,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: AppIcon(AppIcons.user, size: 18, color: AppColors.ink500),
      ),
    );
  }
}
