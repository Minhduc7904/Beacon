import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String username;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String? phoneNumber;

  const RegisterParams({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
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
      username: params.username,
      password: params.password,
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
    );
  }

  ValidationFailure? _validate(RegisterParams params) {
    if (params.fullName.trim().isEmpty) {
      return const ValidationFailure(message: 'Họ và tên không được để trống');
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
      return const ValidationFailure(
        message: 'Mật khẩu xác nhận không khớp',
      );
    }

    final phoneNumber = params.phoneNumber?.trim();
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final digitsOnly = RegExp(r'^\d{9,15}$');
      if (!digitsOnly.hasMatch(phoneNumber)) {
        return const ValidationFailure(
          message: 'Số điện thoại phải gồm 9-15 chữ số',
        );
      }
    }

    return null;
  }
}
