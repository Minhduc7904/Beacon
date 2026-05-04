import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friend_request_repository.dart';

class DeclineFriendRequestUseCase {
  final FriendRequestRepository _repository;

  DeclineFriendRequestUseCase(this._repository);

  Future<Either<Failure, bool>> call({required String id}) {
    return _repository.declineFriendRequest(id: id.trim());
  }
}
