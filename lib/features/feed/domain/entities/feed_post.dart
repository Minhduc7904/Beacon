import 'feed_reaction.dart';

class FeedPost {
  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final String imageUrl;
  final String? caption;
  final DateTime createdAt;
  final List<FeedReaction> reactions;
  final ReactionType? myReaction;

  const FeedPost({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    required this.imageUrl,
    this.caption,
    required this.createdAt,
    this.reactions = const [],
    this.myReaction,
  });

  FeedPost copyWith({
    String? id,
    String? authorName,
    String? authorAvatarUrl,
    String? imageUrl,
    String? caption,
    DateTime? createdAt,
    List<FeedReaction>? reactions,
    ReactionType? myReaction,
    bool clearMyReaction = false,
  }) {
    return FeedPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      reactions: reactions ?? this.reactions,
      myReaction: clearMyReaction ? null : (myReaction ?? this.myReaction),
    );
  }
}
