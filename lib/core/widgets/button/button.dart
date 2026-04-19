import 'package:flutter/material.dart' as m;

import '../../theme/app_colors.dart';
import '../widget_mode_resolver.dart';
import '../text/text.dart';

enum ButtonMode { light, dark }

enum ButtonSize { block, large, small }

enum ButtonType { primary, secondary, outline, transparent }

enum ButtonState { defaultState, pressed, disabled }

enum ButtonIconPosition { side, left, right }

class _ButtonColors {
  const _ButtonColors({
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

  final m.Color background;
  final m.Color pressedBackground;
  final m.Color disabledBackground;
  final m.Color foregroundDefault;
  final m.Color foregroundPressed;
  final m.Color foregroundDisabled;
  final m.Color borderColorDefault;
  final m.Color borderColorPressed;
  final m.Color borderColorDisabled;
}

class Button extends m.StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final ButtonMode? mode;
  final ButtonSize size;
  final ButtonType type;
  final ButtonState state;
  final bool hasIcon;
  final m.Widget? icon;
  final ButtonIconPosition iconPosition;
  final double? w;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.mode,
    this.size = ButtonSize.block,
    this.type = ButtonType.primary,
    this.state = ButtonState.defaultState,
    this.hasIcon = false,
    this.icon,
    this.iconPosition = ButtonIconPosition.side,
    this.w,
  });

  m.Widget get _effectiveIcon {
    return icon ??
        m.Container(
          width: 16,
          height: 16,
          clipBehavior: m.Clip.antiAlias,
          decoration: m.BoxDecoration(shape: m.BoxShape.circle),
          child: m.Stack(),
        );
  }

  ButtonMode _resolveMode(m.BuildContext context) {
    return resolveWidgetMode<ButtonMode>(
      context: context,
      mode: mode,
      lightMode: ButtonMode.light,
      darkMode: ButtonMode.dark,
    );
  }

  _ButtonColors _resolveColors(m.BuildContext context) {
    final resolvedMode = _resolveMode(context);

    if (resolvedMode == ButtonMode.dark) {
      return switch (type) {
        ButtonType.primary => const _ButtonColors(
          background: AppColors.teal400,
          pressedBackground: AppColors.teal500,
          disabledBackground: AppColors.sky400,
          foregroundDefault: AppColors.sky100,
          foregroundPressed: AppColors.sky100,
          foregroundDisabled: AppColors.sky600,
          borderColorDefault: AppColors.teal400,
          borderColorPressed: AppColors.teal500,
          borderColorDisabled: AppColors.sky400,
        ),
        ButtonType.secondary => const _ButtonColors(
          background: AppColors.teal100,
          pressedBackground: AppColors.teal200,
          disabledBackground: AppColors.sky400,
          foregroundDefault: AppColors.teal400,
          foregroundPressed: AppColors.teal500,
          foregroundDisabled: AppColors.sky600,
          borderColorDefault: AppColors.teal100,
          borderColorPressed: AppColors.teal200,
          borderColorDisabled: AppColors.sky400,
        ),
        ButtonType.outline => const _ButtonColors(
          background: AppColors.sky100,
          pressedBackground: AppColors.sky100,
          disabledBackground: AppColors.sky100,
          foregroundDefault: AppColors.teal400,
          foregroundPressed: AppColors.teal500,
          foregroundDisabled: AppColors.sky500,
          borderColorDefault: AppColors.teal400,
          borderColorPressed: AppColors.teal500,
          borderColorDisabled: AppColors.sky500,
        ),
        ButtonType.transparent => const _ButtonColors(
          background: AppColors.sky100,
          pressedBackground: AppColors.teal100,
          disabledBackground: AppColors.sky100,
          foregroundDefault: AppColors.teal400,
          foregroundPressed: AppColors.teal400,
          foregroundDisabled: AppColors.teal400,
          borderColorDefault: AppColors.sky100,
          borderColorPressed: AppColors.teal100,
          borderColorDisabled: AppColors.sky100,
        ),
      };
    }

    return switch (type) {
      ButtonType.primary => const _ButtonColors(
        background: AppColors.teal400,
        pressedBackground: AppColors.teal500,
        disabledBackground: AppColors.sky400,
        foregroundDefault: AppColors.sky100,
        foregroundPressed: AppColors.sky100,
        foregroundDisabled: AppColors.sky600,
        borderColorDefault: AppColors.teal400,
        borderColorPressed: AppColors.teal500,
        borderColorDisabled: AppColors.sky400,
      ),
      ButtonType.secondary => const _ButtonColors(
        background: AppColors.teal100,
        pressedBackground: AppColors.teal200,
        disabledBackground: AppColors.sky400,
        foregroundDefault: AppColors.teal400,
        foregroundPressed: AppColors.teal500,
        foregroundDisabled: AppColors.sky600,
        borderColorDefault: AppColors.teal100,
        borderColorPressed: AppColors.teal200,
        borderColorDisabled: AppColors.sky400,
      ),
      ButtonType.outline => const _ButtonColors(
        background: AppColors.sky100,
        pressedBackground: AppColors.sky100,
        disabledBackground: AppColors.sky100,
        foregroundDefault: AppColors.teal400,
        foregroundPressed: AppColors.teal500,
        foregroundDisabled: AppColors.sky500,
        borderColorDefault: AppColors.teal400,
        borderColorPressed: AppColors.teal500,
        borderColorDisabled: AppColors.sky500,
      ),
      ButtonType.transparent => const _ButtonColors(
        background: AppColors.sky100,
        pressedBackground: AppColors.teal100,
        disabledBackground: AppColors.sky100,
        foregroundDefault: AppColors.teal400,
        foregroundPressed: AppColors.teal400,
        foregroundDisabled: AppColors.teal400,
        borderColorDefault: AppColors.sky100,
        borderColorPressed: AppColors.teal100,
        borderColorDisabled: AppColors.sky100,
      ),
    };
  }

  m.ButtonStyle _buildStyle(m.BuildContext context) {
    final colors = _resolveColors(context);
    final isDisabled = state == ButtonState.disabled;
    final isPressed = state == ButtonState.pressed;

    final m.EdgeInsetsGeometry padding = switch (size) {
      ButtonSize.block => const m.EdgeInsets.symmetric(vertical: 24),
      ButtonSize.large => const m.EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 32,
      ),
      ButtonSize.small => const m.EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
    };

    final m.BorderSide borderSide = switch (type) {
      ButtonType.outline => m.BorderSide(
        color: isDisabled
            ? colors.borderColorDisabled
            : isPressed
            ? colors.borderColorPressed
            : colors.borderColorDefault,
        width: 1,
      ),
      ButtonType.transparent => m.BorderSide.none,
      ButtonType.primary => m.BorderSide.none,
      ButtonType.secondary => m.BorderSide.none,
    };

    m.Color resolveBackground(Set<m.WidgetState> states) {
      if (isDisabled || states.contains(m.WidgetState.disabled)) {
        return colors.disabledBackground;
      }

      if (isPressed || states.contains(m.WidgetState.pressed)) {
        return colors.pressedBackground;
      }

      return colors.background;
    }

    m.Color resolveForeground(Set<m.WidgetState> states) {
      if (isDisabled || states.contains(m.WidgetState.disabled)) {
        return colors.foregroundDisabled;
      }

      if (isPressed || states.contains(m.WidgetState.pressed)) {
        return colors.foregroundPressed;
      }

      return colors.foregroundDefault;
    }

    return m.ButtonStyle(
      backgroundColor: m.WidgetStateProperty.resolveWith(resolveBackground),
      foregroundColor: m.WidgetStateProperty.resolveWith(resolveForeground),
      overlayColor: m.WidgetStateProperty.resolveWith((states) {
        if (states.contains(m.WidgetState.pressed)) {
          return m.Colors.transparent;
        }

        return m.Colors.transparent;
      }),
      shadowColor: const m.WidgetStatePropertyAll(m.Colors.transparent),
      surfaceTintColor: const m.WidgetStatePropertyAll(m.Colors.transparent),
      padding: m.WidgetStatePropertyAll(padding),
      minimumSize: const m.WidgetStatePropertyAll(m.Size(0, 0)),
      tapTargetSize: m.MaterialTapTargetSize.shrinkWrap,
      shape: m.WidgetStatePropertyAll(
        m.RoundedRectangleBorder(borderRadius: m.BorderRadius.circular(999)),
      ),
      side: m.WidgetStateProperty.resolveWith((states) {
        if (type == ButtonType.outline) {
          return borderSide;
        }

        return m.BorderSide.none;
      }),
    );
  }

  m.Widget _buildButtonContent(m.BuildContext context) {
    final colors = _resolveColors(context);
    final textColor = switch (state) {
      ButtonState.disabled => colors.foregroundDisabled,
      ButtonState.pressed => colors.foregroundPressed,
      ButtonState.defaultState => colors.foregroundDefault,
    };

    final textWidget = AppText(
      text,
      textAlign: m.TextAlign.center,
      color: textColor,
      fontWeight: m.FontWeight.w500,
      style: const m.TextStyle(fontSize: 16, fontFamily: 'Inter', height: 1),
    );

    if (!hasIcon) {
      return textWidget;
    }

    final currentIcon = _effectiveIcon;

    final sideGap = size == ButtonSize.small ? 4.0 : 8.0;
    final edgeInset = size == ButtonSize.small ? 8.0 : 16.0;

    if (iconPosition == ButtonIconPosition.side) {
      return m.Row(
        mainAxisSize: m.MainAxisSize.min,
        children: [
          currentIcon,
          m.SizedBox(width: sideGap),
          textWidget,
        ],
      );
    }

    return m.LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) {
          return m.Row(
            mainAxisSize: m.MainAxisSize.min,
            children: iconPosition == ButtonIconPosition.left
                ? [currentIcon, m.SizedBox(width: sideGap), textWidget]
                : [textWidget, m.SizedBox(width: sideGap), currentIcon],
          );
        }

        final iconAlign = iconPosition == ButtonIconPosition.left
            ? m.Alignment.centerLeft
            : m.Alignment.centerRight;

        final iconPadding = iconPosition == ButtonIconPosition.left
            ? m.EdgeInsets.only(left: edgeInset)
            : m.EdgeInsets.only(right: edgeInset);

        return m.SizedBox(
          width: constraints.maxWidth,
          child: m.Stack(
            alignment: m.Alignment.center,
            children: [
              textWidget,
              m.Align(
                alignment: iconAlign,
                child: m.Padding(padding: iconPadding, child: currentIcon),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  m.Widget build(m.BuildContext context) {
    final effectiveOnPressed = state == ButtonState.disabled ? null : onPressed;

    final button = m.FilledButton(
      onPressed: effectiveOnPressed,
      style: _buildStyle(context),
      child: _buildButtonContent(context),
    );

    final resolvedWidth =
        w ?? (size == ButtonSize.block ? double.infinity : null);

    if (resolvedWidth != null) {
      return m.SizedBox(width: resolvedWidth, child: button);
    }

    return button;
  }
}
