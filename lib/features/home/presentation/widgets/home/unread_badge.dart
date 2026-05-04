import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';

class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: AppText(
        '$count',
        size: AppTextSize.veryTiny,
        spacing: AppTextSpacing.none,
        weight: AppTextWeight.medium,
        color: colorScheme.onSecondary,
      ),
    );
  }
}
