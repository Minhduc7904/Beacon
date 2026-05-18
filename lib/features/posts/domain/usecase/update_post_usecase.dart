import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post.dart';
import '../entities/post_visibility.dart';
import '../repositories/posts_repository.dart';

class UpdatePostParams {
  final String postId;
  final String? caption;
  final PostVisibility? visibility;

  const UpdatePostParams({required this.postId, this.caption, this.visibility});

  bool get hasAnyChange => caption != null || visibility != null;
}

class UpdatePostUseCase {
  final PostsRepository _repository;

  UpdatePostUseCase(this._repository);

  Future<Either<Failure, Post>> call(UpdatePostParams params) {
    final postId = params.postId.trim();
    final caption = params.caption?.trim();

    if (postId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postNotFound)),
      );
    }

    if (!params.hasAnyChange) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.postValidationError),
        ),
      );
    }

    if (caption != null && caption.length > 2000) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.postCaptionTooLong),
        ),
      );
    }

    return _repository.updatePost(
      postId: postId,
      caption: caption,
      visibility: params.visibility,
    );
  }
}
