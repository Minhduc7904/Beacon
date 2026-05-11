import 'package:flutter/material.dart';

class AppFonts {
  AppFonts._();

  static const String chironGoRoundTc = 'Chiron GoRound TC';
  static const String kavoon = 'Kavoon';

  // Add more font families here when needed.
  static const String sfPro = 'SF Pro Display';

  static const String defaultFamily = chironGoRoundTc;

  static String _effectiveFamily(String fontFamily) {
    if (fontFamily == sfPro) {
      return defaultFamily;
    }

    return fontFamily;
  }

  static TextTheme resolveTextTheme(
    TextTheme textTheme, {
    String fontFamily = defaultFamily,
  }) {
    return textTheme.apply(fontFamily: _effectiveFamily(fontFamily));
  }

  static TextStyle resolveTextStyle(
    TextStyle textStyle, {
    String fontFamily = defaultFamily,
  }) {
    return textStyle.copyWith(fontFamily: _effectiveFamily(fontFamily));
  }
}
