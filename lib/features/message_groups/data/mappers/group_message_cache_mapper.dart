import 'dart:convert';

import '../../../posts/data/mappers/post_cache_mapper.dart';
import '../../domain/entities/group_message.dart';
import '../local_models/group_message_cache.dart';
import '../models/group_message_model.dart';

String groupMessageCacheKey({
  required String cacheScopeUserId,
  required String groupId,
  required String messageId,
}) {
  return '${cacheScopeUserId.trim()}:${groupId.trim()}:${messageId.trim()}';
}

String groupMessageListCacheKey({
  required String cacheScopeUserId,
  required String groupId,
}) {
  return '${cacheScopeUserId.trim()}:${groupId.trim()}';
}

extension GroupMessageToCacheMapper on GroupMessage {
  GroupMessageCache toCache({
    required String cacheScopeUserId,
    required DateTime cachedAtUtc,
  }) {
    final normalizedScope = cacheScopeUserId.trim();
    return GroupMessageCache()
      ..cacheKey = groupMessageCacheKey(
        cacheScopeUserId: normalizedScope,
        groupId: groupId,
        messageId: id,
      )
      ..cacheScopeUserId = normalizedScope
      ..groupId = groupId
      ..messageId = id
      ..createdAtUtc = createdAtUtc?.toUtc()
      ..messageJson = jsonEncode(toCacheJson())
      ..cachedAtUtc = cachedAtUtc.toUtc();
  }

  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'senderDisplayName': senderDisplayName,
      'senderFamilyName': senderFamilyName,
      'senderGivenName': senderGivenName,
      'content': content,
      'createdAtUtc': createdAtUtc?.toUtc().toIso8601String(),
      'postId': postId,
      'post': post?.toCacheJson(),
      'type': type.value,
      'metadataJson': metadataJson,
    };
  }
}

extension GroupMessageCacheToDomainMapper on GroupMessageCache {
  GroupMessage toDomain() {
    final decoded = jsonDecode(messageJson);
    final json = decoded is Map<String, dynamic>
        ? decoded
        : const <String, dynamic>{};
    return GroupMessageModel.fromJson(json);
  }
}
