import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/usecase/upload_post_media_usecase.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final UploadPostMediaUseCase _uploadPostMediaUseCase;
  final AppMessageNotifier _messageNotifier;

  HomeNotifier(this._uploadPostMediaUseCase, this._messageNotifier)
    : super(const HomeInitial());

  Future<void> uploadPostMedia({required String filePath}) async {
    state = const HomeUploading();

    final result = await _uploadPostMediaUseCase(
      UploadPostMediaParams(filePath: filePath),
    );

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = HomeError(failure.message);
      },
      (media) {
        _messageNotifier.addSuccess('Đăng ảnh thành công');
        state = HomeUploadSuccess(media);
      },
    );
  }

  void reset() => state = const HomeInitial();
}
