import 'my_reaction.dart';
import 'post_media.dart';
import 'post_owner.dart';
import 'post_visibility.dart';
import 'reaction_summary.dart';

class Post {
  final String id;
  final String ownerUserId;
  final PostOwner? owner;
  final PostMedia media;
  final String? caption;
  final PostVisibility visibility;
  final String status;
  final DateTime createdAtUtc;
  final DateTime? updatedAtUtc;
  final ReactionSummary reactionSummary;
  final MyReaction? myReaction;

  const Post({
    required this.id,
    required this.ownerUserId,
    required this.owner,
    required this.media,
    required this.caption,
    required this.visibility,
    required this.status,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    required this.reactionSummary,
    required this.myReaction,
  });

  Post copyWith({
    String? id,
    String? ownerUserId,
    PostOwner? owner,
    bool clearOwner = false,
    PostMedia? media,
    String? caption,
    bool clearCaption = false,
    PostVisibility? visibility,
    String? status,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    bool clearUpdatedAtUtc = false,
    ReactionSummary? reactionSummary,
    MyReaction? myReaction,
    bool clearMyReaction = false,
  }) {
    return Post(
      id: id ?? this.id,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      owner: clearOwner ? null : (owner ?? this.owner),
      media: media ?? this.media,
      caption: clearCaption ? null : (caption ?? this.caption),
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: clearUpdatedAtUtc
          ? null
          : (updatedAtUtc ?? this.updatedAtUtc),
      reactionSummary: reactionSummary ?? this.reactionSummary,
      myReaction: clearMyReaction ? null : (myReaction ?? this.myReaction),
    );
  }
}
