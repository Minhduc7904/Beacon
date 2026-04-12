import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_text_theme.dart';

class AppButtonColors {
  const AppButtonColors({
    required this.background,
    required this.pressedBackground,
    required this.disabledBackground,
    required this.foregroundDefault,
    required this.foregroundPressed,
    required this.foregroundDisabled,
    required this.borderColorDefault,
    required this.borderColorPressed,
    required this.borderColorDisabled,
  });

  final Color background;
  final Color pressedBackground;
  final Color disabledBackground;
  final Color foregroundDefault;
  final Color foregroundPressed;
  final Color foregroundDisabled;
  final Color borderColorDefault;
  final Color borderColorPressed;
  final Color borderColorDisabled;

  AppButtonColors copyWith({
    Color? background,
    Color? pressedBackground,
    Color? disabledBackground,
    Color? foregroundDefault,
    Color? foregroundPressed,
    Color? foregroundDisabled,
    Color? borderColorDefault,
    Color? borderColorPressed,
    Color? borderColorDisabled,
  }) {
    return AppButtonColors(
      background: background ?? this.background,
      pressedBackground: pressedBackground ?? this.pressedBackground,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      foregroundDefault: foregroundDefault ?? this.foregroundDefault,
      foregroundPressed: foregroundPressed ?? this.foregroundPressed,
      foregroundDisabled: foregroundDisabled ?? this.foregroundDisabled,
      borderColorDefault: borderColorDefault ?? this.borderColorDefault,
      borderColorPressed: borderColorPressed ?? this.borderColorPressed,
      borderColorDisabled: borderColorDisabled ?? this.borderColorDisabled,
    );
  }

  static AppButtonColors lerp(AppButtonColors a, AppButtonColors b, double t) {
    return AppButtonColors(
      background: Color.lerp(a.background, b.background, t)!,
      pressedBackground: Color.lerp(a.pressedBackground, b.pressedBackground, t)!,
      disabledBackground: Color.lerp(a.disabledBackground, b.disabledBackground, t)!,
      foregroundDefault: Color.lerp(a.foregroundDefault, b.foregroundDefault, t)!,
      foregroundPressed: Color.lerp(a.foregroundPressed, b.foregroundPressed, t)!,
      foregroundDisabled: Color.lerp(a.foregroundDisabled, b.foregroundDisabled, t)!,
      borderColorDefault: Color.lerp(a.borderColorDefault, b.borderColorDefault, t)!,
      borderColorPressed: Color.lerp(a.borderColorPressed, b.borderColorPressed, t)!,
      borderColorDisabled: Color.lerp(a.borderColorDisabled, b.borderColorDisabled, t)!,
    );
  }
}

class AppButtonPalette {
  const AppButtonPalette({
    required this.primary,
    required this.secondary,
    required this.outline,
    required this.transparent,
  });

  final AppButtonColors primary;
  final AppButtonColors secondary;
  final AppButtonColors outline;
  final AppButtonColors transparent;

  AppButtonPalette copyWith({
    AppButtonColors? primary,
    AppButtonColors? secondary,
    AppButtonColors? outline,
    AppButtonColors? transparent,
  }) {
    return AppButtonPalette(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      outline: outline ?? this.outline,
      transparent: transparent ?? this.transparent,
    );
  }

  static AppButtonPalette lerp(AppButtonPalette a, AppButtonPalette b, double t) {
    return AppButtonPalette(
      primary: AppButtonColors.lerp(a.primary, b.primary, t),
      secondary: AppButtonColors.lerp(a.secondary, b.secondary, t),
      outline: AppButtonColors.lerp(a.outline, b.outline, t),
      transparent: AppButtonColors.lerp(a.transparent, b.transparent, t),
    );
  }
}

class AppButtonThemeData extends ThemeExtension<AppButtonThemeData> {
  const AppButtonThemeData({
    required this.light,
    required this.dark,
  });

  final AppButtonPalette light;
  final AppButtonPalette dark;

  factory AppButtonThemeData.light() {
    return const AppButtonThemeData(
      light: AppButtonPalette(
        primary: AppButtonColors(
          background: AppColors.buttonPrimaryDefault,
          pressedBackground: AppColors.buttonPrimaryPressed,
          disabledBackground: AppColors.buttonPrimaryDisabled,
          foregroundDefault: AppColors.buttonPrimaryTextDefault,
          foregroundPressed: AppColors.buttonPrimaryTextPressed,
          foregroundDisabled: AppColors.buttonPrimaryTextDisabled,
          borderColorDefault: AppColors.buttonPrimaryDefault,
          borderColorPressed: AppColors.buttonPrimaryPressed,
          borderColorDisabled: AppColors.buttonPrimaryDisabled,
        ),
        secondary: AppButtonColors(
          background: AppColors.buttonSecondaryDefault,
          pressedBackground: AppColors.buttonSecondaryPressed,
          disabledBackground: AppColors.buttonSecondaryDisabled,
          foregroundDefault: AppColors.buttonSecondaryTextDefault,
          foregroundPressed: AppColors.buttonSecondaryTextPressed,
          foregroundDisabled: AppColors.buttonSecondaryTextDisabled,
          borderColorDefault: AppColors.buttonSecondaryDefault,
          borderColorPressed: AppColors.buttonSecondaryPressed,
          borderColorDisabled: AppColors.buttonSecondaryDisabled,
        ),
        outline: AppButtonColors(
          background: AppColors.buttonOutlineDefault,
          pressedBackground: AppColors.buttonOutlinePressed,
          disabledBackground: AppColors.buttonOutlineDisabled,
          foregroundDefault: AppColors.buttonOutlineTextDefault,
          foregroundPressed: AppColors.buttonOutlineTextPressed,
          foregroundDisabled: AppColors.buttonOutlineTextDisabled,
          borderColorDefault: AppColors.buttonOutlineBorderDefault,
          borderColorPressed: AppColors.buttonOutlineBorderPressed,
          borderColorDisabled: AppColors.buttonOutlineBorderDisabled,
        ),
        transparent: AppButtonColors(
          background: AppColors.buttonTransparentDefault,
          pressedBackground: AppColors.buttonTransparentPressed,
          disabledBackground: AppColors.buttonTransparentDisabled,
          foregroundDefault: AppColors.buttonTransparentTextDefault,
          foregroundPressed: AppColors.buttonTransparentTextPressed,
          foregroundDisabled: AppColors.buttonTransparentTextDisabled,
          borderColorDefault: AppColors.buttonTransparentDefault,
          borderColorPressed: AppColors.buttonTransparentPressed,
          borderColorDisabled: AppColors.buttonTransparentDisabled,
        ),
      ),
      dark: AppButtonPalette(
        primary: AppButtonColors(
          background: AppColors.buttonPrimaryDefault,
          pressedBackground: AppColors.buttonPrimaryPressed,
          disabledBackground: AppColors.buttonPrimaryDisabled,
          foregroundDefault: AppColors.buttonPrimaryTextDefault,
          foregroundPressed: AppColors.buttonPrimaryTextPressed,
          foregroundDisabled: AppColors.buttonPrimaryTextDisabled,
          borderColorDefault: AppColors.buttonPrimaryDefault,
          borderColorPressed: AppColors.buttonPrimaryPressed,
          borderColorDisabled: AppColors.buttonPrimaryDisabled,
        ),
        secondary: AppButtonColors(
          background: AppColors.buttonSecondaryDefault,
          pressedBackground: AppColors.buttonSecondaryPressed,
          disabledBackground: AppColors.buttonSecondaryDisabled,
          foregroundDefault: AppColors.buttonSecondaryTextDefault,
          foregroundPressed: AppColors.buttonSecondaryTextPressed,
          foregroundDisabled: AppColors.buttonSecondaryTextDisabled,
          borderColorDefault: AppColors.buttonSecondaryDefault,
          borderColorPressed: AppColors.buttonSecondaryPressed,
          borderColorDisabled: AppColors.buttonSecondaryDisabled,
        ),
        outline: AppButtonColors(
          background: AppColors.buttonOutlineDefault,
          pressedBackground: AppColors.buttonOutlinePressed,
          disabledBackground: AppColors.buttonOutlineDisabled,
          foregroundDefault: AppColors.buttonOutlineTextDefault,
          foregroundPressed: AppColors.buttonOutlineTextPressed,
          foregroundDisabled: AppColors.buttonOutlineTextDisabled,
          borderColorDefault: AppColors.buttonOutlineBorderDefault,
          borderColorPressed: AppColors.buttonOutlineBorderPressed,
          borderColorDisabled: AppColors.buttonOutlineBorderDisabled,
        ),
        transparent: AppButtonColors(
          background: AppColors.buttonTransparentDefault,
          pressedBackground: AppColors.buttonTransparentPressed,
          disabledBackground: AppColors.buttonTransparentDisabled,
          foregroundDefault: AppColors.buttonTransparentTextDefault,
          foregroundPressed: AppColors.buttonTransparentTextPressed,
          foregroundDisabled: AppColors.buttonTransparentTextDisabled,
          borderColorDefault: AppColors.buttonTransparentDefault,
          borderColorPressed: AppColors.buttonTransparentPressed,
          borderColorDisabled: AppColors.buttonTransparentDisabled,
        ),
      ),
    );
  }

  AppButtonThemeData copyWith({
    AppButtonPalette? light,
    AppButtonPalette? dark,
  }) {
    return AppButtonThemeData(
      light: light ?? this.light,
      dark: dark ?? this.dark,
    );
  }

  @override
  AppButtonThemeData lerp(ThemeExtension<AppButtonThemeData>? other, double t) {
    if (other is! AppButtonThemeData) {
      return this;
    }

    return AppButtonThemeData(
      light: AppButtonPalette.lerp(light, other.light, t),
      dark: AppButtonPalette.lerp(dark, other.dark, t),
    );
  }
}

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

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[
        AppButtonThemeData.light(),
      ],
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTextTheme.textTheme(fontFamily: fontFamily).apply(
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
          textStyle:
              AppTextTheme.textTheme(fontFamily: fontFamily).labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
