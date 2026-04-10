import 'package:flutter/material.dart';

import '../../theme/app_text_theme.dart';

enum AppTextPreset {
  title1,
  title2,
  title3,
  titleLarge,
  titleMedium,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class AppText extends StatelessWidget {
  final String data;
  final AppTextPreset? preset;
  final AppTextSize? size;
  final AppTextSpacing? spacing;
  final AppTextWeight? weight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final TextStyle? style;

  const AppText(
    this.data, {
    super.key,
    this.preset,
    this.size,
    this.spacing,
    this.weight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.fontWeight,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    TextStyle resolvedStyle;

    if (preset != null) {
      resolvedStyle = _fromPreset(textTheme, preset!);
    } else if (size != null && spacing != null && weight != null) {
      resolvedStyle = textTheme.ui(
        size: size!,
        spacing: spacing!,
        weight: weight!,
      );
    } else {
      resolvedStyle = textTheme.bodyMedium ?? const TextStyle();
    }

    if (color != null || fontWeight != null || style != null) {
      resolvedStyle = resolvedStyle.copyWith(
        color: color,
        fontWeight: fontWeight,
      );

      if (style != null) {
        resolvedStyle = resolvedStyle.merge(style);
      }
    }

    return Text(
      data,
      style: resolvedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _fromPreset(TextTheme textTheme, AppTextPreset preset) {
    switch (preset) {
      case AppTextPreset.title1:
        return textTheme.title1 ?? const TextStyle();
      case AppTextPreset.title2:
        return textTheme.title2 ?? const TextStyle();
      case AppTextPreset.title3:
        return textTheme.title3 ?? const TextStyle();
      case AppTextPreset.titleLarge:
        return textTheme.titleLarge ?? const TextStyle();
      case AppTextPreset.titleMedium:
        return textTheme.titleMedium ?? const TextStyle();
      case AppTextPreset.bodyLarge:
        return textTheme.bodyLarge ?? const TextStyle();
      case AppTextPreset.bodyMedium:
        return textTheme.bodyMedium ?? const TextStyle();
      case AppTextPreset.bodySmall:
        return textTheme.bodySmall ?? const TextStyle();
      case AppTextPreset.labelLarge:
        return textTheme.labelLarge ?? const TextStyle();
      case AppTextPreset.labelMedium:
        return textTheme.labelMedium ?? const TextStyle();
      case AppTextPreset.labelSmall:
        return textTheme.labelSmall ?? const TextStyle();
    }
  }
}
