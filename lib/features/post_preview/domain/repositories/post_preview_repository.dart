import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/media_upload_result.dart';

abstract class PostPreviewRepository {
  Future<Either<Failure, MediaUploadResult>> uploadPostMedia({
    required String filePath,
  });
}
