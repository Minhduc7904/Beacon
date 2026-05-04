import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_profile.dart';
import '../repositories/friends_repository.dart';

class GetFriendDetailUseCase {
  final FriendsRepository _repository;

  GetFriendDetailUseCase(this._repository);

  Future<Either<Failure, FriendProfile>> call({required String userId}) {
    return _repository.getFriendDetail(userId: userId.trim());
  }
}
