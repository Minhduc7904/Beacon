import '../../domain/entities/group_message.dart';
import '../../domain/entities/group_message_page.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_page.dart';

abstract class MessageGroupsLocalDatasource {
  Stream<List<MessageGroup>> watchMessageGroups({
    required String cacheScopeUserId,
  });

  Future<MessageGroupPage?> getCachedMessageGroups({
    required String cacheScopeUserId,
  });

  Future<void> upsertMessageGroups({
    required String cacheScopeUserId,
    required MessageGroupPage page,
    required bool isFirstPage,
    required DateTime cachedAtUtc,
  });

  Future<void> upsertMessageGroup({
    required String cacheScopeUserId,
    required MessageGroup group,
    required DateTime cachedAtUtc,
  });

  Future<void> deleteMessageGroup({
    required String cacheScopeUserId,
    required String groupId,
  });

  Stream<MessageGroupDetail?> watchMessageGroupDetail({
    required String cacheScopeUserId,
    required String groupId,
  });

  Future<MessageGroupDetail?> getCachedMessageGroupDetail({
    required String cacheScopeUserId,
    required String groupId,
  });

  Future<void> upsertMessageGroupDetail({
    required String cacheScopeUserId,
    required MessageGroupDetail detail,
    required DateTime cachedAtUtc,
  });

  Stream<List<GroupMessage>> watchGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
  });

  Future<GroupMessagePage?> getCachedGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
  });

  Future<void> upsertGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
    required GroupMessagePage page,
    required bool isFirstPage,
    required DateTime cachedAtUtc,
  });

  Future<void> upsertGroupMessage({
    required String cacheScopeUserId,
    required GroupMessage message,
    required DateTime cachedAtUtc,
  });

  Future<void> deleteGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
  });
}
