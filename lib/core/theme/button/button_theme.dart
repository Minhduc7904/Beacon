import 'package:flutter/material.dart' as m;

import '../color/app_colors.dart';

class ButtonColors {
  const ButtonColors({
    required this.background,
    required this.pressedBackground,
    required this.disabledBackground,
    required this.foregroundDefault,
    required this.foregroundPressed,
    required this.foregroundDisabled,
    required this.loadingDefault,
    required this.loadingPressed,
    required this.loadingDisabled,
    required this.borderColorDefault,
    required this.borderColorPressed,
    required this.borderColorDisabled,
  });

  final m.Color background;
  final m.Color pressedBackground;
  final m.Color disabledBackground;
  final m.Color foregroundDefault;
  final m.Color foregroundPressed;
  final m.Color foregroundDisabled;
  final m.Color loadingDefault;
  final m.Color loadingPressed;
  final m.Color loadingDisabled;
  final m.Color borderColorDefault;
  final m.Color borderColorPressed;
  final m.Color borderColorDisabled;
}

class ButtonColorsPalette {
  const ButtonColorsPalette({
    required this.primary,
    required this.secondary,
    required this.outline,
    required this.transparent,
  });

  final ButtonColors primary;
  final ButtonColors secondary;
  final ButtonColors outline;
  final ButtonColors transparent;
}

class ButtonThemePalette {
  const ButtonThemePalette._();

  static const ButtonColorsPalette light = ButtonColorsPalette(
    primary: ButtonColors(
      background: AppColors.teal400,
      pressedBackground: AppColors.teal500,
      disabledBackground: AppColors.sky400,
      foregroundDefault: AppColors.sky100,
      foregroundPressed: AppColors.sky100,
      foregroundDisabled: AppColors.sky600,
      loadingDefault: AppColors.sky100,
      loadingPressed: AppColors.sky100,
      loadingDisabled: AppColors.sky600,
      borderColorDefault: AppColors.teal400,
      borderColorPressed: AppColors.teal500,
      borderColorDisabled: AppColors.sky400,
    ),
    secondary: ButtonColors(
      background: AppColors.teal100,
      pressedBackground: AppColors.teal200,
      disabledBackground: AppColors.sky400,
      foregroundDefault: AppColors.teal400,
      foregroundPressed: AppColors.teal500,
      foregroundDisabled: AppColors.sky600,
      loadingDefault: AppColors.teal400,
      loadingPressed: AppColors.teal500,
      loadingDisabled: AppColors.sky600,
      borderColorDefault: AppColors.teal100,
      borderColorPressed: AppColors.teal200,
      borderColorDisabled: AppColors.sky400,
    ),
    outline: ButtonColors(
      background: AppColors.sky100,
      pressedBackground: AppColors.sky100,
      disabledBackground: AppColors.sky100,
      foregroundDefault: AppColors.teal400,
      foregroundPressed: AppColors.teal500,
      foregroundDisabled: AppColors.sky500,
      loadingDefault: AppColors.teal400,
      loadingPressed: AppColors.teal500,
      loadingDisabled: AppColors.sky500,
      borderColorDefault: AppColors.teal400,
      borderColorPressed: AppColors.teal500,
      borderColorDisabled: AppColors.sky500,
    ),
    transparent: ButtonColors(
      background: AppColors.sky100,
      pressedBackground: AppColors.teal100,
      disabledBackground: AppColors.sky100,
      foregroundDefault: AppColors.teal400,
      foregroundPressed: AppColors.teal400,
      foregroundDisabled: AppColors.teal400,
      loadingDefault: AppColors.teal400,
      loadingPressed: AppColors.teal400,
      loadingDisabled: AppColors.teal400,
      borderColorDefault: AppColors.sky100,
      borderColorPressed: AppColors.teal100,
      borderColorDisabled: AppColors.sky100,
    ),
  );

  static const ButtonColorsPalette dark = ButtonColorsPalette(
    primary: ButtonColors(
      background: AppColors.teal400,
      pressedBackground: AppColors.teal500,
      disabledBackground: AppColors.sky400,
      foregroundDefault: AppColors.sky100,
      foregroundPressed: AppColors.sky100,
      foregroundDisabled: AppColors.sky600,
      loadingDefault: AppColors.sky100,
      loadingPressed: AppColors.sky100,
      loadingDisabled: AppColors.sky600,
      borderColorDefault: AppColors.teal400,
      borderColorPressed: AppColors.teal500,
      borderColorDisabled: AppColors.sky400,
    ),
    secondary: ButtonColors(
      background: AppColors.teal100,
      pressedBackground: AppColors.teal200,
      disabledBackground: AppColors.sky400,
      foregroundDefault: AppColors.teal400,
      foregroundPressed: AppColors.teal500,
      foregroundDisabled: AppColors.sky600,
      loadingDefault: AppColors.teal400,
      loadingPressed: AppColors.teal500,
      loadingDisabled: AppColors.sky600,
      borderColorDefault: AppColors.teal100,
      borderColorPressed: AppColors.teal200,
      borderColorDisabled: AppColors.sky400,
    ),
    outline: ButtonColors(
      background: AppColors.sky100,
      pressedBackground: AppColors.sky100,
      disabledBackground: AppColors.sky100,
      foregroundDefault: AppColors.teal400,
      foregroundPressed: AppColors.teal500,
      foregroundDisabled: AppColors.sky500,
      loadingDefault: AppColors.teal400,
      loadingPressed: AppColors.teal500,
      loadingDisabled: AppColors.sky500,
      borderColorDefault: AppColors.teal400,
      borderColorPressed: AppColors.teal500,
      borderColorDisabled: AppColors.sky500,
    ),
    transparent: ButtonColors(
      background: AppColors.sky100,
      pressedBackground: AppColors.teal100,
      disabledBackground: AppColors.sky100,
      foregroundDefault: AppColors.teal400,
      foregroundPressed: AppColors.teal400,
      foregroundDisabled: AppColors.teal400,
      loadingDefault: AppColors.teal400,
      loadingPressed: AppColors.teal400,
      loadingDisabled: AppColors.teal400,
      borderColorDefault: AppColors.sky100,
      borderColorPressed: AppColors.teal100,
      borderColorDisabled: AppColors.sky100,
    ),
  );
}
