import 'package:flutter/material.dart';

import '../../../../core/widgets/text/text.dart';

class OnboardingContentSection extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingContentSection({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          title,
          preset: AppTextPreset.title3,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        AppText(
          description,
          preset: AppTextPreset.bodyLarge,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.65),
        ),
      ],
    );
  }
}
