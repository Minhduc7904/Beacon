import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/usecase/report_post_usecase.dart';
import 'post_report_state.dart';

class PostReportNotifier extends StateNotifier<PostReportState> {
  final ReportPostUseCase _reportPostUseCase;
  final AppMessageNotifier _messageNotifier;

  PostReportNotifier(this._reportPostUseCase, this._messageNotifier)
    : super(const PostReportState());

  Future<bool> submitReport({
    required String postId,
    required String reason,
    String? description,
  }) async {
    if (state.isSubmitting) {
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      didSubmit: false,
      clearErrorMessage: true,
    );

    final result = await _reportPostUseCase(
      ReportPostParams(
        postId: postId,
        reason: reason,
        description: description,
      ),
    );

    var didSubmit = false;
    result.fold(
      (failure) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        _messageNotifier.addError(failure.message);
      },
      (_) {
        didSubmit = true;
        state = state.copyWith(
          isSubmitting: false,
          didSubmit: true,
          clearErrorMessage: true,
        );
        _messageNotifier.addSuccess('Đã gửi báo cáo bài đăng');
      },
    );

    return didSubmit;
  }
}
