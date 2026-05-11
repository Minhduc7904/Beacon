import 'package:flutter/widgets.dart';

import 'app_icon_type.dart';

class AppIconData {
  const AppIconData._({
    required this.type,
    this.phosphorIcon,
    this.svgAsset,
  });

  const AppIconData.phosphor(IconData icon)
    : this._(type: AppIconType.phosphor, phosphorIcon: icon);

  const AppIconData.svg(String asset)
    : this._(type: AppIconType.svg, svgAsset: asset);

  final AppIconType type;
  final IconData? phosphorIcon;
  final String? svgAsset;
}
