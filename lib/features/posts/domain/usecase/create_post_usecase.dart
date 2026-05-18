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
  final double? latitude;
  final double? longitude;

  const CreatePostParams({
    required this.mediaId,
    this.caption,
    this.visibility = PostVisibility.friends,
    this.latitude,
    this.longitude,
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

    final latitude = params.latitude;
    final longitude = params.longitude;
    final hasPartialLocation = (latitude == null) != (longitude == null);
    final hasInvalidLocation =
        latitude != null &&
        longitude != null &&
        (latitude < -90 ||
            latitude > 90 ||
            longitude < -180 ||
            longitude > 180);
    if (hasPartialLocation || hasInvalidLocation) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.postValidationError),
        ),
      );
    }

    return _repository.createPost(
      mediaId: mediaId,
      caption: caption?.isEmpty == true ? null : caption,
      visibility: params.visibility,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
