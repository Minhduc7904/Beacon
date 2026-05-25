import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/group_message.dart';
import '../entities/message_group_detail.dart';
import '../entities/group_message_page.dart';
import '../entities/message_group_page.dart';

abstract class MessageGroupsRepository {
  Future<Either<Failure, MessageGroupPage>> getMessageGroups({
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, MessageGroupDetail>> createMessageGroup({
    required List<String> memberUserIds,
  });

  Future<Either<Failure, GroupMessage>> sendMessage({
    required String groupId,
    required String content,
  });

  Future<Either<Failure, GroupMessage>> sendPostMessage({
    required String postId,
    required String clientMessageId,
    String? content,
  });

  Future<Either<Failure, GroupMessagePage>> getMessages({
    required String groupId,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, GroupMessagePage>> searchMessages({
    required String groupId,
    required String search,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, MessageGroupDetail>> getGroupDetail({
    required String groupId,
  });

  Future<Either<Failure, void>> addMembers({
    required String groupId,
    required List<String> targetUserIds,
  });

  Future<Either<Failure, void>> updateMemberCustomName({
    required String groupId,
    required String userId,
    String? customName,
  });

  Future<Either<Failure, void>> updateMemberRole({
    required String groupId,
    required String targetUserId,
    required int role,
  });

  Future<Either<Failure, void>> approveMember({
    required String groupId,
    required String userId,
  });

  Future<Either<Failure, void>> denyMember({
    required String groupId,
    required String userId,
  });

  Future<Either<Failure, void>> updateMuteStatus({
    required String groupId,
    required bool isMuted,
  });

  Future<Either<Failure, void>> removeMember({
    required String groupId,
    required String userId,
  });

  Future<Either<Failure, void>> deleteGroup({required String groupId});

  Future<Either<Failure, void>> leaveGroup({required String groupId});

  Future<Either<Failure, void>> updateRequireApprovalToAddMembers({
    required String groupId,
    required bool requireApprovalToAddMembers,
  });

  Future<Either<Failure, void>> updateGroupName({
    required String groupId,
    required String name,
  });

  Future<Either<Failure, void>> updateGroupAvatar({
    required String groupId,
    required String filePath,
  });

  Future<Either<Failure, void>> markSeen({
    required String groupId,
    required String lastSeenMessageId,
  });
}
