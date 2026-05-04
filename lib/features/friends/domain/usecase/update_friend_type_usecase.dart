import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_type.dart';
import '../repositories/friends_repository.dart';

class UpdateFriendTypeUseCase {
  final FriendsRepository _repository;

  UpdateFriendTypeUseCase(this._repository);

  Future<Either<Failure, bool>> call({
    required String userId,
    required FriendType type,
  }) {
    return _repository.updateFriendType(userId: userId.trim(), type: type);
  }
}
