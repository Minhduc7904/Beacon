import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_page.dart';
import '../repositories/friends_repository.dart';

class SearchFriendsUseCase {
  final FriendsRepository _repository;

  SearchFriendsUseCase(this._repository);

  Future<Either<Failure, FriendPage>> call({
    required String search,
    String? cursor,
    int? limit,
  }) {
    return _repository.searchFriends(
      search: search.trim(),
      cursor: cursor?.trim().isEmpty == true ? null : cursor?.trim(),
      limit: limit,
    );
  }
}
