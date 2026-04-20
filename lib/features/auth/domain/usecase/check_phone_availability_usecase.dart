import 'package:dartz/dartz.dart';

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

  Future<Either<Failure, bool>> call(CheckPhoneAvailabilityParams params) {
    final phoneNumber = params.phoneNumber.trim();

    if (phoneNumber.isEmpty) {
      return Future.value(
        const Left(ValidationFailure(message: 'Vui lòng nhập số điện thoại')),
      );
    }

    if (!PhoneNumberUtils.isValidVietnamMobile(phoneNumber)) {
      return Future.value(
        const Left(
          ValidationFailure(
            message: 'Vui lòng nhập số điện thoại Việt Nam hợp lệ',
          ),
        ),
      );
    }

    final e164Phone = PhoneNumberUtils.toE164Vietnam(phoneNumber);
    if (e164Phone == null) {
      return Future.value(
        const Left(
          ValidationFailure(
            message: 'Số điện thoại chưa đúng định dạng E.164',
          ),
        ),
      );
    }

    return _repository.checkPhoneAvailable(phoneNumber: e164Phone);
  }
}
