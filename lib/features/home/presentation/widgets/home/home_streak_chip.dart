import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';

class HomeStreakChip extends StatelessWidget {
  const HomeStreakChip({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: colorScheme.onSecondary,
            size: 18,
          ),
          const SizedBox(width: 6),
          AppText(
            '$days ngày',
            size: AppTextSize.tiny,
            spacing: AppTextSpacing.tight,
            weight: AppTextWeight.bold,
            color: colorScheme.onSecondary,
          ),
        ],
      ),
    );
  }
}
