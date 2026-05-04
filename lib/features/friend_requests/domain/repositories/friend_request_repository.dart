import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_request.dart';
import '../entities/friend_request_page.dart';

abstract class FriendRequestRepository {
  Future<Either<Failure, FriendRequest>> sendFriendRequest({
    required String receiverId,
  });

  Future<Either<Failure, bool>> acceptFriendRequest({required String id});

  Future<Either<Failure, bool>> declineFriendRequest({required String id});

  Future<Either<Failure, FriendRequestPage>> getReceivedRequests({
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, FriendRequestPage>> getSentRequests({
    String? cursor,
    int? limit,
  });
}
