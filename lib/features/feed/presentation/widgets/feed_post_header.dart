import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/feed_post.dart';

class FeedPostHeader extends StatelessWidget {
  const FeedPostHeader({super.key, required this.post, this.trailing});

  final FeedPost post;
  final Widget? trailing;

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Vua xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phut truoc';
    if (diff.inHours < 24) return '${diff.inHours} gio truoc';
    return '${diff.inDays} ngay truoc';
  }

  String _givenNameOnly(String authorName) {
    final parts = authorName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      return authorName;
    }

    return parts.last;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserAvatar(
                    avatarUrl: post.authorAvatarUrl,
                    givenName: post.authorName,
                    size: 36,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: AppText(
                      _givenNameOnly(post.authorName),
                      size: AppTextSize.small,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.bold,
                      color: colorScheme.onSurface,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
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
          ),
          if (trailing != null) Positioned(right: 0, child: trailing!),
        ],
      ),
    );
  }
}
