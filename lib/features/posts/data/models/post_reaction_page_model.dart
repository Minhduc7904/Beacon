import '../../domain/entities/post_reaction_page.dart';
import '../../domain/entities/reaction_summary.dart';
import 'post_reaction_detail_model.dart';
import 'reaction_summary_model.dart';

class PostReactionPageModel extends PostReactionPage {
  const PostReactionPageModel({
    required super.items,
    required super.summary,
    required super.nextCursor,
    required super.hasMore,
  });

  factory PostReactionPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final rawSummary = json['summary'];

    return PostReactionPageModel(
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(PostReactionDetailModel.fromJson)
                .toList(growable: false)
          : const [],
      summary: rawSummary is Map<String, dynamic>
          ? ReactionSummaryModel.fromJson(rawSummary)
          : const ReactionSummary.empty(),
      nextCursor: json['nextCursor']?.toString(),
      hasMore: json['hasMore'] == true,
    );
  }
}
