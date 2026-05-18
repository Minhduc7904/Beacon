import '../../domain/entities/media_upload_result.dart';
import '../../../posts/domain/entities/post.dart';

class PostPreviewState {
  final bool isUploading;
  final String? errorMessage;
  final MediaUploadResult? uploadedMedia;
  final String? uploadedMediaFilePath;
  final Post? createdPost;

  const PostPreviewState({
    required this.isUploading,
    required this.errorMessage,
    required this.uploadedMedia,
    required this.uploadedMediaFilePath,
    required this.createdPost,
  });

  const PostPreviewState.initial()
    : isUploading = false,
      errorMessage = null,
      uploadedMedia = null,
      uploadedMediaFilePath = null,
      createdPost = null;

  PostPreviewState copyWith({
    bool? isUploading,
    String? errorMessage,
    bool clearErrorMessage = false,
    MediaUploadResult? uploadedMedia,
    String? uploadedMediaFilePath,
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
      uploadedMediaFilePath: clearUploadedMedia
          ? null
          : (uploadedMediaFilePath ?? this.uploadedMediaFilePath),
      createdPost: clearCreatedPost ? null : (createdPost ?? this.createdPost),
    );
  }
}
