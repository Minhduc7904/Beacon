import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_reaction_result.dart';
import '../repositories/posts_repository.dart';

class SetPostReactionIconParams {
  final String postId;
  final String icon;

  const SetPostReactionIconParams({required this.postId, required this.icon});
}

class SetPostReactionIconUseCase {
  final PostsRepository _repository;

  SetPostReactionIconUseCase(this._repository);

  Future<Either<Failure, PostReactionResult>> call(
    SetPostReactionIconParams params,
  ) {
    final postId = params.postId.trim();
    final icon = params.icon.trim();
    if (postId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postNotFound)),
      );
    }
    if (icon.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.postInvalidReactionIcon),
        ),
      );
    }

    return _repository.setReactionIcon(postId: postId, icon: icon);
  }
}
