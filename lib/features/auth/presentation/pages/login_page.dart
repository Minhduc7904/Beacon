import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/navigation/back_button.dart';
import '../controllers/auth_state.dart';
import '../widgets/login/login_brand_text.dart';
import '../widgets/login/login_form.dart';

class LoginAutoFillData {
  const LoginAutoFillData({
    required this.username,
    required this.password,
    this.autoSubmit = false,
  });

  final String username;
  final String password;
  final bool autoSubmit;
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
    this.autoFillData,
  });

  final LoginAutoFillData? autoFillData;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _didApplyAutoFill = false;

  @override
  void initState() {
    super.initState();
    _applyAutoFillIfNeeded();
  }

  void _applyAutoFillIfNeeded() {
    final autoFillData = widget.autoFillData;
    if (_didApplyAutoFill || autoFillData == null) {
      return;
    }

    _didApplyAutoFill = true;
    _usernameController.text = autoFillData.username;
    _passwordController.text = autoFillData.password;

    if (autoFillData.autoSubmit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _onSubmit();
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    ref
        .read(authNotifierProvider.notifier)
        .login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (_, state) {
      if (state is AuthSuccess) {
        context.go(AppRoutes.home);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _LoginHeader(),
            Expanded(
              child: LoginForm(
                formKey: _formKey,
                usernameController: _usernameController,
                passwordController: _passwordController,
                authState: authState,
                isLoading: isLoading,
                onSubmit: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 218,
      child: Stack(
        children: [
          const Center(child: LoginBrandText()),
          Positioned(
            top: 16,
            left: 16,
            child: AppBackButton(
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
