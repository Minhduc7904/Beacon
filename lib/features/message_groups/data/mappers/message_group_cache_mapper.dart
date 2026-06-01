import 'dart:convert';

import '../../domain/entities/message_group.dart';
import '../local_models/message_group_cache.dart';
import '../models/message_group_model.dart';

String messageGroupCacheKey({
  required String cacheScopeUserId,
  required String groupId,
}) {
  return '${cacheScopeUserId.trim()}:${groupId.trim()}';
}

extension MessageGroupToCacheMapper on MessageGroup {
  MessageGroupCache toCache({
    required String cacheScopeUserId,
    required DateTime cachedAtUtc,
  }) {
    final normalizedScope = cacheScopeUserId.trim();
    return MessageGroupCache()
      ..cacheKey = messageGroupCacheKey(
        cacheScopeUserId: normalizedScope,
        groupId: groupId,
      )
      ..cacheScopeUserId = normalizedScope
      ..groupId = groupId
      ..lastMessageAtUtc = lastMessageAtUtc?.toUtc()
      ..createdAtUtc = createdAtUtc?.toUtc()
      ..groupJson = jsonEncode(toCacheJson())
      ..cachedAtUtc = cachedAtUtc.toUtc();
  }

  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'groupId': groupId,
      'isPrivate': isPrivate,
      'createdAtUtc': createdAtUtc?.toUtc().toIso8601String(),
      'lastMessageId': lastMessageId,
      'lastMessageContent': lastMessageContent,
      'lastMessageAtUtc': lastMessageAtUtc?.toUtc().toIso8601String(),
      'lastMessageSenderFamilyName': lastMessageSenderFamilyName,
      'lastMessageSenderGivenName': lastMessageSenderGivenName,
      'lastSeenMessageId': lastSeenMessageId,
      'isSeenLatest': isSeenLatest,
      'unreadCount': unreadCount,
      'displayName': displayName,
      'displayAvatarUrl': displayAvatarUrl,
      'peerUserId': peerUserId,
      'requireApprovalToAddMembers': requireApprovalToAddMembers,
    };
  }
}

extension MessageGroupCacheToDomainMapper on MessageGroupCache {
  MessageGroup toDomain() {
    final decoded = jsonDecode(groupJson);
    final json = decoded is Map<String, dynamic>
        ? decoded
        : const <String, dynamic>{};
    return MessageGroupModel.fromJson(json);
  }
}
