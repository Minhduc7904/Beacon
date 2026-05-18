import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/layout/screen_layout.dart';
import '../controllers/post_preview_image_path_provider.dart';
import '../widgets/post_preview_close_button.dart';
import '../widgets/post_preview_caption_input.dart';
import '../widgets/post_preview_header.dart';
import '../widgets/post_preview_image_box.dart';
import '../widgets/post_preview_send_button.dart';
import '../widgets/post_preview_status_message.dart';

class PostPreviewPage extends ConsumerStatefulWidget {
  const PostPreviewPage({super.key, required this.filePath});

  final String filePath;

  @override
  ConsumerState<PostPreviewPage> createState() => _PostPreviewPageState();
}

class _PostPreviewPageState extends ConsumerState<PostPreviewPage> {
  late final TextEditingController _captionController;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        postPreviewImagePathProvider.overrideWithValue(widget.filePath),
      ],
      child: Scaffold(
        body: SafeArea(
          child: AppScreenLayout(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        const PostPreviewHeader(),
                        const SizedBox(height: 20),
                        const PostPreviewImageBox(),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: PostPreviewCaptionInput(
                            controller: _captionController,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                PostPreviewSendButton(
                                  captionController: _captionController,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const PostPreviewStatusMessage(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
