import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/text/text.dart';
import '../controllers/feed_state.dart';

class FeedStatusPage extends StatelessWidget {
  const FeedStatusPage({super.key, required this.state, required this.onRetry});

  final FeedState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading =
        state.status == FeedStatus.initial ||
        state.status == FeedStatus.loading;
    final title = switch (state.status) {
      FeedStatus.error => 'Không thể tải feed',
      FeedStatus.loaded => 'Chưa có bài đăng',
      FeedStatus.initial || FeedStatus.loading => 'Đang tải feed',
    };
    final message = switch (state.status) {
      FeedStatus.error => state.errorMessage ?? 'Vui lòng thử lại sau ít phút',
      FeedStatus.loaded => 'Bài đăng của bạn và bạn bè sẽ xuất hiện ở đây',
      FeedStatus.initial || FeedStatus.loading => 'Đang lấy bài mới nhất',
    };

    return AppScreenLayout(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              AppLoadingIndicator(
                color: colorScheme.primary,
                size: 28,
                strokeWidth: 2.4,
              ),
              const SizedBox(height: 18),
            ],
            AppText(
              title,
              size: AppTextSize.regular,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              message,
              size: AppTextSize.small,
              spacing: AppTextSpacing.normal,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.64),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (state.status == FeedStatus.error) ...[
              const SizedBox(height: 20),
              Button(
                text: 'Thử lại',
                type: ButtonType.outline,
                size: ButtonSize.large,
                w: 160,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
