import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/usecase/upload_post_media_usecase.dart';
import 'post_preview_state.dart';

class PostPreviewNotifier extends StateNotifier<PostPreviewState> {
  final UploadPostMediaUseCase _uploadPostMediaUseCase;
  final AppMessageNotifier _messageNotifier;

  PostPreviewNotifier(this._uploadPostMediaUseCase, this._messageNotifier)
    : super(const PostPreviewState.initial());

  Future<void> postMedia(String filePath) async {
    final trimmedPath = filePath.trim();
    if (state.isUploading || trimmedPath.isEmpty) {
      return;
    }

    state = state.copyWith(
      isUploading: true,
      clearErrorMessage: true,
      clearUploadedMedia: true,
    );

    final result = await _uploadPostMediaUseCase(
      UploadPostMediaParams(filePath: trimmedPath),
    );

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isUploading: false,
          errorMessage: failure.message,
          clearUploadedMedia: true,
        );
      },
      (media) {
        _messageNotifier.addSuccess('Đăng ảnh thành công');
        state = state.copyWith(
          isUploading: false,
          uploadedMedia: media,
          clearErrorMessage: true,
        );
      },
    );
  }
}
