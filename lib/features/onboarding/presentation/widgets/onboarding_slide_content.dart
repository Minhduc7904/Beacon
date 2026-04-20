import 'package:flutter/material.dart';

import '../../../../core/widgets/image/image.dart';

class OnboardingSlideContent extends StatelessWidget {
  final String imagePath;

  const OnboardingSlideContent({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppImage(image: AssetImage(imagePath), fit: BoxFit.contain),
    );
  }
}
