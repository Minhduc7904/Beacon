import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/media_upload_result.dart';
import '../repositories/post_preview_repository.dart';

class UploadPostMediaParams {
  final String filePath;

  const UploadPostMediaParams({required this.filePath});
}

class UploadPostMediaUseCase {
  final PostPreviewRepository _repository;

  UploadPostMediaUseCase(this._repository);

  Future<Either<Failure, MediaUploadResult>> call(
    UploadPostMediaParams params,
  ) {
    if (params.filePath.trim().isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Vui lòng chụp ảnh trước khi đăng'),
        ),
      );
    }

    return _repository.uploadPostMedia(filePath: params.filePath);
  }
}
