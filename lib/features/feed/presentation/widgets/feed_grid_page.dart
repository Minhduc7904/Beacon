import 'package:flutter/material.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../domain/entities/feed_post.dart';
import 'feed_media_radius.dart';

class FeedGridPage extends StatelessWidget {
  const FeedGridPage({
    super.key,
    required this.posts,
    required this.isLoadingMore,
    required this.onPostTap,
    required this.onLoadMore,
  });

  final List<FeedPost> posts;
  final bool isLoadingMore;
  final ValueChanged<int> onPostTap;
  final VoidCallback onLoadMore;

  bool _handleScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent - metrics.pixels <= 420) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenLayout(
      padding: const EdgeInsets.only(top: 72, bottom: 20),
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScroll,
        child: Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _FeedGridTile(
                  post: posts[index],
                  onTap: () => onPostTap(index),
                );
              },
            ),
            if (isLoadingMore)
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AppLoadingIndicator(
                        color: colorScheme.primary,
                        size: 18,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeedGridTile extends StatelessWidget {
  const _FeedGridTile({required this.post, required this.onTap});

  final FeedPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileSize = constraints.biggest.shortestSide;
        final tileBorderRadius = feedMediaBorderRadiusForSize(
          context,
          tileSize,
        );

        return Material(
          color: Colors.black,
          borderRadius: BorderRadius.circular(tileBorderRadius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }

                return Center(
                  child: AppLoadingIndicator(
                    color: AppColors.sky100.withValues(alpha: 0.8),
                    size: 18,
                    strokeWidth: 2,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: AppIcon(
                    AppIcons.warning,
                    color: AppColors.sky100.withValues(alpha: 0.72),
                    size: 24,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
