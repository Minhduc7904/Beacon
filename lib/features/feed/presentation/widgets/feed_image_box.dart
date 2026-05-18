import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/feed_post.dart';
import 'feed_media_radius.dart';

const _feedImageHorizontalInset = 48.0;
const _feedImageMinSize = 240.0;
const _feedImageMaxSize = 360.0;

class FeedImageBox extends StatelessWidget {
  const FeedImageBox({super.key, required this.post});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    final imageBoxSize = _imageBoxSize(context);
    final imageBorderRadius = feedMediaBorderRadiusForSize(
      context,
      imageBoxSize,
    );
    final caption = post.caption?.trim() ?? '';

    return Container(
      width: imageBoxSize,
      height: imageBoxSize,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(imageBorderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                  color: Colors.white54,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text(
                  'Không thể tải ảnh',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            },
          ),
          if (caption.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AppText(
                    caption,
                    size: AppTextSize.small,
                    spacing: AppTextSpacing.normal,
                    weight: AppTextWeight.medium,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _imageBoxSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width - _feedImageHorizontalInset).clamp(
      _feedImageMinSize,
      _feedImageMaxSize,
    );
  }
}
