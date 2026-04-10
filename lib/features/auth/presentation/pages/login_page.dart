import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/image/logo_image.dart';
import '../../../../core/widgets/text/text.dart';
import '../controllers/auth_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _LoginHeader(),
                const SizedBox(height: 40),
                LoginForm(
                  formKey: _formKey,
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  authState: authState,
                  isLoading: isLoading,
                  onSubmit: _onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppLogoImage(width: 92, height: 92),
        const SizedBox(height: 16),
        AppText(
          'Đăng nhập',
          preset: AppTextPreset.title2,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        AppText(
          'Chào mừng bạn trở lại',
          preset: AppTextPreset.bodyMedium,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
        ),
      ],
    );
  }
}
