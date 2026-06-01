import 'dart:convert';

import '../../domain/entities/daily_safety_record.dart';
import '../../domain/entities/my_reaction.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_media.dart';
import '../../domain/entities/post_owner.dart';
import '../../domain/entities/post_page.dart';
import '../../domain/entities/post_reaction_icon.dart';
import '../../domain/entities/reaction_summary.dart';
import '../../domain/entities/post_visibility.dart';
import '../local_models/post_cache.dart';
import '../models/post_model.dart';
import '../models/post_page_model.dart';

String postListScopeKey({
  required String cacheScopeUserId,
  required String feedType,
  String? friendId,
}) {
  final normalizedFriendId = friendId?.trim();
  final suffix = normalizedFriendId == null || normalizedFriendId.isEmpty
      ? ''
      : ':$normalizedFriendId';
  return '${cacheScopeUserId.trim()}:${feedType.trim()}$suffix';
}

String postCacheKey({required String listScopeKey, required String postId}) {
  return '${listScopeKey.trim()}:${postId.trim()}';
}

extension PostToCacheMapper on Post {
  PostCache toCache({
    required String listScopeKey,
    required String cacheScopeUserId,
    required int sortOrder,
    required DateTime cachedAtUtc,
  }) {
    return PostCache()
      ..cacheKey = postCacheKey(listScopeKey: listScopeKey, postId: id)
      ..listScopeKey = listScopeKey.trim()
      ..cacheScopeUserId = cacheScopeUserId.trim()
      ..postId = id
      ..sortOrder = sortOrder
      ..postJson = jsonEncode(toCacheJson())
      ..cachedAtUtc = cachedAtUtc.toUtc();
  }

  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'id': id,
      'ownerUserId': ownerUserId,
      'owner': owner?.toCacheJson(),
      'media': media.toCacheJson(),
      'caption': caption,
      'visibility': visibility.value,
      'status': status,
      'createdAtUtc': createdAtUtc.toUtc().toIso8601String(),
      'updatedAtUtc': updatedAtUtc?.toUtc().toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'dailySafetyRecordId': dailySafetyRecordId,
      'dailySafetyRecord': dailySafetyRecord?.toCacheJson(),
      'reactionSummary': reactionSummary.toCacheJson(),
      'myReaction': myReaction?.toCacheJson(),
    };
  }
}

extension PostCacheToDomainMapper on PostCache {
  Post toDomain() {
    final decoded = jsonDecode(postJson);
    final json = decoded is Map<String, dynamic>
        ? decoded
        : const <String, dynamic>{};
    return PostModel.fromJson(json);
  }
}

extension PostCachesToPageMapper on List<PostCache> {
  PostPage toPostPage({required String? nextCursor}) {
    final sorted = [...this]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return PostPageModel(
      items: sorted.map((cache) => cache.toDomain()).toList(),
      nextCursor: nextCursor,
    );
  }
}

extension _PostOwnerCacheJson on PostOwner {
  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'id': id,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
  }
}

extension _PostMediaCacheJson on PostMedia {
  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'type': type,
      'thumbnailUrl': thumbnailUrl,
      'durationSeconds': durationSeconds,
      'width': width,
      'height': height,
    };
  }
}

extension _DailySafetyRecordCacheJson on DailySafetyRecord {
  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'date': date,
      'status': status,
      'deadlineAtUtc': deadlineAtUtc?.toUtc().toIso8601String(),
      'checkedInAtUtc': checkedInAtUtc?.toUtc().toIso8601String(),
      'markedMissedAtUtc': markedMissedAtUtc?.toUtc().toIso8601String(),
      'reminderSentAtUtc': reminderSentAtUtc?.toUtc().toIso8601String(),
      'resolvedAtUtc': resolvedAtUtc?.toUtc().toIso8601String(),
      'lastEvaluatedAtUtc': lastEvaluatedAtUtc?.toUtc().toIso8601String(),
    };
  }
}

extension _ReactionSummaryCacheJson on ReactionSummary {
  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'totalCount': totalCount,
      'icons': {
        for (final entry in icons.entries) entry.key.value: entry.value,
      },
    };
  }
}

extension _MyReactionCacheJson on MyReaction {
  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{'icon': icon.value};
  }
}
