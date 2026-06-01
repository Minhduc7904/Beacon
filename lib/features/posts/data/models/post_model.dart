import '../../../../core/utils/time_utils.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_visibility.dart';
import '../../domain/entities/reaction_summary.dart';
import 'daily_safety_record_model.dart';
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
    required super.latitude,
    required super.longitude,
    required super.dailySafetyRecordId,
    required super.dailySafetyRecord,
    required super.reactionSummary,
    required super.myReaction,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final ownerJson = json['owner'];
    final mediaJson = json['media'];
    final reactionSummaryJson = json['reactionSummary'];
    final myReactionJson = json['myReaction'];
    final dailySafetyRecordJson = json['dailySafetyRecord'];

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
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      dailySafetyRecordId: json['dailySafetyRecordId']?.toString(),
      dailySafetyRecord: dailySafetyRecordJson is Map<String, dynamic>
          ? DailySafetyRecordModel.fromJson(dailySafetyRecordJson)
          : null,
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
    return TimeUtils.tryParseUtc(raw);
  }

  static double? _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '');
  }
}
