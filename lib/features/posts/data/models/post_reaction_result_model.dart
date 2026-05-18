import '../../domain/entities/post_reaction_result.dart';
import '../../domain/entities/reaction_summary.dart';
import 'my_reaction_model.dart';
import 'reaction_summary_model.dart';

class PostReactionResultModel extends PostReactionResult {
  const PostReactionResultModel({
    required super.postId,
    required super.myReaction,
    required super.reactionSummary,
  });

  factory PostReactionResultModel.fromJson(Map<String, dynamic> json) {
    final myReactionJson = json['myReaction'];
    final reactionSummaryJson = json['reactionSummary'];

    return PostReactionResultModel(
      postId: json['postId']?.toString() ?? '',
      myReaction: myReactionJson is Map<String, dynamic>
          ? MyReactionModel.fromJson(myReactionJson)
          : null,
      reactionSummary: reactionSummaryJson is Map<String, dynamic>
          ? ReactionSummaryModel.fromJson(reactionSummaryJson)
          : const ReactionSummary.empty(),
    );
  }
}
