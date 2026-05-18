import 'package:flutter/material.dart';

import '../../domain/entities/feed_post.dart';

/// Displays the feed post image in a square box with rounded corners,
/// matching the PostPreviewImageBox style from the post_preview feature.
class FeedImageBox extends StatelessWidget {
  const FeedImageBox({super.key, required this.post});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    final imageBoxSize = _imageBoxSize(context);

    return Container(
      width: imageBoxSize,
      height: imageBoxSize,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
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
      child: Image.network(
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
    );
  }

  double _imageBoxSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width - 48).clamp(240.0, 360.0);
  }
}
