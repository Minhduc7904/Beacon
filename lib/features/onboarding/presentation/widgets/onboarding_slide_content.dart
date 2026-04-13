import 'package:flutter/material.dart';

import '../../../../core/widgets/image/image.dart';
import '../../../../core/widgets/text/text.dart';

class OnboardingSlideContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingSlideContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: AppImage(image: AssetImage(imagePath), fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 26),
        AppText(
          title,
          preset: AppTextPreset.title3,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        AppText(
          description,
          preset: AppTextPreset.bodyMedium,
          textAlign: TextAlign.center,
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.65),
        ),
      ],
    );
  }
}
