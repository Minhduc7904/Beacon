import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../controllers/auth_state.dart';
import '../../widgets/register/register_step_layout.dart';
import 'register_draft_data.dart';

class RegisterPageUsername extends ConsumerStatefulWidget {
  const RegisterPageUsername({super.key, required this.draft});

  final RegisterDraftData draft;

  @override
  ConsumerState<RegisterPageUsername> createState() =>
      _RegisterPageUsernameState();
}

class _RegisterPageUsernameState extends ConsumerState<RegisterPageUsername> {
  final _usernameController = TextEditingController();
  String? _usernameError;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onCompletePressed() async {
    final authState = ref.read(authNotifierProvider);
    if (authState is AuthLoading) {
      return;
    }

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

    final draft = widget.draft.copyWith(username: username);
    if (!draft.hasEmail ||
        !draft.hasPassword ||
        !draft.hasName ||
        !draft.hasPhoneNumber ||
        !draft.hasUsername) {
      setState(() {
        _usernameError = 'Thiếu dữ liệu đăng ký, vui lòng nhập lại từ đầu';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    await ref
        .read(authNotifierProvider.notifier)
        .register(
          email: draft.email!.trim(),
          username: draft.username!.trim(),
          password: draft.password!,
          confirmPassword: draft.password!,
          familyName: draft.familyName!.trim(),
          givenName: draft.givenName!.trim(),
          phoneNumber: draft.phoneNumber!.trim(),
        );
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
    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (!mounted) {
        return;
      }

      if (state is AuthSuccess) {
        context.go(AppRoutes.home);
        return;
      }

      if (state is AuthValidationError) {
        setState(() {
          _usernameError = state.message;
        });
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return RegisterStepLayout(
      title: 'Tên người dùng',
      inputController: _usernameController,
      inputHintText: 'Nhập tên người dùng',
      continueText: 'Hoàn tất',
      isLoading: isLoading,
      loadingText: 'Đang đăng ký...',
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
