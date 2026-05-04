import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/layout/screen_layout.dart';
import '../controllers/post_preview_image_path_provider.dart';
import '../widgets/post_preview_close_button.dart';
import '../widgets/post_preview_header.dart';
import '../widgets/post_preview_image_box.dart';
import '../widgets/post_preview_send_button.dart';
import '../widgets/post_preview_status_message.dart';

class PostPreviewPage extends ConsumerWidget {
  const PostPreviewPage({super.key, required this.filePath});

  final String filePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [postPreviewImagePathProvider.overrideWithValue(filePath)],
      child: Scaffold(
        body: SafeArea(
          child: AppScreenLayout(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const PostPreviewHeader(),
                const Spacer(),
                const PostPreviewImageBox(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned(
                          left: 0,
                          child: PostPreviewCloseButton(),
                        ),
                        const PostPreviewSendButton(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const PostPreviewStatusMessage(),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
