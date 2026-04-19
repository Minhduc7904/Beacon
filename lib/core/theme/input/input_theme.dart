import 'package:flutter/material.dart' as m;

import '../color/app_colors.dart';

class InputStateColors {
  const InputStateColors({
    required this.border,
    required this.text,
    required this.hint,
    required this.caption,
    required this.background,
  });

  final m.Color border;
  final m.Color text;
  final m.Color hint;
  final m.Color caption;
  final m.Color background;
}

class InputColors {
  const InputColors({
    required this.defaultState,
    required this.focused,
    required this.filled,
    required this.error,
    required this.disabled,
    required this.label,
  });

  final InputStateColors defaultState;
  final InputStateColors focused;
  final InputStateColors filled;
  final InputStateColors error;
  final InputStateColors disabled;
  final m.Color label;
}

class InputThemePalette {
  const InputThemePalette._();

  static const InputColors light = InputColors(
    defaultState: InputStateColors(
      border: AppColors.sky400,
      text: AppColors.ink100,
      hint: AppColors.sky600,
      caption: AppColors.ink100,
      background: AppColors.sky100,
    ),
    focused: InputStateColors(
      border: AppColors.teal400,
      text: AppColors.ink500,
      hint: AppColors.ink100,
      caption: AppColors.ink100,
      background: AppColors.sky100,
    ),
    filled: InputStateColors(
      border: AppColors.sky400,
      text: AppColors.ink500,
      hint: AppColors.ink100,
      caption: AppColors.ink100,
      background: AppColors.sky100,
    ),
    error: InputStateColors(
      border: AppColors.red400,
      text: AppColors.ink500,
      hint: AppColors.red400,
      caption: AppColors.red400,
      background: AppColors.sky100,
    ),
    disabled: InputStateColors(
      border: AppColors.sky300,
      text: AppColors.sky500,
      hint: AppColors.sky500,
      caption: AppColors.ink100,
      background: AppColors.sky200,
    ),
    label: AppColors.ink600,
  );

  static const InputColors dark = InputColors(
    defaultState: InputStateColors(
      border: AppColors.sky400,
      text: AppColors.ink100,
      hint: AppColors.sky600,
      caption: AppColors.ink100,
      background: AppColors.sky100,
    ),
    focused: InputStateColors(
      border: AppColors.teal400,
      text: AppColors.ink500,
      hint: AppColors.ink100,
      caption: AppColors.ink100,
      background: AppColors.sky100,
    ),
    filled: InputStateColors(
      border: AppColors.sky400,
      text: AppColors.ink500,
      hint: AppColors.ink100,
      caption: AppColors.ink100,
      background: AppColors.sky100,
    ),
    error: InputStateColors(
      border: AppColors.red400,
      text: AppColors.ink500,
      hint: AppColors.red400,
      caption: AppColors.red400,
      background: AppColors.sky100,
    ),
    disabled: InputStateColors(
      border: AppColors.sky300,
      text: AppColors.sky500,
      hint: AppColors.sky500,
      caption: AppColors.ink100,
      background: AppColors.sky200,
    ),
    label: AppColors.ink600,
  );
}
