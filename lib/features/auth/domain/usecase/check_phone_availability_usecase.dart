import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/phone_number_utils.dart';
import '../repositories/auth_repository.dart';

class CheckPhoneAvailabilityParams {
  final String phoneNumber;

  const CheckPhoneAvailabilityParams({required this.phoneNumber});
}

class CheckPhoneAvailabilityUseCase {
  final AuthRepository _repository;

  CheckPhoneAvailabilityUseCase(this._repository);

  Future<Either<Failure, String>> call(
    CheckPhoneAvailabilityParams params,
  ) async {
    final phoneNumber = params.phoneNumber.trim();

    if (phoneNumber.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.phoneRequired)),
      );
    }

    if (!PhoneNumberUtils.isValidVietnamMobile(phoneNumber)) {
      return Future.value(
        const Left(
          ValidationFailure(message: ErrorMessages.phoneInvalidVietnam),
        ),
      );
    }

    final e164Phone = PhoneNumberUtils.toE164Vietnam(phoneNumber);
    if (e164Phone == null) {
      return Future.value(
        const Left(ValidationFailure(message: ErrorMessages.phoneInvalidE164)),
      );
    }

    final result = await _repository.checkPhoneAvailable(
      phoneNumber: e164Phone,
    );

    return result.fold(Left.new, (isAvailable) {
      if (!isAvailable) {
        final mappedMessage = ErrorMessages.registerPhoneExists;

        return Left(ValidationFailure(message: mappedMessage));
      }

      return Right(phoneNumber);
    });
  }
}
