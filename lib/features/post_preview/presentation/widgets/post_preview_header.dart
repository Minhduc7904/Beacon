import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'post_preview_download_button.dart';

class PostPreviewHeader extends StatelessWidget {
  const PostPreviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        const PostPreviewDownloadButton(),
      ],
    );
  }
}
