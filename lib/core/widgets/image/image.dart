import 'package:flutter/material.dart' as m;

class AppImage extends m.StatelessWidget {
  final m.ImageProvider image;
  final double? width;
  final double? height;
  final m.BoxFit fit;
  final m.AlignmentGeometry alignment;
  final m.Color? color;
  final m.BlendMode? colorBlendMode;
  final m.FilterQuality filterQuality;
  final m.ImageErrorWidgetBuilder? errorBuilder;
  final m.BoxShape shape;
  final m.BorderRadiusGeometry? borderRadius;
  final m.EdgeInsetsGeometry? padding;

  const AppImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = m.BoxFit.contain,
    this.alignment = m.Alignment.center,
    this.color,
    this.colorBlendMode,
    this.filterQuality = m.FilterQuality.medium,
    this.errorBuilder,
    this.shape = m.BoxShape.rectangle,
    this.borderRadius,
    this.padding,
  });

  @override
  m.Widget build(m.BuildContext context) {
    m.Widget child = m.Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      filterQuality: filterQuality,
      errorBuilder: errorBuilder,
    );

    if (shape == m.BoxShape.circle) {
      child = m.ClipOval(child: child);
    } else if (borderRadius != null) {
      child = m.ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }

    if (padding != null) {
      child = m.Padding(
        padding: padding!,
        child: child,
      );
    }

    return child;
  }
}
