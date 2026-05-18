import 'package:flutter/material.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import 'post_location_map_dialog.dart';

class PostLocationMapButton extends StatelessWidget {
  const PostLocationMapButton({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.displayName,
    required this.avatarUrl,
    this.semanticLabel = 'Xem vị trí',
  });

  final double latitude;
  final double longitude;
  final String displayName;
  final String? avatarUrl;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.42),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => _showLocationDialog(context),
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
          child: AppIcon(
            AppIcons.mapPin,
            size: 20,
            color: AppColors.sky100,
            semanticLabel: semanticLabel,
          ),
        ),
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => PostLocationMapDialog(
        latitude: latitude,
        longitude: longitude,
        displayName: displayName,
        avatarUrl: avatarUrl,
      ),
    );
  }
}
