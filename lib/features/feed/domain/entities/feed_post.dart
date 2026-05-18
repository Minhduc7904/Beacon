import 'feed_reaction.dart';
import '../../../posts/domain/entities/post_visibility.dart';

class FeedPost {
  final String id;
  final String ownerUserId;
  final String authorName;
  final String? authorAvatarUrl;
  final String imageUrl;
  final String? caption;
  final PostVisibility visibility;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final bool hasDailySafetyRecord;
  final List<FeedReaction> reactions;
  final Map<ReactionType, int> reactionCounts;
  final ReactionType? myReaction;

  const FeedPost({
    required this.id,
    this.ownerUserId = '',
    required this.authorName,
    this.authorAvatarUrl,
    required this.imageUrl,
    this.caption,
    this.visibility = PostVisibility.friends,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.hasDailySafetyRecord = false,
    this.reactions = const [],
    this.reactionCounts = const {},
    this.myReaction,
  });

  FeedPost copyWith({
    String? id,
    String? ownerUserId,
    String? authorName,
    String? authorAvatarUrl,
    String? imageUrl,
    String? caption,
    PostVisibility? visibility,
    DateTime? createdAt,
    double? latitude,
    bool clearLatitude = false,
    double? longitude,
    bool clearLongitude = false,
    bool? hasDailySafetyRecord,
    List<FeedReaction>? reactions,
    Map<ReactionType, int>? reactionCounts,
    ReactionType? myReaction,
    bool clearMyReaction = false,
  }) {
    return FeedPost(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      latitude: clearLatitude ? null : (latitude ?? this.latitude),
      longitude: clearLongitude ? null : (longitude ?? this.longitude),
      hasDailySafetyRecord: hasDailySafetyRecord ?? this.hasDailySafetyRecord,
      reactions: reactions ?? this.reactions,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      myReaction: clearMyReaction ? null : (myReaction ?? this.myReaction),
    );
  }
}
