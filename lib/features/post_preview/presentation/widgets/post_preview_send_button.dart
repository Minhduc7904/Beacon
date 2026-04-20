import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/widgets/dev/test/test_post_media_send_signal_provider.dart';
import '../controllers/post_preview_image_path_provider.dart';

class PostPreviewSendButton extends ConsumerStatefulWidget {
  const PostPreviewSendButton({super.key});

  @override
  ConsumerState<PostPreviewSendButton> createState() =>
      _PostPreviewSendButtonState();
}

class _PostPreviewSendButtonState extends ConsumerState<PostPreviewSendButton> {
  int _lastHandledSendSignal = -1;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postPreviewNotifierProvider);
    final notifier = ref.read(postPreviewNotifierProvider.notifier);
    final filePath = ref.watch(postPreviewImagePathProvider);
    final sendSignal = ref.watch(testPostMediaSendSignalProvider);

    if (_lastHandledSendSignal == -1) {
      _lastHandledSendSignal = sendSignal;
    } else if (sendSignal != _lastHandledSendSignal) {
      _lastHandledSendSignal = sendSignal;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        final latestState = ref.read(postPreviewNotifierProvider);
        if (latestState.isUploading) {
          return;
        }

        ref.read(postPreviewNotifierProvider.notifier).postMedia(filePath);
      });
    }

    ref.listen(postPreviewNotifierProvider, (previous, next) {
      if (previous?.uploadedMedia == null && next.uploadedMedia != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.pop(true);
          }
        });
      }
    });

    final canTap = !state.isUploading;

    return InkWell(
      onTap: canTap ? () => notifier.postMedia(filePath) : null,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: canTap ? AppColors.coral500 : AppColors.coral200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.send_rounded,
              color: canTap ? AppColors.sky100 : AppColors.sky400,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
