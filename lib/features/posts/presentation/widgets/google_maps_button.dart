import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';

class GoogleMapsButton extends StatefulWidget {
  const GoogleMapsButton({
    super.key,
    required this.latitude,
    required this.longitude,
    this.label = 'Google Maps',
    this.compact = false,
  });

  final double latitude;
  final double longitude;
  final String label;
  final bool compact;

  @override
  State<GoogleMapsButton> createState() => _GoogleMapsButtonState();
}

class _GoogleMapsButtonState extends State<GoogleMapsButton> {
  static const MethodChannel _channel = MethodChannel('beacon/google_maps');

  bool _isOpening = false;

  Future<void> _openGoogleMaps() async {
    if (_isOpening) {
      return;
    }

    setState(() => _isOpening = true);
    try {
      await _channel.invokeMethod<bool>('open', {
        'latitude': widget.latitude,
        'longitude': widget.longitude,
      });
    } on MissingPluginException {
      // Google Maps launching is only wired on Android and iOS.
    } on PlatformException {
      // Keep the map popup usable even if the external app cannot be opened.
    } finally {
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.compact) {
      return IconButton.filledTonal(
        onPressed: _isOpening ? null : _openGoogleMaps,
        tooltip: widget.label,
        icon: _isOpening
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const AppIcon(
                AppIcons.mapPin,
                size: 20,
                semanticLabel: 'Mở Google Maps',
              ),
      );
    }

    return Material(
      color: AppColors.sky100,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: _isOpening ? null : _openGoogleMaps,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isOpening)
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.teal500,
                  ),
                )
              else
                const AppIcon(
                  AppIcons.mapPin,
                  size: 18,
                  color: AppColors.teal500,
                  semanticLabel: 'Mở Google Maps',
                ),
              const SizedBox(width: 8),
              AppText(
                widget.label,
                size: AppTextSize.tiny,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.bold,
                color: AppColors.ink500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
