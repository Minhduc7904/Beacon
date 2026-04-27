enum ReactionType {
  heart,
  fire,
  laugh,
  sad,
  wow,
  clap,
}

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
