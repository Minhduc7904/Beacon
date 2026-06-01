import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/post_report.dart';

abstract class PostReportsRepository {
  Future<Either<Failure, PostReport>> reportPost({
    required String postId,
    required String reason,
    String? description,
  });
}
