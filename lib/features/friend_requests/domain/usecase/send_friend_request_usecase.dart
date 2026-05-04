import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_request.dart';
import '../repositories/friend_request_repository.dart';

class SendFriendRequestUseCase {
  final FriendRequestRepository _repository;

  SendFriendRequestUseCase(this._repository);

  Future<Either<Failure, FriendRequest>> call({
    required String receiverId,
  }) {
    return _repository.sendFriendRequest(receiverId: receiverId.trim());
  }
}
