import 'package:flutter/material.dart';
import '../controllers/auth_state.dart';
import 'login_button.dart';
import 'login_text_field.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final AuthState authState;
  final bool isLoading;
  final VoidCallback onSubmit;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.authState,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  String? get _validationError {
    if (widget.authState is AuthValidationError) {
      return (widget.authState as AuthValidationError).message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginTextField(
            controller: widget.usernameController,
            label: 'Tên đăng nhập',
            hint: 'Nhập tên đăng nhập',
            prefixIcon: Icons.person_outline,
            enabled: !widget.isLoading,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: widget.passwordController,
            label: 'Mật khẩu',
            hint: 'Nhập mật khẩu',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            enabled: !widget.isLoading,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => widget.onSubmit(),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          if (_validationError != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: _validationError!),
          ],
          const SizedBox(height: 28),
          LoginButton(
            isLoading: widget.isLoading,
            onPressed: widget.onSubmit,
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
