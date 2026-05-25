import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_page.dart';
import '../repositories/friends_repository.dart';

class GetFriendsUseCase {
  final FriendsRepository _repository;

  GetFriendsUseCase(this._repository);

  Future<Either<Failure, FriendPage>> call({
    String? search,
    String? cursor,
    int? limit,
  }) {
    return _repository.getFriends(
      search: search?.trim().isEmpty == true ? null : search?.trim(),
      cursor: cursor?.trim().isEmpty == true ? null : cursor?.trim(),
      limit: limit,
    );
  }
}
