import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';

class HomeStreakChip extends StatelessWidget {
  const HomeStreakChip({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.coral400,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFFC6311),
            size: 28,
          ),
          const SizedBox(width: 8),
          AppText(
            '$days ngày',
            size: AppTextSize.regular,
            spacing: AppTextSpacing.none,
            weight: AppTextWeight.bold,
            color: AppColors.sky100,
          ),
        ],
      ),
    );
  }
}
