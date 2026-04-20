import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/register_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/messages/app_message_notifier.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final AppMessageNotifier _messageNotifier;

  AuthNotifier(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._messageNotifier,
  ) : super(const AuthInitial());

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _loginUseCase(
      LoginParams(username: username, password: password),
    );

    result.fold(
      (failure) {
        if (failure is LoginValidationFailure) {
          state = AuthValidationError(
            failure.message,
            usernameError: failure.usernameError,
            passwordError: failure.passwordError,
          );
        } else if (failure is ValidationFailure) {
          state = AuthValidationError(failure.message);
        } else {
          _messageNotifier.addError(failure.message);
          state = AuthError(failure.message);
          state = AuthValidationError(
            failure.message,
            passwordError: failure.message,
          );
        }
      },
      (authResult) {
        _messageNotifier.addSuccess('Chào mừng ${authResult.user.fullName}!');
        state = AuthSuccess(authResult.user);
      },
    );
  }

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required String familyName,
    required String givenName,
    required String phoneNumber,
  }) async {
    state = const AuthLoading();

    final result = await _registerUseCase(
      RegisterParams(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
        familyName: familyName,
        givenName: givenName,
        phoneNumber: phoneNumber,
      ),
    );

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          state = AuthValidationError(failure.message);
        } else {
          _messageNotifier.addError(failure.message);
          state = AuthError(failure.message);
        }
      },
      (authResult) {
        _messageNotifier.addSuccess('Đăng ký thành công!');
        state = AuthSuccess(authResult.user);
      },
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    final result = await _logoutUseCase();
    result.fold((failure) {
      _messageNotifier.addError(failure.message);
      state = AuthError(failure.message);
    }, (_) => state = const AuthInitial());
  }

  void reset() => state = const AuthInitial();
}
