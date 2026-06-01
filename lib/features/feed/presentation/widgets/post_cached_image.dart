import 'dart:io';

import 'package:flutter/material.dart';

class PostCachedImage extends StatelessWidget {
  const PostCachedImage({
    super.key,
    required this.localThumbnailPath,
    required this.localImagePath,
    required this.remoteThumbnailUrl,
    required this.remoteImageUrl,
    this.fit = BoxFit.cover,
    required this.loadingBuilder,
    required this.errorBuilder,
  });

  final String? localThumbnailPath;
  final String? localImagePath;
  final String? remoteThumbnailUrl;
  final String? remoteImageUrl;
  final BoxFit fit;
  final WidgetBuilder loadingBuilder;
  final WidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    final localPath = _firstExistingPath([
      localThumbnailPath,
      localImagePath,
    ]);
    if (localPath != null) {
      return Image.file(
        File(localPath),
        key: ValueKey<String>('local:$localPath'),
        fit: fit,
        errorBuilder: (_, __, ___) => _networkOrError(context),
      );
    }

    return _networkOrError(context);
  }

  Widget _networkOrError(BuildContext context) {
    final remoteUrl = _firstNonEmpty([remoteThumbnailUrl, remoteImageUrl]);
    if (remoteUrl == null) {
      return errorBuilder(context);
    }

    return Image.network(
      remoteUrl,
      key: ValueKey<String>('remote:$remoteUrl'),
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return loadingBuilder(context);
      },
      errorBuilder: (context, error, stackTrace) => errorBuilder(context),
    );
  }

  String? _firstExistingPath(List<String?> paths) {
    for (final path in paths) {
      final normalized = path?.trim();
      if (normalized == null || normalized.isEmpty) {
        continue;
      }

      try {
        if (File(normalized).existsSync()) {
          return normalized;
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final normalized = value?.trim();
      if (normalized != null && normalized.isNotEmpty) {
        return normalized;
      }
    }
    return null;
  }
}
