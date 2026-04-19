import 'package:flutter/material.dart' as m;

import '../../constants/app_images.dart';
import '../../theme/app_colors.dart';
import '../image/svg_image.dart';
import '../text/text.dart';
import '../widget_mode_resolver.dart';

enum InputMode { light, dark }

enum InputType { text, leftIcon, dropdown }

enum InputState { defaultState, focused, filled, error, disabled }

class _InputStateColors {
  const _InputStateColors({
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

class _InputColors {
  const _InputColors({
    required this.defaultState,
    required this.focused,
    required this.filled,
    required this.error,
    required this.disabled,
    required this.label,
  });

  final _InputStateColors defaultState;
  final _InputStateColors focused;
  final _InputStateColors filled;
  final _InputStateColors error;
  final _InputStateColors disabled;
  final m.Color label;
}

class Input extends m.StatelessWidget {
  final double height;
  final String? label;
  final String? labelText;
  final String? caption;
  final String? hintText;
  final m.Widget? leftIcon;
  final m.TextEditingController? controller;
  final m.ValueChanged<String>? onChanged;
  final m.TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final String? errorText;
  final InputMode? mode;
  final InputType type;
  final InputState state;

  const Input({
    super.key,
    this.height = 48,
    this.label,
    this.labelText,
    this.caption,
    this.hintText,
    this.leftIcon,
    this.controller,
    this.onChanged,
    this.keyboardType = m.TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.errorText,
    this.mode,
    this.type = InputType.text,
    this.state = InputState.defaultState,
  });

  InputMode _resolveMode(m.BuildContext context) {
    return resolveWidgetMode<InputMode>(
      context: context,
      mode: mode,
      lightMode: InputMode.light,
      darkMode: InputMode.dark,
    );
  }

  _InputColors _resolveColors(m.BuildContext context) {
    final resolvedMode = _resolveMode(context);

    if (resolvedMode == InputMode.dark) {
      return _InputColors(
        defaultState: const _InputStateColors(
          border: AppColors.sky400,
          text: AppColors.ink100,
          hint: AppColors.sky600,
          caption: AppColors.ink100,
          background: AppColors.sky100,
        ),
        focused: const _InputStateColors(
          border: AppColors.teal400,
          text: AppColors.ink500,
          hint: AppColors.ink100,
          caption: AppColors.ink100,
          background: AppColors.sky100,
        ),
        filled: const _InputStateColors(
          border: AppColors.sky400,
          text: AppColors.ink500,
          hint: AppColors.ink100,
          caption: AppColors.ink100,
          background: AppColors.sky100,
        ),
        error: const _InputStateColors(
          border: m.Color(0xFFFF5247),
          text: AppColors.ink500,
          hint: AppColors.red400,
          caption: AppColors.red400,
          background: AppColors.sky100,
        ),
        disabled: const _InputStateColors(
          border: AppColors.sky300,
          text: AppColors.sky500,
          hint: AppColors.sky500,
          caption: AppColors.ink100,
          background: AppColors.sky200,
        ),
        label: AppColors.ink600,
      );
    }

    return const _InputColors(
      defaultState: _InputStateColors(
        border: AppColors.sky400,
        text: AppColors.ink100,
        hint: AppColors.sky600,
        caption: AppColors.ink100,
        background: AppColors.sky100,
      ),
      focused: _InputStateColors(
        border: AppColors.teal400,
        text: AppColors.ink500,
        hint: AppColors.ink100,
        caption: AppColors.ink100,
        background: AppColors.sky100,
      ),
      filled: _InputStateColors(
        border: AppColors.sky400,
        text: AppColors.ink500,
        hint: AppColors.ink100,
        caption: AppColors.ink100,
        background: AppColors.sky100,
      ),
      error: _InputStateColors(
        border: m.Color(0xFFFF5247),
        text: AppColors.ink500,
        hint: AppColors.red400,
        caption: AppColors.red400,
        background: AppColors.sky100,
      ),
      disabled: _InputStateColors(
        border: AppColors.sky300,
        text: AppColors.sky500,
        hint: AppColors.sky500,
        caption: AppColors.ink100,
        background: AppColors.sky200,
      ),
      label: AppColors.ink600,
    );
  }

  _InputStateColors _colorsByState(_InputColors colors, InputState state) {
    return switch (state) {
      InputState.defaultState => colors.defaultState,
      InputState.focused => colors.focused,
      InputState.filled => colors.filled,
      InputState.error => colors.error,
      InputState.disabled => colors.disabled,
    };
  }

  m.InputBorder _borderByType(m.Color color) {
    return m.OutlineInputBorder(
      borderRadius: m.BorderRadius.circular(16),
      borderSide: m.BorderSide(color: color, width: 1),
    );
  }

  m.Widget? _buildPrefixIcon() {
    if (type != InputType.leftIcon) {
      return null;
    }

    return m.Padding(
      padding: const m.EdgeInsets.only(left: 12, right: 12),
      child: m.SizedBox(
        width: 24,
        height: 24,
        child: leftIcon ?? const m.SizedBox.shrink(),
      ),
    );
  }

  m.Widget? _buildSuffixIcon() {
    if (type != InputType.dropdown) {
      return null;
    }

    return m.Padding(
      padding: const m.EdgeInsets.only(left: 12, right: 12),
      child: const AppSvgImage(
        assetPath: AppImages.icChervDown,
        width: 24,
        height: 24,
      ),
    );
  }

  m.EdgeInsetsGeometry _contentPaddingByType() {
    return switch (type) {
      InputType.text => const m.EdgeInsets.symmetric(horizontal: 16),
      InputType.leftIcon => const m.EdgeInsets.only(right: 16),
      InputType.dropdown => const m.EdgeInsets.only(left: 16),
    };
  }

  @override
  m.Widget build(m.BuildContext context) {
    final isDisabled = !enabled || state == InputState.disabled;
    final effectiveState = isDisabled ? InputState.disabled : state;
    final colors = _resolveColors(context);
    final stateColors = _colorsByState(colors, effectiveState);
    final effectiveLabelRaw = label ?? labelText;
    final effectiveLabel =
        (effectiveLabelRaw == null || effectiveLabelRaw.trim().isEmpty)
        ? null
        : effectiveLabelRaw;
    final effectiveCaption = (caption == null || caption!.trim().isEmpty)
        ? null
        : caption;

    final inputField = m.TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: !isDisabled,
      textAlignVertical: m.TextAlignVertical.center,
      style: m.TextStyle(color: stateColors.text),
      maxLines: obscureText ? 1 : maxLines,

      decoration: m.InputDecoration(
        constraints: m.BoxConstraints(minHeight: height, maxHeight: height),
        contentPadding: _contentPaddingByType(),
        prefixIcon: _buildPrefixIcon(),
        prefixIconConstraints: type == InputType.leftIcon
            ? const m.BoxConstraints(minWidth: 48, minHeight: 24)
            : null,
        suffixIcon: _buildSuffixIcon(),
        suffixIconConstraints: type == InputType.dropdown
            ? const m.BoxConstraints(minWidth: 48, minHeight: 24)
            : null,
        filled: true,
        fillColor: stateColors.background,
        hintText: hintText,
        errorText: effectiveState == InputState.error ? errorText : null,
        hintStyle: m.TextStyle(color: stateColors.hint),
        border: _borderByType(stateColors.border),
        enabledBorder: _borderByType(stateColors.border),
        focusedBorder: _borderByType(colors.focused.border),
        disabledBorder: _borderByType(colors.disabled.border),
        errorBorder: _borderByType(colors.error.border),
        focusedErrorBorder: _borderByType(colors.error.border),
      ),
    );

    if (effectiveLabel == null && effectiveCaption == null) {
      return inputField;
    }

    final labelWidget = effectiveLabel == null
        ? null
        : AppText(
            effectiveLabel,
            preset: AppTextPreset.bodyMedium,
            color: colors.label,
          );

    final captionWidget = effectiveCaption == null
        ? null
        : AppText(
            effectiveCaption,
            preset: AppTextPreset.bodySmall,
            color: stateColors.caption,
          );

    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      mainAxisSize: m.MainAxisSize.min,
      children: [
        if (labelWidget case final widget?) ...[
          widget,
          const m.SizedBox(height: 12),
        ],
        inputField,
        if (captionWidget case final widget?) ...[
          const m.SizedBox(height: 12),
          widget,
        ],
      ],
    );
  }
}
