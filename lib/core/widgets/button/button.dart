import 'package:flutter/material.dart' as m;

class Button extends m.StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final m.Widget? icon;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  m.Widget build(m.BuildContext context) {
    if (icon != null) {
      return m.FilledButton.icon(
        onPressed: onPressed,
        icon: icon!,
        label: m.Text(text),
      );
    }

    return m.FilledButton(
      onPressed: onPressed,
      child: m.Text(text),
    );
  }
}
