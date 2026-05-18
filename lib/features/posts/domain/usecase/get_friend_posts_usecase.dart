import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/post_page.dart';
import '../repositories/posts_repository.dart';

class GetFriendPostsUseCase {
  final PostsRepository _repository;

  GetFriendPostsUseCase(this._repository);

  Future<Either<Failure, PostPage>> call({
    required String friendId,
    String? cursor,
    int? limit,
  }) {
    final normalizedFriendId = friendId.trim();
    if (normalizedFriendId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Bạn bè không hợp lệ')),
      );
    }

    return _repository.getFriendPosts(
      friendId: normalizedFriendId,
      cursor: _normalizeCursor(cursor),
      limit: _normalizeLimit(limit),
    );
  }
}

String? _normalizeCursor(String? cursor) {
  final value = cursor?.trim();
  return value == null || value.isEmpty ? null : value;
}

int? _normalizeLimit(int? limit) {
  if (limit == null) {
    return null;
  }
  return limit.clamp(1, 100);
}
