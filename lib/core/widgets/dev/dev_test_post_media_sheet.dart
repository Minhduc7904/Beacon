import 'package:flutter/material.dart';

class DevTestPostMediaSheet extends StatefulWidget {
  const DevTestPostMediaSheet({
    super.key,
    required this.onStart,
  });

  final void Function(String username, String password) onStart;

  @override
  State<DevTestPostMediaSheet> createState() => _DevTestPostMediaSheetState();
}

class _DevTestPostMediaSheetState extends State<DevTestPostMediaSheet> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _startFlow() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      return;
    }

    widget.onStart(username, password);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: mediaQuery.viewInsets.bottom + 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.82),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Test post media',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Tài khoản',
                  hintText: 'Nhập tài khoản',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu tài khoản',
                  hintText: 'Nhập mật khẩu',
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _startFlow,
                child: const Text('Bắt đầu'),
              ),
              const Spacer(),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
