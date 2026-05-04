import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Ink
  static const Color ink100 = Color(0xFF72777A);
  static const Color ink200 = Color(0xFF6C7072);
  static const Color ink300 = Color(0xFF404446);
  static const Color ink400 = Color(0xFF303437);
  static const Color ink500 = Color(0xFF202325);
  static const Color ink600 = Color(0xFF090A0A);

  // Sky
  static const Color sky100 = Color(0xFFFFFFFF);
  static const Color sky200 = Color(0xFFF7F9FA);
  static const Color sky300 = Color(0xFFF2F4F5);
  static const Color sky400 = Color(0xFFE3E5E5);
  static const Color sky500 = Color(0xFFCDCFD0);
  static const Color sky600 = Color(0xFF979C9E);

  // Primary (Teal)
  static const Color teal100 = Color(0xFFCDFFF6);
  static const Color teal200 = Color(0xFFA2FFED);
  static const Color teal300 = Color(0xFF7EEFDA);
  static const Color teal400 = Color(
    0xFF66D0BC,
  ); // Primary color used in Figma design
  static const Color teal500 = Color(0xFF50AE9C);

  // Secondary (Coral)
  static const Color coral100 = Color(0xFFFFEEE5);
  static const Color coral200 = Color(0xFFFFD2BA);
  static const Color coral300 = Color(0xFFFFAD82);
  static const Color coral400 = Color(0xFFFF9760);
  static const Color coral500 = Color(0xFFFF7D38);

  static const Color red100 = Color(0xFFFFE5E5);
  static const Color red200 = Color(0xFFFF9898);
  static const Color red300 = Color(0xFFFF6D6D);
  static const Color red400 = Color(0xFFFF5247);
  static const Color red500 = Color(0xFFD3180C);
  static const Color amber400 = Color(0xFFFFB323);

  // Status
  static const Color success = Color(0xFF50C878);
  static const Color warning = Color(0xFFFFB07C);
  static const Color danger = Color(0xFF800020);

  // Semantic tokens used by ThemeData
  static const Color primary = teal400;
  static const Color onPrimary = sky100;
  static const Color primaryContainer = teal100;
  static const Color onPrimaryContainer = ink600;

  static const Color secondary = coral500;
  static const Color onSecondary = sky100;
  static const Color secondaryContainer = coral100;
  static const Color onSecondaryContainer = ink600;

  static const Color background = sky200;
  static const Color onBackground = ink500;
  static const Color surface = sky100;
  static const Color onSurface = ink500;

  static const Color error = danger;
  static const Color onError = sky100;

  static const Color outline = sky500;
  static const Color shadow = Color(0x1A090A0A);
}
