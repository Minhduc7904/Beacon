import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../widgets/register/register_step_layout.dart';
import 'register_draft_data.dart';

class RegisterPageName extends StatefulWidget {
  const RegisterPageName({super.key, required this.draft});

  final RegisterDraftData draft;

  @override
  State<RegisterPageName> createState() => _RegisterPageNameState();
}

class _RegisterPageNameState extends State<RegisterPageName> {
  final _familyNameController = TextEditingController();
  final _givenNameController = TextEditingController();

  String? _familyNameError;
  String? _givenNameError;

  @override
  void dispose() {
    _familyNameController.dispose();
    _givenNameController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    final familyName = _familyNameController.text.trim();
    final givenName = _givenNameController.text.trim();

    final familyNameError = familyName.isEmpty
        ? 'Vui lòng nhập họ và tên đệm'
        : null;
    final givenNameError = givenName.isEmpty ? 'Vui lòng nhập tên riêng' : null;

    setState(() {
      _familyNameError = familyNameError;
      _givenNameError = givenNameError;
    });

    if (familyNameError != null || givenNameError != null) {
      return;
    }

    FocusScope.of(context).unfocus();
    context.pushNamed(
      AppRoutes.registerUsernameName,
      extra: widget.draft.copyWith(
        familyName: familyName,
        givenName: givenName,
      ),
    );
  }

  void _onFamilyNameChanged(String _) {
    if (_familyNameError != null) {
      setState(() {
        _familyNameError = null;
      });
      return;
    }

    setState(() {});
  }

  void _onGivenNameChanged(String _) {
    if (_givenNameError != null) {
      setState(() {
        _givenNameError = null;
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

  @override
  Widget build(BuildContext context) {
    return RegisterStepLayout(
      title: 'Tên của bạn',
      inputController: _familyNameController,
      inputHintText: 'Nhập họ và tên đệm',
      showAgreement: false,
      inputFields: [
        Input(
          controller: _familyNameController,
          hintText: 'Nhập họ và tên đệm',
          state: _resolveState(_familyNameController.text, _familyNameError),
          caption: _familyNameError,
          onChanged: _onFamilyNameChanged,
        ),
        Input(
          controller: _givenNameController,
          hintText: 'Nhập tên riêng',
          state: _resolveState(_givenNameController.text, _givenNameError),
          caption: _givenNameError,
          onChanged: _onGivenNameChanged,
        ),
      ],
      onContinuePressed: _onContinuePressed,
    );
  }
}
