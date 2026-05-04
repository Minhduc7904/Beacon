import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_page.dart';
import '../entities/friend_profile.dart';
import '../entities/friend_type.dart';

abstract class FriendsRepository {
  Future<Either<Failure, FriendPage>> getFriends({
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, FriendPage>> searchFriends({
    required String search,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, FriendProfile>> getFriendDetail({
    required String userId,
  });

  Future<Either<Failure, bool>> updateFriendType({
    required String userId,
    required FriendType type,
  });

  Future<Either<Failure, bool>> deleteFriend({
    required String userId,
  });
}
