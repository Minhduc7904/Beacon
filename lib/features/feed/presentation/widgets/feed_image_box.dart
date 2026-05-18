import 'package:flutter/material.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../posts/presentation/widgets/post_location_map_dialog.dart';
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
    final hasLocation = post.latitude != null && post.longitude != null;

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
          if (post.hasDailySafetyRecord)
            Positioned(top: 14, left: 14, child: _CheckedInBadge()),
          if (hasLocation)
            Positioned(
              top: 14,
              right: 14,
              child: _PostMapButton(
                onPressed: () => _showLocationDialog(context),
              ),
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

  void _showLocationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => PostLocationMapDialog(
        latitude: post.latitude!,
        longitude: post.longitude!,
        displayName: post.authorName,
        avatarUrl: post.authorAvatarUrl,
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

class _PostMapButton extends StatelessWidget {
  const _PostMapButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.42),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.24),
              width: 1,
            ),
          ),
          child: const AppIcon(
            AppIcons.mapPin,
            size: 20,
            color: AppColors.sky100,
            semanticLabel: 'Xem vị trí',
          ),
        ),
      ),
    );
  }
}

class _CheckedInBadge extends StatelessWidget {
  const _CheckedInBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.42),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.24),
          width: 1,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: AppIcon(
          AppIcons.shieldPhosphor,
          size: 20,
          color: AppColors.success,
          semanticLabel: 'Đã check-in',
        ),
      ),
    );
  }
}
