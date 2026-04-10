import 'package:flutter/material.dart' as m;

class Input extends m.StatelessWidget {
  final String? labelText;
  final String? hintText;
  final m.TextEditingController? controller;
  final m.ValueChanged<String>? onChanged;
  final m.TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int maxLines;

  const Input({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.onChanged,
    this.keyboardType = m.TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      decoration: m.InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const m.OutlineInputBorder(),
      ),
    );
  }
}
