import '../../domain/entities/post.dart';
import '../../domain/entities/post_visibility.dart';
import '../../domain/entities/reaction_summary.dart';
import 'my_reaction_model.dart';
import 'post_media_model.dart';
import 'post_owner_model.dart';
import 'reaction_summary_model.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.ownerUserId,
    required super.owner,
    required super.media,
    required super.caption,
    required super.visibility,
    required super.status,
    required super.createdAtUtc,
    required super.updatedAtUtc,
    required super.reactionSummary,
    required super.myReaction,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final ownerJson = json['owner'];
    final mediaJson = json['media'];
    final reactionSummaryJson = json['reactionSummary'];
    final myReactionJson = json['myReaction'];

    return PostModel(
      id: json['id']?.toString() ?? '',
      ownerUserId: json['ownerUserId']?.toString() ?? '',
      owner: ownerJson is Map<String, dynamic>
          ? PostOwnerModel.fromJson(ownerJson)
          : null,
      media: mediaJson is Map<String, dynamic>
          ? PostMediaModel.fromJson(mediaJson)
          : const PostMediaModel(
              id: '',
              url: '',
              type: '',
              thumbnailUrl: null,
              durationSeconds: null,
              width: null,
              height: null,
            ),
      caption: json['caption']?.toString(),
      visibility: postVisibilityFromValue(json['visibility']?.toString()),
      status: json['status']?.toString() ?? '',
      createdAtUtc:
          _toDate(json['createdAtUtc']) ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAtUtc: _toDate(json['updatedAtUtc']),
      reactionSummary: reactionSummaryJson is Map<String, dynamic>
          ? ReactionSummaryModel.fromJson(reactionSummaryJson)
          : const ReactionSummary.empty(),
      myReaction: myReactionJson is Map<String, dynamic>
          ? MyReactionModel.fromJson(myReactionJson)
          : null,
    );
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }
}
