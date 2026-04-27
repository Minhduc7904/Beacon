import 'package:flutter/material.dart';

import '../text/text.dart';

class AppSwitchButton extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const AppSwitchButton({
    super.key,
    required this.label,
    this.description,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveOnChanged = enabled ? onChanged : null;

    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    label,
                    preset: AppTextPreset.bodyMedium,
                    color: colorScheme.onSurface,
                  ),
                  if (description != null && description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    AppText(
                      description!.trim(),
                      preset: AppTextPreset.bodySmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch.adaptive(
              value: value,
              onChanged: effectiveOnChanged,
              activeColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
