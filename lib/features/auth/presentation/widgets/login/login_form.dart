import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../controllers/auth_state.dart';
import 'login_form_heading.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final AuthState authState;
  final bool isLoading;
  final VoidCallback onSubmit;
  final Widget? footer;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.authState,
    required this.isLoading,
    required this.onSubmit,
    this.footer,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final validationErrorState = widget.authState is AuthValidationError
        ? widget.authState as AuthValidationError
        : null;
    final usernameError = validationErrorState?.usernameError;
    final passwordError = validationErrorState?.passwordError;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      child: Material(
        color: AppColors.sky200,
        child: AppScreenLayout(
          alignment: Alignment.topCenter,
          child: Form(
            key: widget.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginFormHeading(),
                  const SizedBox(height: 32),
                  Input(
                    controller: widget.usernameController,
                    label: 'Tên đăng nhập',
                    hintText: 'Nhập tên đăng nhập',
                    type: InputType.text,
                    state: usernameError != null
                        ? InputState.error
                        : InputState.defaultState,
                    caption: usernameError,
                    keyboardType: TextInputType.text,
                    enabled: !widget.isLoading,
                  ),
                  const SizedBox(height: 32),
                  Input(
                    controller: widget.passwordController,
                    label: 'Mật khẩu',
                    rightCaption: 'Quên mật khẩu',
                    hintText: 'Nhập mật khẩu',
                    type: InputType.text,
                    state: passwordError != null
                        ? InputState.error
                        : InputState.defaultState,
                    caption: passwordError,
                    labelRightIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 20,
                        color: AppColors.sky600,
                      ),
                    ),
                    obscureText: _obscurePassword,
                    enabled: !widget.isLoading,
                  ),
                  const SizedBox(height: 32),
                  Button(
                    text: 'Đăng nhập',
                    isLoading: widget.isLoading,
                    loadingText: 'Đang đăng nhập...',
                    onPressed: widget.onSubmit,
                  ),
                  if (widget.footer != null) ...[
                    const SizedBox(height: 32),
                    widget.footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
