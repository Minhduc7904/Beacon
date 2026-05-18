import 'package:flutter/material.dart';

import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icon_data.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/feed_post.dart';
import '../../domain/entities/feed_reaction.dart';
import 'feed_image_box.dart';
import 'feed_post_header.dart';
import 'feed_reaction_bar.dart';

/// A single full-screen feed card — vertically swipeable like TikTok / Locket.
/// Shows: author header, image, caption, reaction bar.
class FeedPostCard extends StatelessWidget {
  const FeedPostCard({
    super.key,
    required this.post,
    required this.onReact,
    this.canReact = true,
    this.canManage = false,
    this.onEdit,
    this.onDelete,
    this.onViewReactions,
  });

  final FeedPost post;
  final bool canReact;
  final bool canManage;
  final void Function(String postId, ReactionType type) onReact;
  final ValueChanged<FeedPost>? onEdit;
  final ValueChanged<FeedPost>? onDelete;
  final ValueChanged<FeedPost>? onViewReactions;

  Map<ReactionType, int> _computeReactionCounts() {
    if (post.reactionCounts.isNotEmpty) {
      return post.reactionCounts;
    }

    final counts = <ReactionType, int>{};
    for (final r in post.reactions) {
      counts[r.type] = (counts[r.type] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(),

          // ── Author header ──
          FeedPostHeader(
            post: post,
            trailing: canManage
                ? _FeedPostOwnerMenu(
                    onViewReactions: () => onViewReactions?.call(post),
                    onEdit: () => onEdit?.call(post),
                    onDelete: () => onDelete?.call(post),
                  )
                : null,
          ),
          const SizedBox(height: 16),

          // ── Image ──
          FeedImageBox(post: post),
          const SizedBox(height: 16),

          // ── Caption ──
          if (post.caption != null && post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppText(
                post.caption!,
                size: AppTextSize.small,
                spacing: AppTextSpacing.normal,
                weight: AppTextWeight.regular,
                color: colorScheme.onSurface,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // ── Reactions ──
          FeedReactionBar(
            myReaction: post.myReaction,
            reactionCounts: _computeReactionCounts(),
            enabled: canReact,
            onReact: (type) => onReact(post.id, type),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _FeedPostOwnerMenu extends StatelessWidget {
  const _FeedPostOwnerMenu({
    required this.onViewReactions,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onViewReactions;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<_OwnerPostAction>(
      tooltip: 'Quản lý bài đăng',
      icon: AppIcon(
        AppIcons.moreVertical,
        color: colorScheme.onSurface.withValues(alpha: 0.72),
        size: 22,
      ),
      onSelected: (action) {
        switch (action) {
          case _OwnerPostAction.reactions:
            onViewReactions();
          case _OwnerPostAction.edit:
            onEdit();
          case _OwnerPostAction.delete:
            onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<_OwnerPostAction>(
          value: _OwnerPostAction.reactions,
          child: _OwnerPostMenuItem(
            icon: AppIcons.users,
            label: 'Người đã react',
            color: colorScheme.onSurface,
          ),
        ),
        PopupMenuItem<_OwnerPostAction>(
          value: _OwnerPostAction.edit,
          child: _OwnerPostMenuItem(
            icon: AppIcons.pencil,
            label: 'Sửa',
            color: colorScheme.onSurface,
          ),
        ),
        PopupMenuItem<_OwnerPostAction>(
          value: _OwnerPostAction.delete,
          child: _OwnerPostMenuItem(
            icon: AppIcons.trash,
            label: 'Xóa',
            color: colorScheme.error,
          ),
        ),
      ],
    );
  }
}

enum _OwnerPostAction { reactions, edit, delete }

class _OwnerPostMenuItem extends StatelessWidget {
  const _OwnerPostMenuItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final AppIconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppIcon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        AppText(
          label,
          size: AppTextSize.small,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.regular,
          color: color,
        ),
      ],
    );
  }
}
