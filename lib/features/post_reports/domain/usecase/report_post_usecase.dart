import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/post_report.dart';
import '../repositories/post_reports_repository.dart';

class ReportPostParams {
  final String postId;
  final String reason;
  final String? description;

  const ReportPostParams({
    required this.postId,
    required this.reason,
    this.description,
  });
}

class ReportPostUseCase {
  final PostReportsRepository _repository;

  ReportPostUseCase(this._repository);

  Future<Either<Failure, PostReport>> call(ReportPostParams params) {
    final postId = params.postId.trim();
    final reason = params.reason.trim();
    final description = params.description?.trim();
    final normalizedDescription = description == null || description.isEmpty
        ? null
        : description;

    if (postId.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.postNotFound)),
      );
    }

    if (reason.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.postReportReasonRequired),
        ),
      );
    }

    if (reason.length > 200) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.postReportReasonTooLong),
        ),
      );
    }

    if (normalizedDescription != null && normalizedDescription.length > 1000) {
      return Future.value(
        const Left(
          ValidationFailure(
            message: ErrorMessages.postReportDescriptionTooLong,
          ),
        ),
      );
    }

    return _repository.reportPost(
      postId: postId,
      reason: reason,
      description: normalizedDescription,
    );
  }
}
