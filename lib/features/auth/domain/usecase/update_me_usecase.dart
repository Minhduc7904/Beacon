import 'package:dartz/dartz.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/email_utils.dart';
import '../../../../core/utils/phone_number_utils.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class UpdateMeParams {
  final String? familyName;
  final String? givenName;
  final String? email;
  final String? phoneNumber;

  const UpdateMeParams({
    this.familyName,
    this.givenName,
    this.email,
    this.phoneNumber,
  });

  bool get hasChanges {
    return familyName != null ||
        givenName != null ||
        email != null ||
        phoneNumber != null;
  }
}

class UpdateMeUseCase {
  final AuthRepository _repository;

  UpdateMeUseCase(this._repository);

  Future<Either<Failure, UserProfile>> call(UpdateMeParams params) {
    final validationError = _validate(params);
    if (validationError != null) {
      return Future.value(Left(validationError));
    }

    return _repository.updateMe(
      familyName: params.familyName?.trim(),
      givenName: params.givenName?.trim(),
      email: _normalizeEmail(params.email),
      phoneNumber: _normalizePhoneNumber(params.phoneNumber),
    );
  }

  ValidationFailure? _validate(UpdateMeParams params) {
    if (!params.hasChanges) {
      return const ValidationFailure(
        message: ErrorMessages.noProfileChanges,
      );
    }

    if (params.familyName != null && params.familyName!.trim().isEmpty) {
      return const ValidationFailure(message: ErrorMessages.familyNameRequired);
    }

    if (params.givenName != null && params.givenName!.trim().isEmpty) {
      return const ValidationFailure(message: ErrorMessages.givenNameRequired);
    }

    if (params.email != null) {
      final email = EmailUtils.sanitize(params.email!);
      if (email.isEmpty) {
        return const ValidationFailure(message: ErrorMessages.emailRequired);
      }

      if (!EmailUtils.isValid(email)) {
        return const ValidationFailure(
          message: ErrorMessages.emailInvalidFormat,
        );
      }
    }

    if (params.phoneNumber != null) {
      final phoneNumber = params.phoneNumber!.trim();
      if (phoneNumber.isEmpty) {
        return const ValidationFailure(message: ErrorMessages.phoneRequired);
      }

      if (!PhoneNumberUtils.isValidVietnamMobile(phoneNumber)) {
        return const ValidationFailure(
          message: ErrorMessages.phoneInvalidVietnam,
        );
      }

      if (PhoneNumberUtils.toE164Vietnam(phoneNumber) == null) {
        return const ValidationFailure(
          message: ErrorMessages.phoneInvalidE164,
        );
      }
    }

    return null;
  }

  String? _normalizeEmail(String? email) {
    if (email == null) {
      return null;
    }

    return EmailUtils.sanitize(email).toLowerCase();
  }

  String? _normalizePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null) {
      return null;
    }

    final normalized = PhoneNumberUtils.toE164Vietnam(phoneNumber);
    return normalized ?? phoneNumber.trim();
  }
}
