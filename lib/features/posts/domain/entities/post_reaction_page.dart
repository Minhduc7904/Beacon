import 'post_reaction_detail.dart';
import 'reaction_summary.dart';

class PostReactionPage {
  final List<PostReactionDetail> items;
  final ReactionSummary summary;
  final String? nextCursor;
  final bool hasMore;

  const PostReactionPage({
    required this.items,
    required this.summary,
    required this.nextCursor,
    required this.hasMore,
  });

  const PostReactionPage.empty()
    : items = const [],
      summary = const ReactionSummary.empty(),
      nextCursor = null,
      hasMore = false;
}
