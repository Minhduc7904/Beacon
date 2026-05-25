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

  Future<Either<Failure, void>> deleteGroup({required String groupId});

  Future<Either<Failure, void>> leaveGroup({required String groupId});

  Future<Either<Failure, void>> updateRequireApprovalToAddMembers({
    required String groupId,
    required bool requireApprovalToAddMembers,
  });

  Future<Either<Failure, void>> markSeen({
    required String groupId,
    required String lastSeenMessageId,
  });
}
