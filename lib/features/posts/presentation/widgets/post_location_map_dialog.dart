import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import 'google_maps_button.dart';

class PostLocationMapDialog extends StatelessWidget {
  const PostLocationMapDialog({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.displayName,
    required this.avatarUrl,
  });

  final double latitude;
  final double longitude;
  final String displayName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final location = LatLng(latitude, longitude);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 360,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FlutterMap(
              options: MapOptions(initialCenter: location, initialZoom: 15),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.beacon_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: location,
                      width: 64,
                      height: 72,
                      child: _AvatarMarker(
                        avatarUrl: avatarUrl,
                        displayName: displayName,
                      ),
                    ),
                  ],
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 14,
              top: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.54),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: AppText(
                    displayName,
                    size: AppTextSize.tiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: Colors.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            Positioned(
              right: 14,
              bottom: 14,
              child: GoogleMapsButton(latitude: latitude, longitude: longitude),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarMarker extends StatelessWidget {
  const _AvatarMarker({required this.avatarUrl, required this.displayName});

  final String? avatarUrl;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.sky100, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: UserAvatar(
            avatarUrl: avatarUrl,
            givenName: displayName,
            size: 42,
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.teal500,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
