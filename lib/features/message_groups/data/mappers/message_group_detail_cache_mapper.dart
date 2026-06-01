import 'dart:convert';

import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_member.dart';
import '../local_models/message_group_detail_cache.dart';
import '../models/message_group_detail_model.dart';

String messageGroupDetailCacheKey({
  required String cacheScopeUserId,
  required String groupId,
}) {
  return '${cacheScopeUserId.trim()}:${groupId.trim()}';
}

extension MessageGroupDetailToCacheMapper on MessageGroupDetail {
  MessageGroupDetailCache toCache({
    required String cacheScopeUserId,
    required DateTime cachedAtUtc,
  }) {
    final normalizedScope = cacheScopeUserId.trim();
    return MessageGroupDetailCache()
      ..cacheKey = messageGroupDetailCacheKey(
        cacheScopeUserId: normalizedScope,
        groupId: groupId,
      )
      ..cacheScopeUserId = normalizedScope
      ..groupId = groupId
      ..detailJson = jsonEncode(toCacheJson())
      ..cachedAtUtc = cachedAtUtc.toUtc();
  }

  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'groupId': groupId,
      'isPrivate': isPrivate,
      'createdAtUtc': createdAtUtc?.toUtc().toIso8601String(),
      'displayName': displayName,
      'displayAvatarUrl': displayAvatarUrl,
      'requireApprovalToAddMembers': requireApprovalToAddMembers,
      'isMuted': isMuted,
      'members': members.map(_memberToCacheJson).toList(),
    };
  }

  Map<String, dynamic> _memberToCacheJson(MessageGroupMember member) {
    return <String, dynamic>{
      'userId': member.userId,
      'familyName': member.familyName,
      'givenName': member.givenName,
      'customName': member.customName,
      'avatarUrl': member.avatarUrl,
      'role': member.role,
      'status': _statusValue(member.status),
      'lastSeenMessageId': member.lastSeenMessageId,
      'lastSeenAtUtc': member.lastSeenAtUtc?.toUtc().toIso8601String(),
    };
  }

  int _statusValue(MessageGroupMemberStatus status) {
    return status == MessageGroupMemberStatus.pendingApproval ? 1 : 0;
  }
}

extension MessageGroupDetailCacheToDomainMapper on MessageGroupDetailCache {
  MessageGroupDetail toDomain() {
    final decoded = jsonDecode(detailJson);
    final json = decoded is Map<String, dynamic>
        ? decoded
        : const <String, dynamic>{};
    return MessageGroupDetailModel.fromJson(json);
  }
}
