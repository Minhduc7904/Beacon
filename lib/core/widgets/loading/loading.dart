import 'package:flutter/material.dart' as m;

class AppLoadingIndicator extends m.StatelessWidget {
  final m.Color color;
  final double size;
  final double strokeWidth;

  const AppLoadingIndicator({
    super.key,
    required this.color,
    this.size = 18,
    this.strokeWidth = 2,
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.SizedBox(
      width: size,
      height: size,
      child: m.CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: m.AlwaysStoppedAnimation<m.Color>(color),
      ),
    );
  }
}
