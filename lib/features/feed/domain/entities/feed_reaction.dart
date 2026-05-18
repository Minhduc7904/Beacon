enum ReactionType { heart, haha, like, sad, wow }

class FeedReaction {
  final String id;
  final String userName;
  final ReactionType type;
  final DateTime createdAt;

  const FeedReaction({
    required this.id,
    required this.userName,
    required this.type,
    required this.createdAt,
  });
}
