import 'post_reaction_icon.dart';

class ReactionSummary {
  final int totalCount;
  final Map<PostReactionIcon, int> icons;

  const ReactionSummary({required this.totalCount, required this.icons});

  const ReactionSummary.empty() : totalCount = 0, icons = const {};
}
