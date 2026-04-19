import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/utils/phone_number_utils.dart';
import '../../widgets/register/register_step_layout.dart';
import 'register_draft_data.dart';

class RegisterPagePhoneNumber extends StatefulWidget {
  const RegisterPagePhoneNumber({super.key, required this.draft});

  final RegisterDraftData draft;

  @override
  State<RegisterPagePhoneNumber> createState() =>
      _RegisterPagePhoneNumberState();
}

class _RegisterPagePhoneNumberState extends State<RegisterPagePhoneNumber> {
  static const bool _allowInternationalPhone = false;

  final _phoneNumberController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    final phoneNumber = _phoneNumberController.text.trim();
    final normalized = PhoneNumberUtils.sanitize(phoneNumber);
    final isValid = PhoneNumberUtils.isValid(
      phoneNumber,
      allowInternational: _allowInternationalPhone,
    );

    if (!isValid) {
      setState(() {
        _errorText = _allowInternationalPhone
            ? 'Vui lòng nhập số điện thoại hợp lệ'
            : 'Vui lòng nhập số điện thoại Việt Nam hợp lệ';
      });
      return;
    }

    setState(() {
      _errorText = null;
    });

    FocusScope.of(context).unfocus();
    context.pushNamed(
      AppRoutes.registerPasswordName,
      extra: widget.draft.copyWith(phoneNumber: normalized),
    );
  }

  void _onPhoneNumberChanged(String _) {
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
      title: 'Số điện thoại của bạn?',
      inputController: _phoneNumberController,
      inputHintText: 'Nhập số điện thoại',
      keyboardType: TextInputType.phone,
      errorText: _errorText,
      showAgreement: false,
      onInputChanged: _onPhoneNumberChanged,
      onContinuePressed: _onContinuePressed,
    );
  }
}
