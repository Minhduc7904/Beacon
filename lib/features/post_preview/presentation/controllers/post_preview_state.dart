import '../../domain/entities/media_upload_result.dart';
import '../../../posts/domain/entities/post.dart';

class PostPreviewState {
  final bool isUploading;
  final String? errorMessage;
  final MediaUploadResult? uploadedMedia;
  final Post? createdPost;

  const PostPreviewState({
    required this.isUploading,
    required this.errorMessage,
    required this.uploadedMedia,
    required this.createdPost,
  });

  const PostPreviewState.initial()
    : isUploading = false,
      errorMessage = null,
      uploadedMedia = null,
      createdPost = null;

  PostPreviewState copyWith({
    bool? isUploading,
    String? errorMessage,
    bool clearErrorMessage = false,
    MediaUploadResult? uploadedMedia,
    bool clearUploadedMedia = false,
    Post? createdPost,
    bool clearCreatedPost = false,
  }) {
    return PostPreviewState(
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      uploadedMedia: clearUploadedMedia
          ? null
          : (uploadedMedia ?? this.uploadedMedia),
      createdPost: clearCreatedPost ? null : (createdPost ?? this.createdPost),
    );
  }
}
