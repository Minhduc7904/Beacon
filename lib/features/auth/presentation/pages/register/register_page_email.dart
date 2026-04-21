import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import 'register_draft_data.dart';
import '../../widgets/register/register_step_layout.dart';
import '../../../domain/usecase/check_email_availability_usecase.dart';

class RegisterPageEmail extends ConsumerStatefulWidget {
  const RegisterPageEmail({super.key});

  @override
  ConsumerState<RegisterPageEmail> createState() => _RegisterPageEmailState();
}

class _RegisterPageEmailState extends ConsumerState<RegisterPageEmail> {
  final _emailController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    if (_isLoading) {
      return;
    }

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorText = 'Vui lòng nhập địa chỉ email';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final result = await ref
        .read(checkEmailAvailabilityUseCaseProvider)
        .call(CheckEmailAvailabilityParams(email: email));

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _errorText = failure.message;
          _isLoading = false;
        });
      },
      (normalizedEmail) {
        final draft = RegisterDraftData(email: normalizedEmail);

        setState(() {
          _isLoading = false;
        });

        FocusScope.of(context).unfocus();
        context.pushNamed(
          AppRoutes.registerPhoneNumberName,
          extra: draft,
        );
      },
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
      isLoading: _isLoading,
      continueText: 'Tiếp theo',
      loadingText: 'Đang kiểm tra...',
      onInputChanged: _onEmailChanged,
      onContinuePressed: _onContinuePressed,
    );
  }
}
