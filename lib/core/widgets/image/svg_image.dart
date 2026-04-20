import 'package:flutter/material.dart' as m;
import 'package:flutter_svg/flutter_svg.dart' as svg;

class AppSvgImage extends m.StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final m.BoxFit fit;
  final m.AlignmentGeometry alignment;
  final m.Color? color;
  final m.BlendMode colorBlendMode;
  final m.WidgetBuilder? placeholderBuilder;
  final m.BoxShape shape;
  final m.BorderRadiusGeometry? borderRadius;
  final m.EdgeInsetsGeometry? padding;

  const AppSvgImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = m.BoxFit.contain,
    this.alignment = m.Alignment.center,
    this.color,
    this.colorBlendMode = m.BlendMode.srcIn,
    this.placeholderBuilder,
    this.shape = m.BoxShape.rectangle,
    this.borderRadius,
    this.padding,
  });

  @override
  m.Widget build(m.BuildContext context) {
    m.Widget child = svg.SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: color == null
          ? null
          : m.ColorFilter.mode(color!, colorBlendMode),
      placeholderBuilder: placeholderBuilder,
    );

    if (shape == m.BoxShape.circle) {
      child = m.ClipOval(child: child);
    } else if (borderRadius != null) {
      child = m.ClipRRect(borderRadius: borderRadius!, child: child);
    }

    if (padding != null) {
      child = m.Padding(padding: padding!, child: child);
    }

    return child;
  }
}
