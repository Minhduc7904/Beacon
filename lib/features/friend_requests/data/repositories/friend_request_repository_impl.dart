import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/friend_request.dart';
import '../../domain/entities/friend_request_page.dart';
import '../../domain/repositories/friend_request_repository.dart';
import '../datasources/friend_request_remote_datasource.dart';

class FriendRequestRepositoryImpl implements FriendRequestRepository {
  final FriendRequestRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  FriendRequestRepositoryImpl({
    required FriendRequestRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, FriendRequest>> sendFriendRequest({
    required String receiverId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.sendFriendRequest(
        receiverId: receiverId,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> acceptFriendRequest({required String id}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.acceptFriendRequest(id: id);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> declineFriendRequest({
    required String id,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.declineFriendRequest(id: id);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, FriendRequestPage>> getReceivedRequests({
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getReceivedRequests(
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, FriendRequestPage>> getSentRequests({
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getSentRequests(
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
