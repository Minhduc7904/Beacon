import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/friend_page.dart';
import '../../domain/entities/friend_presence_page.dart';
import '../../domain/entities/friend_profile.dart';
import '../../domain/entities/friend_type.dart';
import '../../domain/repositories/friends_repository.dart';
import '../datasources/friends_remote_datasource.dart';

class FriendsRepositoryImpl implements FriendsRepository {
  final FriendsRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  FriendsRepositoryImpl({
    required FriendsRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, FriendPage>> getFriends({
    String? search,
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getFriends(
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
  Future<Either<Failure, FriendPresencePage>> getFriendsPresence({
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getFriendsPresence(
        cursor: cursor,
        limit: limit,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, FriendPage>> searchFriends({
    required String search,
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.searchFriends(
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
  Future<Either<Failure, FriendProfile>> getFriendDetail({
    required String userId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDatasource.getFriendDetail(userId: userId);
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateFriendType({
    required String userId,
    required FriendType type,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.updateFriendType(
        userId: userId,
        type: type.value,
      );
      return const Right(true);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteFriend({required String userId}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.deleteFriend(userId: userId);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
