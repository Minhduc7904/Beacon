import 'package:flutter/material.dart';

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
  });

  final FeedPost post;
  final void Function(String postId, ReactionType type) onReact;

  Map<ReactionType, int> _computeReactionCounts() {
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
          FeedPostHeader(post: post),
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
            onReact: (type) => onReact(post.id, type),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
