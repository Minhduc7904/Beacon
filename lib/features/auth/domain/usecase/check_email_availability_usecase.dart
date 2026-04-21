import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/validation_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/email_utils.dart';
import '../../data/mappers/auth_error_code_mapper.dart';
import '../repositories/auth_repository.dart';

class CheckEmailAvailabilityParams {
  final String email;

  const CheckEmailAvailabilityParams({required this.email});
}

class CheckEmailAvailabilityUseCase {
  final AuthRepository _repository;

  CheckEmailAvailabilityUseCase(this._repository);

  Future<Either<Failure, String>> call(
    CheckEmailAvailabilityParams params,
  ) async {
    final email = EmailUtils.sanitize(params.email);

    if (email.isEmpty) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.emailRequired),
        ),
      );
    }

    if (!EmailUtils.isValid(email)) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.emailInvalidFormat),
        ),
      );
    }

    final result = await _repository.checkEmailAvailable(email: email);

    return result.fold(Left.new, (isAvailable) {
      if (!isAvailable) {
        final mappedMessage = ErrorMessages.registerEmailExists;

        return Left(ValidationFailure(message: mappedMessage));
      }

      return Right(email);
    });
  }
}
