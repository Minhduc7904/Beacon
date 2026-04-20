import '../../domain/entities/media_upload_result.dart';

class PostPreviewState {
  final bool isUploading;
  final String? errorMessage;
  final MediaUploadResult? uploadedMedia;

  const PostPreviewState({
    required this.isUploading,
    required this.errorMessage,
    required this.uploadedMedia,
  });

  const PostPreviewState.initial()
    : isUploading = false,
      errorMessage = null,
      uploadedMedia = null;

  PostPreviewState copyWith({
    bool? isUploading,
    String? errorMessage,
    bool clearErrorMessage = false,
    MediaUploadResult? uploadedMedia,
    bool clearUploadedMedia = false,
  }) {
    return PostPreviewState(
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      uploadedMedia: clearUploadedMedia
          ? null
          : (uploadedMedia ?? this.uploadedMedia),
    );
  }
}
