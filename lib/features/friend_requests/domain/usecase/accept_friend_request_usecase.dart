import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friend_request_repository.dart';

class AcceptFriendRequestUseCase {
  final FriendRequestRepository _repository;

  AcceptFriendRequestUseCase(this._repository);

  Future<Either<Failure, bool>> call({required String id}) {
    return _repository.acceptFriendRequest(id: id.trim());
  }
}
