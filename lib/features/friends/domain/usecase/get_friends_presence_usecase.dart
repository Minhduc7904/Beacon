import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/friend_presence_page.dart';
import '../repositories/friends_repository.dart';

class GetFriendsPresenceUseCase {
  final FriendsRepository _repository;

  GetFriendsPresenceUseCase(this._repository);

  Future<Either<Failure, FriendPresencePage>> call({
    String? cursor,
    int? limit,
  }) {
    return _repository.getFriendsPresence(
      cursor: cursor?.trim().isEmpty == true ? null : cursor?.trim(),
      limit: limit,
    );
  }
}
