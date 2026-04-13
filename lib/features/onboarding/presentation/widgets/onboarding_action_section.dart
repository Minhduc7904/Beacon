import 'package:flutter/material.dart';

import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/text/text.dart';

class OnboardingActionSection extends StatelessWidget {
  final bool isLoading;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  const OnboardingActionSection({
    super.key,
    required this.isLoading,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Button(
          text: isLoading ? 'Đang xử lý...' : primaryLabel,
          state: isLoading ? ButtonState.disabled : ButtonState.defaultState,
          onPressed: () {
            if (!isLoading) {
              onPrimaryPressed();
            }
          },
        ),
        const SizedBox(height: 18),
        Center(
          child: TextButton(
            onPressed: () {
              if (!isLoading) {
                onSecondaryPressed();
              }
            },
            child: AppText(
              secondaryLabel,
              preset: AppTextPreset.bodyMedium,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
