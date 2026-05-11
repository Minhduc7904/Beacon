import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
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
          icon: const AppIcon(AppIcons.back),
        ),
        const PostPreviewDownloadButton(),
      ],
    );
  }
}
