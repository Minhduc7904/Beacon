import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post.dart';
import '../entities/post_visibility.dart';
import '../repositories/posts_repository.dart';

class CreatePostParams {
  final String mediaId;
  final String? caption;
  final PostVisibility visibility;

  const CreatePostParams({
    required this.mediaId,
    this.caption,
    this.visibility = PostVisibility.friends,
  });
}

class CreatePostUseCase {
  final PostsRepository _repository;

  CreatePostUseCase(this._repository);

  Future<Either<Failure, Post>> call(CreatePostParams params) {
    final mediaId = params.mediaId.trim();
    final caption = params.caption?.trim();

    if (mediaId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postMediaNotFound)),
      );
    }

    if (caption != null && caption.length > 2000) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.postCaptionTooLong),
        ),
      );
    }

    return _repository.createPost(
      mediaId: mediaId,
      caption: caption?.isEmpty == true ? null : caption,
      visibility: params.visibility,
    );
  }
}
