import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friends_repository.dart';

class DeleteFriendUseCase {
  final FriendsRepository _repository;

  DeleteFriendUseCase(this._repository);

  Future<Either<Failure, bool>> call({required String userId}) {
    return _repository.deleteFriend(userId: userId.trim());
  }
}
