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
          ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                final isIncoming = child.key == ValueKey<int>(days);
                final beginOffset = isIncoming
                    ? const Offset(0, 0.6)
                    : const Offset(0, -0.6);

                return SlideTransition(
                  position: animation.drive(
                    Tween(begin: beginOffset, end: Offset.zero),
                  ),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: AppText(
                '$days ngày',
                key: ValueKey<int>(days),
                size: AppTextSize.regular,
                spacing: AppTextSpacing.none,
                weight: AppTextWeight.bold,
                color: AppColors.sky100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
