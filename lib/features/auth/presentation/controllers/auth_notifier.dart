import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/register_usecase.dart';
import '../../domain/usecase/get_me_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/messages/app_message_notifier.dart';
import 'me_profile_notifier.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final GetMeUseCase _getMeUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final MeProfileNotifier _meProfileNotifier;
  final AppMessageNotifier _messageNotifier;

  AuthNotifier(
    this._loginUseCase,
    this._getMeUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._meProfileNotifier,
    this._messageNotifier,
  ) : super(const AuthInitial());

  static const String _registerUsernameExistsMessage =
      'Tên đăng nhập đã được sử dụng';

  bool _isRegisterUsernameConflictMessage(String message) {
    final normalized = message.trim().toLowerCase();
    return normalized == _registerUsernameExistsMessage.toLowerCase() ||
        normalized == 'username is already taken.';
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AuthLoading();
    _meProfileNotifier.clearProfile();

    final result = await _loginUseCase(
      LoginParams(username: username, password: password),
    );

    await result.fold<Future<void>>(
      (failure) async {
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
        }
      },
      (authResult) async {
        final meResult = await _getMeUseCase.call();

        meResult.fold(
          (failure) {
            _messageNotifier.addError(failure.message);
            _meProfileNotifier.clearProfile();
            state = AuthError(failure.message);
          },
          (profile) {
            _meProfileNotifier.setProfile(profile);

            final user = User(
              userId: profile.id,
              username: profile.username,
              email: profile.email,
              familyName: profile.familyName,
              givenName: profile.givenName,
            );

            final apiSuccessMessage = authResult.message.trim();
            final successMessage = apiSuccessMessage.isNotEmpty
                ? apiSuccessMessage
                : 'Đăng nhập thành công';

            _messageNotifier.addSuccess(successMessage);
            state = AuthSuccess(user, successMessage: successMessage);
          },
        );
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
          if (_isRegisterUsernameConflictMessage(failure.message)) {
            state = AuthValidationError(
              failure.message,
              usernameError: failure.message,
            );
            return;
          }

          state = AuthError(failure.message);
        }
      },
      (authResult) {
        final apiSuccessMessage = authResult.message.trim();
        final successMessage = apiSuccessMessage.isNotEmpty
            ? apiSuccessMessage
            : 'Đăng ký thành công!';
        _messageNotifier.addSuccess(successMessage);
        state = AuthSuccess(authResult.user, successMessage: successMessage);
      },
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    _meProfileNotifier.clearProfile();

    final result = await _logoutUseCase();
    result.fold((failure) {
      _messageNotifier.addError(failure.message);
      state = AuthError(failure.message);
    }, (_) => state = const AuthInitial());
  }

  void reset() {
    _meProfileNotifier.clearProfile();
    state = const AuthInitial();
  }
}
