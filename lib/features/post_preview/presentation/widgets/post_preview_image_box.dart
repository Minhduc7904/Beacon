import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/post_preview_image_path_provider.dart';

class PostPreviewImageBox extends ConsumerWidget {
  const PostPreviewImageBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filePath = ref.watch(postPreviewImagePathProvider);
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
      child: Image.file(
        File(filePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text(
              'Không thể tải ảnh xem trước',
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
