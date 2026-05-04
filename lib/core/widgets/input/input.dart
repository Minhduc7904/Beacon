import 'package:beacon_app/core/theme/text/app_text_theme.dart';
import 'package:flutter/material.dart' as m;

import '../../constants/app_images.dart';
import '../../theme/color/app_colors.dart';
import '../../theme/input/input_theme.dart';
import '../image/svg_image.dart';
import '../text/text.dart';
import '../widget_mode_resolver.dart';

enum InputMode { light, dark }

enum InputType { text, leftIcon, dropdown }

enum InputState { defaultState, focused, filled, error, disabled }

class Input extends m.StatelessWidget {
  final double height;
  final String? label;
  final String? labelText;
  final String? caption;
  final String? rightCaption;
  final String? hintText;
  final m.Widget? labelRightIcon;
  final m.Widget? leftIcon;
  final m.Widget? rightIcon;
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
    this.rightCaption,
    this.hintText,
    this.labelRightIcon,
    this.leftIcon,
    this.rightIcon,
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

  InputColors _resolveColors(m.BuildContext context) {
    final resolvedMode = _resolveMode(context);
    return resolvedMode == InputMode.dark
        ? InputThemePalette.dark
        : InputThemePalette.light;
  }

  InputStateColors _colorsByState(InputColors colors, InputState state) {
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

  m.Widget? _resolveRightIcon() {
    if (rightIcon != null) {
      return rightIcon;
    }

    if (type != InputType.dropdown) {
      return null;
    }

    return const AppSvgImage(
      assetPath: AppImages.icChervDown,
      width: 24,
      height: 24,
    );
  }

  m.Widget? _buildSuffixIcon(m.Widget? resolvedRightIcon) {
    if (resolvedRightIcon == null) {
      return null;
    }

    return m.Padding(
      // Keep clear spacing between input text/placeholder, icon, and right edge.
      padding: const m.EdgeInsetsDirectional.only(start: 16, end: 16),
      child: resolvedRightIcon,
    );
  }

  m.EdgeInsetsGeometry _contentPaddingByType({required bool hasRightIcon}) {
    return switch (type) {
      InputType.text => const m.EdgeInsets.symmetric(horizontal: 16),
      InputType.leftIcon => const m.EdgeInsets.only(right: 16),
      InputType.dropdown => m.EdgeInsets.only(
        left: 16,
        right: hasRightIcon ? 16 : 0,
      ),
    };
  }

  @override
  m.Widget build(m.BuildContext context) {
    final isDisabled = !enabled || state == InputState.disabled;
    final effectiveState = isDisabled ? InputState.disabled : state;
    final colors = _resolveColors(context);
    final stateColors = _colorsByState(colors, effectiveState);
    final resolvedRightIcon = _resolveRightIcon();
    final hasRightIcon = resolvedRightIcon != null;
    final effectiveLabelRaw = label ?? labelText;
    final effectiveLabel =
        (effectiveLabelRaw == null || effectiveLabelRaw.trim().isEmpty)
        ? null
        : effectiveLabelRaw;
    final effectiveCaption = (caption == null || caption!.trim().isEmpty)
        ? null
        : caption!.trim();
    final effectiveRightCaption =
        (rightCaption == null || rightCaption!.trim().isEmpty)
        ? null
        : rightCaption!.trim();

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
        contentPadding: _contentPaddingByType(hasRightIcon: hasRightIcon),
        prefixIcon: _buildPrefixIcon(),
        prefixIconConstraints: type == InputType.leftIcon
            ? const m.BoxConstraints(minWidth: 48, minHeight: 24)
            : null,
        suffixIcon: _buildSuffixIcon(resolvedRightIcon),
        suffixIconConstraints: hasRightIcon
            ? const m.BoxConstraints(minWidth: 56, minHeight: 24)
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
        : m.Row(
            children: [
              m.Expanded(
                child: AppText(
                  effectiveLabel,
                  color: colors.label,
                  size: AppTextSize.regular,
                  spacing: AppTextSpacing.none,
                  weight: AppTextWeight.bold,
                ),
              ),
              ?labelRightIcon,
            ],
          );

    final captionWidget =
        (effectiveRightCaption == null && effectiveCaption == null)
        ? null
        : m.Row(
            children: [
              if (effectiveCaption != null)
                AppText(
                  effectiveCaption,
                  preset: AppTextPreset.bodySmall,
                  color: stateColors.caption,
                  textAlign: m.TextAlign.right,
                ),
              const m.Spacer(),
              if (effectiveRightCaption != null)
                AppText(
                  effectiveRightCaption,
                  color: AppColors.ink100,
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.none,
                  weight: AppTextWeight.regular,
                ),
            ],
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
