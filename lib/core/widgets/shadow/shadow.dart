import 'package:flutter/material.dart' as m;

enum AppShadowSize { small, medium, large }

class AppShadow extends m.StatelessWidget {
  const AppShadow({
    super.key,
    required this.child,
    this.size = AppShadowSize.medium,
    this.borderRadius,
    this.color,
    this.padding,
    this.margin,
  });

  final m.Widget child;
  final AppShadowSize size;
  final m.BorderRadiusGeometry? borderRadius;
  final m.Color? color;
  final m.EdgeInsetsGeometry? padding;
  final m.EdgeInsetsGeometry? margin;

  List<m.BoxShadow> _resolveShadows() {
    return switch (size) {
      AppShadowSize.small => const [
        m.BoxShadow(
          color: m.Color(0x14141414),
          blurRadius: 8,
          offset: m.Offset(0, 0),
          spreadRadius: 0,
        ),
        m.BoxShadow(
          color: m.Color(0x0A141414),
          blurRadius: 1,
          offset: m.Offset(0, 0),
          spreadRadius: 0,
        ),
      ],
      AppShadowSize.medium => const [
        m.BoxShadow(
          color: m.Color(0x14141414),
          blurRadius: 8,
          offset: m.Offset(0, 1),
          spreadRadius: 2,
        ),
        m.BoxShadow(
          color: m.Color(0x14141414),
          blurRadius: 1,
          offset: m.Offset(0, 0),
          spreadRadius: 0,
        ),
      ],
      AppShadowSize.large => const [
        m.BoxShadow(
          color: m.Color(0x14141414),
          blurRadius: 24,
          offset: m.Offset(0, 1),
          spreadRadius: 8,
        ),
      ],
    };
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.Container(
      margin: margin,
      padding: padding,
      decoration: m.BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: _resolveShadows(),
      ),
      child: child,
    );
  }
}
