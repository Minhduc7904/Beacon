import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/feed_post.dart';

/// Displays author avatar, name, and relative timestamp for a feed post.
class FeedPostHeader extends StatelessWidget {
  const FeedPostHeader({super.key, required this.post});

  final FeedPost post;

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        UserAvatar(
          avatarUrl: post.authorAvatarUrl,
          givenName: post.authorName,
          size: 36,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                post.authorName,
                size: AppTextSize.small,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.bold,
                color: colorScheme.onSurface,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppText(
                _formatTime(post.createdAt),
                size: AppTextSize.veryTiny,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.regular,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
