import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/posts_repository.dart';

class DeletePostParams {
  final String postId;

  const DeletePostParams({required this.postId});
}

class DeletePostUseCase {
  final PostsRepository _repository;

  DeletePostUseCase(this._repository);

  Future<Either<Failure, bool>> call(DeletePostParams params) {
    final postId = params.postId.trim();
    if (postId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postNotFound)),
      );
    }

    return _repository.deletePost(postId: postId);
  }
}
