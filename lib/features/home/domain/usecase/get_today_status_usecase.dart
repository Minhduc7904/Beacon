import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/today_status.dart';
import '../repositories/checkin_repository.dart';

class GetTodayStatusUseCase {
  final CheckinRepository _repository;

  GetTodayStatusUseCase(this._repository);

  Future<Either<Failure, TodayStatus>> call() {
    return _repository.getTodayStatus();
  }
}
