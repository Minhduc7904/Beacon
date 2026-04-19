import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class LoginValidationFailure extends ValidationFailure {
  final String? usernameError;
  final String? passwordError;

  const LoginValidationFailure({
    this.usernameError,
    this.passwordError,
    String? message,
  }) : super(
         message:
             message ??
             usernameError ??
             passwordError ??
             'Thong tin dang nhap khong hop le',
       );
}

class LoginParams {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});
}

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, AuthResult>> call(LoginParams params) {
    final validationError = _validate(params);
    if (validationError != null) return Future.value(Left(validationError));

    return _repository.login(
      username: params.username,
      password: params.password,
    );
  }

  LoginValidationFailure? _validate(LoginParams params) {
    if (params.username.trim().isEmpty) {
      return const LoginValidationFailure(
        usernameError: 'Tên đăng nhập không được để trống',
      );
    }
    if (params.password.isEmpty) {
      return const LoginValidationFailure(
        passwordError: 'Mật khẩu không được để trống',
      );
    }
    if (params.password.length < 6) {
      return const LoginValidationFailure(
        passwordError: 'Mật khẩu phải có ít nhất 6 ký tự',
      );
    }
    return null;
  }
}
