import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static const String inter = 'Inter';
  static const String kavoon = 'Kavoon';

  // Add more font families here when needed.
  static const String sfPro = 'SF Pro Display';

  static const String defaultFamily = inter;

  static String _effectiveFamily(String fontFamily) {
    if (fontFamily == sfPro) {
      return inter;
    }

    return fontFamily;
  }

  static TextTheme resolveTextTheme(
    TextTheme textTheme, {
    String fontFamily = defaultFamily,
  }) {
    return GoogleFonts.getTextTheme(_effectiveFamily(fontFamily), textTheme);
  }

  static TextStyle resolveTextStyle(
    TextStyle textStyle, {
    String fontFamily = defaultFamily,
  }) {
    return GoogleFonts.getFont(
      _effectiveFamily(fontFamily),
      textStyle: textStyle,
    );
  }
}
