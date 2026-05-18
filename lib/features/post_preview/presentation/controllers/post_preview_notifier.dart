import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/messages/app_message_notifier.dart';
import '../../../posts/domain/entities/post_visibility.dart';
import '../../../posts/domain/usecase/create_post_usecase.dart';
import '../../domain/usecase/upload_post_media_usecase.dart';
import 'post_preview_state.dart';

class PostPreviewNotifier extends StateNotifier<PostPreviewState> {
  final UploadPostMediaUseCase _uploadPostMediaUseCase;
  final CreatePostUseCase _createPostUseCase;
  final AppMessageNotifier _messageNotifier;

  PostPreviewNotifier(
    this._uploadPostMediaUseCase,
    this._createPostUseCase,
    this._messageNotifier,
  ) : super(const PostPreviewState.initial());

  Future<void> postMedia(
    String filePath, {
    String? caption,
    PostVisibility visibility = PostVisibility.friends,
    double? latitude,
    double? longitude,
  }) async {
    final trimmedPath = filePath.trim();
    if (state.isUploading || trimmedPath.isEmpty) {
      return;
    }

    final normalizedCaption = caption?.trim();
    if (normalizedCaption != null && normalizedCaption.length > 2000) {
      _messageNotifier.addError(ErrorMessages.postCaptionTooLong);
      state = state.copyWith(
        errorMessage: ErrorMessages.postCaptionTooLong,
        clearCreatedPost: true,
      );
      return;
    }

    state = state.copyWith(
      isUploading: true,
      clearErrorMessage: true,
      clearCreatedPost: true,
    );

    var media = state.uploadedMediaFilePath == trimmedPath
        ? state.uploadedMedia
        : null;
    if (media == null) {
      final uploadResult = await _uploadPostMediaUseCase(
        UploadPostMediaParams(filePath: trimmedPath),
      );

      final uploadFailed = uploadResult.fold(
        (failure) {
          _messageNotifier.addError(failure.message);
          state = state.copyWith(
            isUploading: false,
            errorMessage: failure.message,
            clearUploadedMedia: true,
          );
          return true;
        },
        (uploadedMedia) {
          media = uploadedMedia;
          state = state.copyWith(
            uploadedMedia: uploadedMedia,
            uploadedMediaFilePath: trimmedPath,
            clearErrorMessage: true,
          );
          return false;
        },
      );

      if (uploadFailed || media == null) {
        return;
      }
    }

    final createResult = await _createPostUseCase(
      CreatePostParams(
        mediaId: media!.id,
        caption: normalizedCaption,
        visibility: visibility,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    createResult.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isUploading: false,
          errorMessage: failure.message,
        );
      },
      (post) {
        _messageNotifier.addSuccess('Đăng bài thành công');
        state = state.copyWith(
          isUploading: false,
          createdPost: post,
          clearUploadedMedia: true,
          clearErrorMessage: true,
        );
      },
    );
  }
}
