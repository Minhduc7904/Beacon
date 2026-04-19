import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import 'register_draft_data.dart';
import '../../widgets/register/register_step_layout.dart';

class RegisterPageEmail extends StatefulWidget {
  const RegisterPageEmail({super.key});

  @override
  State<RegisterPageEmail> createState() => _RegisterPageEmailState();
}

class _RegisterPageEmailState extends State<RegisterPageEmail> {
  final _emailController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    final email = _emailController.text.trim();
    final isValidEmail = RegExp(
      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
      caseSensitive: false,
    ).hasMatch(email);

    if (!isValidEmail) {
      setState(() {
        _errorText = 'Vui lòng nhập địa chỉ email hợp lệ';
      });
      return;
    }

    setState(() {
      _errorText = null;
    });

    FocusScope.of(context).unfocus();
    context.pushNamed(
      AppRoutes.registerPhoneNumberName,
      extra: RegisterDraftData(email: email),
    );
  }

  void _onEmailChanged(String _) {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RegisterStepLayout(
      title: 'Email của bạn?',
      inputController: _emailController,
      inputHintText: 'Nhập địa chỉ email',
      keyboardType: TextInputType.emailAddress,
      errorText: _errorText,
      onInputChanged: _onEmailChanged,
      onContinuePressed: _onContinuePressed,
    );
  }
}
