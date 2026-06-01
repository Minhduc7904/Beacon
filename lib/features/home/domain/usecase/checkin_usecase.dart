import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/checkin_record.dart';
import '../repositories/checkin_repository.dart';

class CheckinParams {
  final String? note;
  final String? mediaId;
  final String? mood;

  const CheckinParams({this.note, this.mediaId, this.mood});
}

class CheckinUseCase {
  final CheckinRepository _repository;

  CheckinUseCase(this._repository);

  Future<Either<Failure, CheckinRecord>> call(CheckinParams params) {
    final note = params.note?.trim();
    final mood = params.mood?.trim();
    if (note != null && note.length > 1000) {
      return Future.value(
        Left(ValidationFailure(message: ErrorMessages.checkinValidationError)),
      );
    }

    return _repository.checkin(
      note: note,
      mediaId: params.mediaId?.trim(),
      mood: mood == null || mood.isEmpty ? null : mood,
    );
  }
}
