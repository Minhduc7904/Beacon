import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_reaction_page.dart';
import '../repositories/posts_repository.dart';

class GetPostReactionsParams {
  final String postId;
  final String? cursor;
  final int? limit;

  const GetPostReactionsParams({required this.postId, this.cursor, this.limit});
}

class GetPostReactionsUseCase {
  final PostsRepository _repository;

  GetPostReactionsUseCase(this._repository);

  Future<Either<Failure, PostReactionPage>> call(
    GetPostReactionsParams params,
  ) {
    final postId = params.postId.trim();
    if (postId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postNotFound)),
      );
    }

    return _repository.getReactions(
      postId: postId,
      cursor: params.cursor,
      limit: params.limit,
    );
  }
}
