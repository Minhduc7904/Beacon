import '../../domain/entities/user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final User user;
  final String successMessage;

  const AuthSuccess(this.user, {this.successMessage = ''});
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthValidationError extends AuthState {
  final String message;
  final String? usernameError;
  final String? passwordError;

  const AuthValidationError(
    this.message, {
    this.usernameError,
    this.passwordError,
  });
}
