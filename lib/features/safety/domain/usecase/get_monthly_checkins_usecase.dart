import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/monthly_checkins.dart';
import '../repositories/safety_repository.dart';

class GetMonthlyCheckinsParams {
  final int year;
  final int month;

  const GetMonthlyCheckinsParams({required this.year, required this.month});
}

class GetMonthlyCheckinsUseCase {
  final SafetyRepository _repository;

  GetMonthlyCheckinsUseCase(this._repository);

  Future<Either<Failure, MonthlyCheckins>> call(
    GetMonthlyCheckinsParams params,
  ) {
    if (params.year < 1 || params.month < 1 || params.month > 12) {
      return Future.value(
        Left(ValidationFailure(message: ErrorMessages.checkinValidationError)),
      );
    }

    return _repository.getMonthlyCheckins(
      year: params.year,
      month: params.month,
    );
  }

  Future<Either<Failure, MonthlyCheckins>> cached(
    GetMonthlyCheckinsParams params,
  ) {
    if (params.year < 1 || params.month < 1 || params.month > 12) {
      return Future.value(
        Left(ValidationFailure(message: ErrorMessages.checkinValidationError)),
      );
    }

    return _repository.getCachedMonthlyCheckins(
      year: params.year,
      month: params.month,
    );
  }
}
