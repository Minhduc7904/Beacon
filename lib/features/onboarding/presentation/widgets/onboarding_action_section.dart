import 'package:flutter/material.dart';

import '../../../../core/widgets/button/button.dart';

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
          text: primaryLabel,
          isLoading: isLoading,
          loadingText: 'Đang xử lý...',
          onPressed: () {
            if (!isLoading) {
              onPrimaryPressed();
            }
          },
        ),
        const SizedBox(height: 12),
        Button(
          text: secondaryLabel,
          type: ButtonType.transparent,
          state: isLoading ? ButtonState.disabled : ButtonState.defaultState,
          onPressed: () {
            if (!isLoading) {
              onSecondaryPressed();
            }
          },
        ),
      ],
    );
  }
}
