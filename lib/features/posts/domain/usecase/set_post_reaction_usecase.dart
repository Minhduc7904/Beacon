import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_reaction_icon.dart';
import '../entities/post_reaction_result.dart';
import '../repositories/posts_repository.dart';

class SetPostReactionParams {
  final String postId;
  final PostReactionIcon icon;

  const SetPostReactionParams({required this.postId, required this.icon});
}

class SetPostReactionUseCase {
  final PostsRepository _repository;

  SetPostReactionUseCase(this._repository);

  Future<Either<Failure, PostReactionResult>> call(
    SetPostReactionParams params,
  ) {
    final postId = params.postId.trim();
    if (postId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postNotFound)),
      );
    }

    return _repository.setReaction(postId: postId, icon: params.icon);
  }
}
