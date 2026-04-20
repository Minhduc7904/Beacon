import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/utils/phone_number_utils.dart';
import '../../widgets/register/register_step_layout.dart';
import '../../../domain/usecase/check_phone_availability_usecase.dart';
import 'register_draft_data.dart';

class RegisterPagePhoneNumber extends ConsumerStatefulWidget {
  const RegisterPagePhoneNumber({super.key, required this.draft});

  final RegisterDraftData draft;

  @override
  ConsumerState<RegisterPagePhoneNumber> createState() =>
      _RegisterPagePhoneNumberState();
}

class _RegisterPagePhoneNumberState
    extends ConsumerState<RegisterPagePhoneNumber> {
  static const bool _allowInternationalPhone = false;

  final _phoneNumberController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    if (_isLoading) {
      return;
    }

    final phoneNumber = _phoneNumberController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        _errorText = 'Vui lòng nhập số điện thoại';
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final result = await ref
        .read(checkPhoneAvailabilityUseCaseProvider)
        .call(CheckPhoneAvailabilityParams(phoneNumber: phoneNumber));

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
      (isAvailable) {
        if (!isAvailable) {
          setState(() {
            _errorText = 'Số điện thoại đã được sử dụng';
            _isLoading = false;
          });
          return;
        }

        final e164Phone = PhoneNumberUtils.toE164Vietnam(phoneNumber);
        if (e164Phone == null) {
          setState(() {
            _errorText = _allowInternationalPhone
                ? 'Vui lòng nhập số điện thoại hợp lệ'
                : 'Vui lòng nhập số điện thoại Việt Nam hợp lệ';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _isLoading = false;
        });

        FocusScope.of(context).unfocus();
        context.pushNamed(
          AppRoutes.registerPasswordName,
          extra: widget.draft.copyWith(phoneNumber: e164Phone),
        );
      },
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
      isLoading: _isLoading,
      loadingText: 'Đang kiểm tra...',
      showAgreement: false,
      onInputChanged: _onPhoneNumberChanged,
      onContinuePressed: _onContinuePressed,
    );
  }
}
