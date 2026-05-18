import 'my_reaction.dart';
import 'reaction_summary.dart';

class PostReactionResult {
  final String postId;
  final MyReaction? myReaction;
  final ReactionSummary reactionSummary;

  const PostReactionResult({
    required this.postId,
    required this.myReaction,
    required this.reactionSummary,
  });
}
