import 'package:flutter/material.dart';
import '../color/app_colors.dart';
import '../text/app_fonts.dart';
import '../text/app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme({String fontFamily = AppFonts.defaultFamily}) {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      outline: AppColors.outline,
    );

    final appTextTheme = AppFonts.resolveTextTheme(
      AppTextTheme.textTheme(fontFamily: fontFamily),
      fontFamily: fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: appTextTheme.apply(
        bodyColor: AppColors.onBackground,
        displayColor: AppColors.onBackground,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: AppColors.shadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          textStyle: appTextTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme({String fontFamily = AppFonts.defaultFamily}) {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.teal300,
      onPrimary: AppColors.ink600,
      primaryContainer: AppColors.teal500,
      onPrimaryContainer: AppColors.sky100,
      secondary: AppColors.coral300,
      onSecondary: AppColors.ink600,
      secondaryContainer: AppColors.coral500,
      onSecondaryContainer: AppColors.sky100,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.ink500,
      onSurface: AppColors.sky200,
      outline: AppColors.ink300,
    );

    final appTextTheme = AppFonts.resolveTextTheme(
      AppTextTheme.textTheme(fontFamily: fontFamily),
      fontFamily: fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.ink600,
      textTheme: appTextTheme.apply(
        bodyColor: AppColors.sky200,
        displayColor: AppColors.sky200,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.ink500,
        foregroundColor: AppColors.sky200,
      ),
      cardTheme: CardThemeData(
        color: AppColors.ink500,
        elevation: 0,
        shadowColor: AppColors.shadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.ink300),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.ink400,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.ink300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.ink300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.teal300, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          textStyle: appTextTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
