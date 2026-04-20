import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../widgets/register/register_step_layout.dart';
import 'register_draft_data.dart';

class RegisterPageUsername extends StatefulWidget {
  const RegisterPageUsername({super.key, required this.draft});

  final RegisterDraftData draft;

  @override
  State<RegisterPageUsername> createState() => _RegisterPageUsernameState();
}

class _RegisterPageUsernameState extends State<RegisterPageUsername> {
  final _usernameController = TextEditingController();
  String? _usernameError;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _onCompletePressed() {
    final username = _usernameController.text.trim();
    final usernameError = username.isEmpty
        ? 'Vui lòng nhập tên người dùng'
        : null;

    setState(() {
      _usernameError = usernameError;
    });

    if (usernameError != null) {
      return;
    }

    FocusScope.of(context).unfocus();
    final payload = widget.draft.copyWith(username: username).toApiPayload();
    debugPrint('Register payload for future API: ${jsonEncode(payload)}');
  }

  void _onUsernameChanged(String _) {
    if (_usernameError != null) {
      setState(() {
        _usernameError = null;
      });
      return;
    }

    setState(() {});
  }

  InputState _resolveState() {
    if (_usernameError != null && _usernameError!.trim().isNotEmpty) {
      return InputState.error;
    }

    if (_usernameController.text.trim().isNotEmpty) {
      return InputState.filled;
    }

    return InputState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    return RegisterStepLayout(
      title: 'Tên người dùng',
      inputController: _usernameController,
      inputHintText: 'Nhập tên người dùng',
      continueText: 'Hoàn tất',
      showAgreement: false,
      instructionText: 'Tên người dùng sẽ được hiển thị với bạn bè của bạn',
      inputFields: [
        Input(
          controller: _usernameController,
          hintText: 'Nhập tên người dùng',
          state: _resolveState(),
          caption: _usernameError,
          onChanged: _onUsernameChanged,
        ),
      ],
      onContinuePressed: _onCompletePressed,
    );
  }
}
