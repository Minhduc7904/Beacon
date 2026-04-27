import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';

/// Empty state illustration for the conversation list.
class ConversationEmptyState extends StatelessWidget {
  const ConversationEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.6),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 36,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            AppText(
              'Chưa có tin nhắn',
              size: AppTextSize.large,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              'Khi bạn bắt đầu trò chuyện,\ntin nhắn sẽ xuất hiện ở đây.',
              size: AppTextSize.small,
              spacing: AppTextSpacing.normal,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
