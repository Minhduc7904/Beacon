import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_icon_data.dart';
import 'app_icon_type.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final AppIconData icon;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    switch (icon.type) {
      case AppIconType.phosphor:
        final phosphorIcon = icon.phosphorIcon;
        assert(phosphorIcon != null, 'Missing Phosphor icon data');
        return Icon(
          phosphorIcon,
          size: size,
          color: color,
          semanticLabel: semanticLabel,
        );
      case AppIconType.svg:
        final svgAsset = icon.svgAsset;
        assert(svgAsset != null, 'Missing SVG asset path');
        return SvgPicture.asset(
          svgAsset!,
          width: size,
          height: size,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
          semanticsLabel: semanticLabel,
        );
    }
  }
}
