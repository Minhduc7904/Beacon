import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class HasLocalAuthSessionUseCase {
  final AuthRepository _repository;

  HasLocalAuthSessionUseCase(this._repository);

  Future<Either<Failure, bool>> call() {
    return _repository.hasLocalSession();
  }
}
