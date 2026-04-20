import '../../domain/entities/media_upload_result.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeUploading extends HomeState {
  const HomeUploading();
}

class HomeUploadSuccess extends HomeState {
  final MediaUploadResult media;

  const HomeUploadSuccess(this.media);
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
