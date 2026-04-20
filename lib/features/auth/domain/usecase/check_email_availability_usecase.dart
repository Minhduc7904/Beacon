import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class CheckEmailAvailabilityParams {
  final String email;

  const CheckEmailAvailabilityParams({required this.email});
}

class CheckEmailAvailabilityUseCase {
  final AuthRepository _repository;

  CheckEmailAvailabilityUseCase(this._repository);

  Future<Either<Failure, bool>> call(CheckEmailAvailabilityParams params) {
    final email = params.email.trim();

    if (email.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Vui lòng nhập địa chỉ email')),
      );
    }

    final isValidEmail = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
      caseSensitive: false,
    ).hasMatch(email);

    if (!isValidEmail) {
      return Future.value(
        const Left(
          ValidationFailure(message: 'Vui lòng nhập địa chỉ email hợp lệ'),
        ),
      );
    }

    return _repository.checkEmailAvailable(email: email);
  }
}
