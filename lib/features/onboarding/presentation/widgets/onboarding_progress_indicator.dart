import 'package:flutter/material.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const OnboardingProgressIndicator({
    super.key,
    required this.currentIndex,
    this.total = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == currentIndex;

        return Padding(
          padding: EdgeInsets.only(right: index == total - 1 ? 0 : 8),
          child: Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.4),
            ),
          ),
        );
      }),
    );
  }
}
