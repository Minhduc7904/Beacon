import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/safety_settings.dart';
import '../repositories/safety_repository.dart';

class GetSafetySettingsUseCase {
  final SafetyRepository _repository;

  GetSafetySettingsUseCase(this._repository);

  Future<Either<Failure, SafetySettings>> call() {
    return _repository.getSafetySettings();
  }
}
