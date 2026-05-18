import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/post_page.dart';
import '../repositories/posts_repository.dart';

class GetFeedPostsUseCase {
  final PostsRepository _repository;

  GetFeedPostsUseCase(this._repository);

  Future<Either<Failure, PostPage>> call({String? cursor, int? limit}) {
    return _repository.getFeedPosts(
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
