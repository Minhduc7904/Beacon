import 'package:flutter/material.dart';

import '../../constants/app_images.dart';
import 'image.dart';

class AppLogoImage extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool useThemeVariant;
  final String? imagePath;
  final String? lightImagePath;
  final String? darkImagePath;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AppLogoImage({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.useThemeVariant = true,
    this.imagePath,
    this.lightImagePath,
    this.darkImagePath,
    this.color,
    this.colorBlendMode,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final resolvedPath =
        imagePath ??
        (useThemeVariant
            ? (brightness == Brightness.dark
                  ? (darkImagePath ?? AppImages.logoDark)
                  : (lightImagePath ?? AppImages.logoLight))
            : (lightImagePath ?? AppImages.logo));

    return AppImage(
      image: AssetImage(resolvedPath),
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      shape: shape,
      borderRadius: borderRadius,
      padding: padding,
      errorBuilder: (_, exception, stackTrace) {
        return Image.asset(
          AppImages.logo,
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
        );
      },
    );
  }
}
