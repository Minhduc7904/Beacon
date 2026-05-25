import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/entities/group_message_page.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_page.dart';
import '../../domain/repositories/message_groups_repository.dart';
import '../datasources/message_groups_remote_datasource.dart';

class MessageGroupsRepositoryImpl implements MessageGroupsRepository {
  final MessageGroupsRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  MessageGroupsRepositoryImpl({
    required MessageGroupsRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, MessageGroupPage>> getMessageGroups({
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getMessageGroups(
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, MessageGroupDetail>> createMessageGroup({
    required List<String> memberUserIds,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.createMessageGroup(
        memberUserIds: memberUserIds,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, GroupMessage>> sendMessage({
    required String groupId,
    required String content,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.sendMessage(
        groupId: groupId,
        content: content,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, GroupMessage>> sendPostMessage({
    required String postId,
    required String clientMessageId,
    String? content,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.sendPostMessage(
        postId: postId,
        clientMessageId: clientMessageId,
        content: content,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, GroupMessagePage>> getMessages({
    required String groupId,
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getMessages(
        groupId: groupId,
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, GroupMessagePage>> searchMessages({
    required String groupId,
    required String search,
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.searchMessages(
        groupId: groupId,
        search: search,
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, MessageGroupDetail>> getGroupDetail({
    required String groupId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getGroupDetail(groupId: groupId);
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addMembers({
    required String groupId,
    required List<String> targetUserIds,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.addMembers(
        groupId: groupId,
        targetUserIds: targetUserIds,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateMemberCustomName({
    required String groupId,
    required String userId,
    String? customName,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateMemberCustomName(
        groupId: groupId,
        userId: userId,
        customName: customName,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateMemberRole({
    required String groupId,
    required String targetUserId,
    required int role,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateMemberRole(
        groupId: groupId,
        targetUserId: targetUserId,
        role: role,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> approveMember({
    required String groupId,
    required String userId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.approveMember(
        groupId: groupId,
        userId: userId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> denyMember({
    required String groupId,
    required String userId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.denyMember(
        groupId: groupId,
        userId: userId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateMuteStatus({
    required String groupId,
    required bool isMuted,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateMuteStatus(
        groupId: groupId,
        isMuted: isMuted,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeMember({
    required String groupId,
    required String userId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.removeMember(groupId: groupId, userId: userId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup({required String groupId}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.deleteGroup(groupId: groupId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroup({required String groupId}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.leaveGroup(groupId: groupId);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateRequireApprovalToAddMembers({
    required String groupId,
    required bool requireApprovalToAddMembers,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateRequireApprovalToAddMembers(
        groupId: groupId,
        requireApprovalToAddMembers: requireApprovalToAddMembers,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateGroupName({
    required String groupId,
    required String name,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateGroupName(
        groupId: groupId,
        name: name,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateGroupAvatar({
    required String groupId,
    required String filePath,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateGroupAvatar(
        groupId: groupId,
        filePath: filePath,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markSeen({
    required String groupId,
    required String lastSeenMessageId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.markSeen(
        groupId: groupId,
        lastSeenMessageId: lastSeenMessageId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
