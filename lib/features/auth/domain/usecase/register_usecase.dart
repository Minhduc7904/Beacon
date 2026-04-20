import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/phone_number_utils.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final String familyName;
  final String givenName;
  final String phoneNumber;

  const RegisterParams({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.familyName,
    required this.givenName,
    required this.phoneNumber,
  });
}

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<Failure, AuthResult>> call(RegisterParams params) {
    final validationError = _validate(params);
    if (validationError != null) return Future.value(Left(validationError));

    return _repository.register(
      email: params.email,
      confirmPassword: params.confirmPassword,
      familyName: params.familyName,
      givenName: params.givenName,
      username: params.username,
      password: params.password,
      phoneNumber: params.phoneNumber,
    );
  }

  ValidationFailure? _validate(RegisterParams params) {
    final email = params.email.trim();
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

    if (params.familyName.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Họ và tên đệm không được để trống',
      );
    }

    if (params.givenName.trim().isEmpty) {
      return const ValidationFailure(message: 'Tên riêng không được để trống');
    }

    if (params.username.trim().isEmpty) {
      return const ValidationFailure(
        message: 'Tên đăng nhập không được để trống',
      );
    }

    if (params.password.isEmpty) {
      return const ValidationFailure(message: 'Mật khẩu không được để trống');
    }

    if (params.password.length < 6) {
      return const ValidationFailure(
        message: 'Mật khẩu phải có ít nhất 6 ký tự',
      );
    }

    if (params.confirmPassword.isEmpty) {
      return const ValidationFailure(
        message: 'Xác nhận mật khẩu không được để trống',
      );
    }

    if (params.password != params.confirmPassword) {
      return const ValidationFailure(message: 'Mật khẩu xác nhận không khớp');
    }

    final phoneNumber = params.phoneNumber.trim();
    if (phoneNumber.isEmpty) {
      return const ValidationFailure(message: 'Số điện thoại không được để trống');
    }

    if (!PhoneNumberUtils.isValidVietnamMobile(phoneNumber)) {
      return const ValidationFailure(
        message: 'Số điện thoại Việt Nam không hợp lệ',
      );
    }

    if (PhoneNumberUtils.toE164Vietnam(phoneNumber) == null) {
      return const ValidationFailure(
        message: 'Số điện thoại chưa đúng định dạng E.164',
      );
    }

    return null;
  }
}
