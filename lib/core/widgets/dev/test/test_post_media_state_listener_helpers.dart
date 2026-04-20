import '../../../../features/auth/presentation/controllers/auth_state.dart';
import '../../../../features/home/presentation/controllers/home_state.dart';
import '../../../../features/post_preview/presentation/controllers/post_preview_state.dart';
import 'test_post_media_runner_controller.dart';

bool handleAuthStateForPostMediaTest({
  required TestPostMediaRunnerController controller,
  required AuthState state,
}) {
  final flowState = controller.flowState;
  if (!flowState.isRunning) {
    return false;
  }

  if (state is AuthSuccess) {
    final apiMessage = state.successMessage.trim();
    return controller.appendLoginSuccessLog(
      apiMessage: apiMessage.isNotEmpty ? apiMessage : null,
    );
  }

  if (state is AuthError) {
    return controller.appendErrorLog(errorMessage: state.message);
  }

  if (state is AuthValidationError) {
    return controller.appendErrorLog(errorMessage: state.message);
  }

  return false;
}

bool handleHomeStateForPostMediaTest({
  required TestPostMediaRunnerController controller,
  required HomeState? previous,
  required HomeState next,
}) {
  if (!controller.flowState.isRunning) {
    return false;
  }

  var added = false;

  final previousPath = previous?.capturedImagePath;
  final nextPath = next.capturedImagePath;
  if (nextPath != null && nextPath.isNotEmpty && nextPath != previousPath) {
    added = controller.appendCaptureSuccessLog() || added;
  }

  final nextError = (next.cameraError ?? '').trim();
  final previousError = (previous?.cameraError ?? '').trim();
  if (nextError.isNotEmpty && nextError != previousError) {
    final wasInitializing = previous?.isCameraInitializing == true;
    final wasCapturing = previous?.isCapturing == true;

    final errorMessage = wasInitializing
        ? 'Setup camera không thành công: $nextError'
        : (wasCapturing ? 'Chụp ảnh không thành công: $nextError' : nextError);

    added = controller.appendErrorLog(errorMessage: errorMessage) || added;
  }

  return added;
}

bool handlePostPreviewStateForPostMediaTest({
  required TestPostMediaRunnerController controller,
  required PostPreviewState? previous,
  required PostPreviewState next,
}) {
  if (!controller.flowState.isRunning) {
    return false;
  }

  var added = false;

  if (previous?.uploadedMedia == null && next.uploadedMedia != null) {
    added =
        controller.appendPostSendSuccessLog(message: 'Đăng ảnh thành công') || added;
  }

  final nextError = (next.errorMessage ?? '').trim();
  final previousError = (previous?.errorMessage ?? '').trim();
  if (nextError.isNotEmpty && nextError != previousError) {
    added = controller.appendPostSendErrorLog(errorMessage: nextError) || added;
  }

  return added;
}
