import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../widgets/register/register_step_layout.dart';
import 'register_draft_data.dart';

class RegisterPagePassword extends StatefulWidget {
  const RegisterPagePassword({super.key, required this.draft});

  final RegisterDraftData draft;

  @override
  State<RegisterPagePassword> createState() => _RegisterPagePasswordState();
}

class _RegisterPagePasswordState extends State<RegisterPagePassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _passwordError;
  String? _confirmPasswordError;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordStrong(String value) {
    return value.length >= 8 &&
        RegExp(r'[a-z]').hasMatch(value) &&
        RegExp(r'[A-Z]').hasMatch(value) &&
        RegExp(r'[0-9]').hasMatch(value) &&
        RegExp(r'[^A-Za-z0-9]').hasMatch(value);
  }

  void _onContinuePressed() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    String? passwordError;
    String? confirmPasswordError;

    if (password.isEmpty) {
      passwordError = 'Vui lòng nhập mật khẩu';
    } else if (!_isPasswordStrong(password)) {
      passwordError = 'Mật khẩu chưa đáp ứng đủ điều kiện';
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError = 'Vui lòng nhập lại mật khẩu';
    } else if (password != confirmPassword) {
      confirmPasswordError = 'Mật khẩu nhập lại không khớp';
    }

    setState(() {
      _passwordError = passwordError;
      _confirmPasswordError = confirmPasswordError;
    });

    if (passwordError != null || confirmPasswordError != null) {
      return;
    }

    FocusScope.of(context).unfocus();
    context.pushNamed(
      AppRoutes.registerNameStepName,
      extra: widget.draft.copyWith(password: password),
    );
  }

  void _onPasswordChanged(String _) {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
      });
      return;
    }

    setState(() {});
  }

  void _onConfirmPasswordChanged(String _) {
    if (_confirmPasswordError != null) {
      setState(() {
        _confirmPasswordError = null;
      });
      return;
    }

    setState(() {});
  }

  InputState _resolveState(String value, String? error) {
    if (error != null && error.trim().isNotEmpty) {
      return InputState.error;
    }

    if (value.trim().isNotEmpty) {
      return InputState.filled;
    }

    return InputState.defaultState;
  }

  Widget _buildPasswordToggle({
    required bool obscure,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
        size: 20,
        color: AppColors.sky600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegisterStepLayout(
      title: 'Chọn mật khẩu',
      inputController: _passwordController,
      inputHintText: 'Nhập mật khẩu',
      showAgreement: false,
      instructionText:
          'Mật khẩu của bạn phải có ít nhất 8 kí tự, bao gồm chữ in thường, chữ in hoa, kí tự đặc biệt và số',
      inputFields: [
        Input(
          controller: _passwordController,
          hintText: 'Nhập mật khẩu',
          obscureText: _obscurePassword,
          rightIcon: _buildPasswordToggle(
            obscure: _obscurePassword,
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          state: _resolveState(_passwordController.text, _passwordError),
          caption: _passwordError,
          onChanged: _onPasswordChanged,
        ),
        Input(
          controller: _confirmPasswordController,
          hintText: 'Nhập lại mật khẩu',
          obscureText: _obscureConfirmPassword,
          rightIcon: _buildPasswordToggle(
            obscure: _obscureConfirmPassword,
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          state: _resolveState(
            _confirmPasswordController.text,
            _confirmPasswordError,
          ),
          caption: _confirmPasswordError,
          onChanged: _onConfirmPasswordChanged,
        ),
      ],
      onContinuePressed: _onContinuePressed,
    );
  }
}
