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
