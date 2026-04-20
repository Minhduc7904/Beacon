import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
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
      email: params.email?.trim(),
      phoneNumber: params.phoneNumber?.trim(),
    );
  }

  ValidationFailure? _validate(UpdateMeParams params) {
    if (!params.hasChanges) {
      return const ValidationFailure(
        message: 'Không có thông tin nào được thay đổi',
      );
    }

    if (params.familyName != null && params.familyName!.trim().isEmpty) {
      return const ValidationFailure(message: 'Họ không được để trống');
    }

    if (params.givenName != null && params.givenName!.trim().isEmpty) {
      return const ValidationFailure(message: 'Tên không được để trống');
    }

    if (params.email != null) {
      final email = params.email!.trim();
      if (email.isEmpty) {
        return const ValidationFailure(message: 'Email không được để trống');
      }

      final isValidEmail = RegExp(
        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
        caseSensitive: false,
      ).hasMatch(email);

      if (!isValidEmail) {
        return const ValidationFailure(message: 'Email không đúng định dạng');
      }
    }

    if (params.phoneNumber != null && params.phoneNumber!.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Số điện thoại không được để trống',
      );
    }

    return null;
  }
}
