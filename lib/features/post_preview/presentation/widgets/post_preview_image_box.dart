import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../controllers/post_preview_image_path_provider.dart';

class PostPreviewImageBox extends ConsumerWidget {
  const PostPreviewImageBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filePath = ref.watch(postPreviewImagePathProvider);
    final imageBoxHeight = _imageBoxHeight(context);

    return Container(
      width: double.infinity,
      height: imageBoxHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
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
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: AppColors.sky400, width: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _imageBoxHeight(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width - 40).clamp(240.0, 420.0);
  }
}
