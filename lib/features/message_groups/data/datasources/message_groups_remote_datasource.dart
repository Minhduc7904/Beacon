import '../models/group_message_model.dart';
import '../models/group_message_page_model.dart';
import '../models/message_group_detail_model.dart';
import '../models/message_group_page_model.dart';

abstract class MessageGroupsRemoteDatasource {
  Future<MessageGroupPageModel> getMessageGroups({String? cursor, int? limit});

  Future<MessageGroupDetailModel> createMessageGroup({
    required List<String> memberUserIds,
  });

  Future<GroupMessageModel> sendMessage({
    required String groupId,
    required String content,
  });

  Future<GroupMessageModel> sendPostMessage({
    required String postId,
    required String clientMessageId,
    String? content,
  });

  Future<GroupMessagePageModel> getMessages({
    required String groupId,
    String? cursor,
    int? limit,
  });

  Future<GroupMessagePageModel> searchMessages({
    required String groupId,
    required String search,
    String? cursor,
    int? limit,
  });

  Future<MessageGroupDetailModel> getGroupDetail({required String groupId});

  Future<void> addMembers({
    required String groupId,
    required List<String> targetUserIds,
  });

  Future<void> updateMemberCustomName({
    required String groupId,
    required String userId,
    String? customName,
  });

  Future<void> updateMemberRole({
    required String groupId,
    required String targetUserId,
    required int role,
  });

  Future<void> approveMember({
    required String groupId,
    required String userId,
  });

  Future<void> denyMember({
    required String groupId,
    required String userId,
  });

  Future<void> updateMuteStatus({
    required String groupId,
    required bool isMuted,
  });

  Future<void> removeMember({
    required String groupId,
    required String userId,
  });

  Future<void> deleteGroup({required String groupId});

  Future<void> leaveGroup({required String groupId});

  Future<void> updateRequireApprovalToAddMembers({
    required String groupId,
    required bool requireApprovalToAddMembers,
  });

  Future<void> updateGroupName({
    required String groupId,
    required String name,
  });

  Future<void> updateGroupAvatar({
    required String groupId,
    required String filePath,
  });

  Future<void> markSeen({
    required String groupId,
    required String lastSeenMessageId,
  });
}
