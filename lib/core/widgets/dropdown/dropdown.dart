import 'package:flutter/material.dart' as m;

import '../../theme/app_colors.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.leading,
  });

  final T value;
  final String label;
  final m.Widget? leading;
}

class AppDropdown<T> extends m.StatelessWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<AppDropdownItem<T>> items;
  final m.ValueChanged<T?>? onChanged;
  final bool enabled;
  final m.FormFieldValidator<T>? validator;
  final bool isExpanded;
  final m.Widget? prefixIcon;
  final m.EdgeInsetsGeometry contentPadding;

  const AppDropdown({
    super.key,
    this.labelText,
    this.hintText,
    required this.value,
    required this.items,
    this.onChanged,
    this.enabled = true,
    this.validator,
    this.isExpanded = true,
    this.prefixIcon,
    this.contentPadding = const m.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  @override
  m.Widget build(m.BuildContext context) {
    final theme = m.Theme.of(context);
    final colorScheme = theme.colorScheme;
    final enabledBorderColor = AppColors.outline;
    final focusedBorderColor = colorScheme.primary;
    final disabledFillColor = AppColors.sky300;
    final fillColor = enabled ? AppColors.surface : disabledFillColor;
    final effectiveTextColor = enabled ? AppColors.onSurface : AppColors.ink100;
    final effectiveHintColor = AppColors.sky600;

    return m.DropdownButtonFormField<T>(
      value: value,
      validator: validator,
      isExpanded: isExpanded,
      icon: m.Icon(
        m.Icons.keyboard_arrow_down_rounded,
        color: enabled ? AppColors.ink300 : AppColors.ink100,
      ),
      dropdownColor: AppColors.surface,
      borderRadius: m.BorderRadius.circular(12),
      onChanged: enabled ? onChanged : null,
      decoration: m.InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: fillColor,
        contentPadding: contentPadding,
        enabledBorder: m.OutlineInputBorder(
          borderRadius: m.BorderRadius.circular(12),
          borderSide: m.BorderSide(color: enabledBorderColor),
        ),
        disabledBorder: m.OutlineInputBorder(
          borderRadius: m.BorderRadius.circular(12),
          borderSide: m.BorderSide(color: enabledBorderColor),
        ),
        focusedBorder: m.OutlineInputBorder(
          borderRadius: m.BorderRadius.circular(12),
          borderSide: m.BorderSide(color: focusedBorderColor, width: 1.5),
        ),
        border: m.OutlineInputBorder(
          borderRadius: m.BorderRadius.circular(12),
          borderSide: m.BorderSide(color: enabledBorderColor),
        ),
      ),
      items: items
          .map(
            (item) => m.DropdownMenuItem<T>(
              value: item.value,
              child: m.Row(
                mainAxisSize: m.MainAxisSize.min,
                children: [
                  if (item.leading != null) ...[
                    item.leading!,
                    const m.SizedBox(width: 12),
                  ],
                  m.Text(
                    item.label,
                    overflow: m.TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: effectiveTextColor,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      hint: m.Text(
        hintText ?? '',
        overflow: m.TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: effectiveHintColor,
        ),
      ),
    );
  }
}
