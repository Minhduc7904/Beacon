import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_reaction_result.dart';
import '../repositories/posts_repository.dart';

class DeletePostReactionParams {
  final String postId;

  const DeletePostReactionParams({required this.postId});
}

class DeletePostReactionUseCase {
  final PostsRepository _repository;

  DeletePostReactionUseCase(this._repository);

  Future<Either<Failure, PostReactionResult>> call(
    DeletePostReactionParams params,
  ) {
    final postId = params.postId.trim();
    if (postId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postNotFound)),
      );
    }

    return _repository.deleteReaction(postId: postId);
  }
}
