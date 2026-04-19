import 'package:flutter/material.dart';
import 'app_fonts.dart';

enum AppTextSize { large, regular, small, tiny, veryTiny }

enum AppTextSpacing { none, tight, normal }

enum AppTextWeight { bold, medium, regular }

class AppTextTheme {
  AppTextTheme._();

  static const TextStyle _title1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.17,
  );

  static const TextStyle _title2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.13,
  );

  static const TextStyle _title3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
  );

  static const double _sizeLarge = 18;
  static const double _sizeRegular = 16;
  static const double _sizeSmall = 14;
  static const double _sizeTiny = 12;
  static const double _sizeVeryTiny = 10;

  static double _fontSize(AppTextSize size) {
    switch (size) {
      case AppTextSize.large:
        return _sizeLarge;
      case AppTextSize.regular:
        return _sizeRegular;
      case AppTextSize.small:
        return _sizeSmall;
      case AppTextSize.tiny:
        return _sizeTiny;
      case AppTextSize.veryTiny:
        return _sizeVeryTiny;
    }
  }

  static double _lineHeightPx(AppTextSize size, AppTextSpacing spacing) {
    switch (size) {
      case AppTextSize.large:
        switch (spacing) {
          case AppTextSpacing.none:
            return 18;
          case AppTextSpacing.tight:
            return 20;
          case AppTextSpacing.normal:
            return 24;
        }
      case AppTextSize.regular:
        switch (spacing) {
          case AppTextSpacing.none:
            return 16;
          case AppTextSpacing.tight:
            return 20;
          case AppTextSpacing.normal:
            return 24;
        }
      case AppTextSize.small:
        switch (spacing) {
          case AppTextSpacing.none:
            return 14;
          case AppTextSpacing.tight:
            return 16;
          case AppTextSpacing.normal:
            return 20;
        }
      case AppTextSize.tiny:
        switch (spacing) {
          case AppTextSpacing.none:
            return 12;
          case AppTextSpacing.tight:
            return 14;
          case AppTextSpacing.normal:
            return 16;
        }
      case AppTextSize.veryTiny:
        switch (spacing) {
          case AppTextSpacing.none:
            return 10;
          case AppTextSpacing.tight:
            return 12;
          case AppTextSpacing.normal:
            return 14;
        }
    }
  }

  static FontWeight _fontWeight(AppTextWeight weight) {
    switch (weight) {
      case AppTextWeight.bold:
        return FontWeight.w700;
      case AppTextWeight.medium:
        return FontWeight.w500;
      case AppTextWeight.regular:
        return FontWeight.w400;
    }
  }

  static TextStyle style({
    required AppTextSize size,
    required AppTextSpacing spacing,
    required AppTextWeight weight,
    String fontFamily = AppFonts.defaultFamily,
  }) {
    final fontSize = _fontSize(size);
    final lineHeightPx = _lineHeightPx(size, spacing);

    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: lineHeightPx / fontSize,
      fontWeight: _fontWeight(weight),
    );
  }

  static TextTheme textTheme({String fontFamily = AppFonts.defaultFamily}) {
    return TextTheme(
      displayMedium: _title1,
      headlineLarge: _title2,
      headlineSmall: _title3,
      titleLarge: style(
        size: AppTextSize.large,
        spacing: AppTextSpacing.none,
        weight: AppTextWeight.bold,
        fontFamily: fontFamily,
      ),
      titleMedium: style(
        size: AppTextSize.regular,
        spacing: AppTextSpacing.none,
        weight: AppTextWeight.medium,
        fontFamily: fontFamily,
      ),
      bodyLarge: style(
        size: AppTextSize.regular,
        spacing: AppTextSpacing.normal,
        weight: AppTextWeight.regular,
        fontFamily: fontFamily,
      ),
      bodyMedium: style(
        size: AppTextSize.small,
        spacing: AppTextSpacing.none,
        weight: AppTextWeight.regular,
        fontFamily: fontFamily,
      ),
      bodySmall: style(
        size: AppTextSize.tiny,
        spacing: AppTextSpacing.none,
        weight: AppTextWeight.regular,
        fontFamily: fontFamily,
      ),
      labelLarge: style(
        size: AppTextSize.small,
        spacing: AppTextSpacing.tight,
        weight: AppTextWeight.bold,
        fontFamily: fontFamily,
      ),
      labelMedium: style(
        size: AppTextSize.tiny,
        spacing: AppTextSpacing.none,
        weight: AppTextWeight.medium,
        fontFamily: fontFamily,
      ),
      labelSmall: style(
        size: AppTextSize.veryTiny,
        spacing: AppTextSpacing.normal,
        weight: AppTextWeight.regular,
        fontFamily: fontFamily,
      ),
    );
  }
}

extension AppTextThemeX on TextTheme {
  TextStyle? get title1 => displayMedium;
  TextStyle? get title2 => headlineLarge;
  TextStyle? get title3 => headlineSmall;

  TextStyle ui({
    required AppTextSize size,
    required AppTextSpacing spacing,
    required AppTextWeight weight,
  }) {
    return AppTextTheme.style(
      size: size,
      spacing: spacing,
      weight: weight,
      fontFamily: bodyMedium?.fontFamily ?? AppFonts.defaultFamily,
    );
  }
}
