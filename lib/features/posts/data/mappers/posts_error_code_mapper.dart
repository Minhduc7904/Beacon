import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/error_messages.dart';

class PostsErrorCodeMapper {
  PostsErrorCodeMapper._();

  static String? mapCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.postValidationError;
      case ApiErrorCodes.mediaNotFound:
        return ErrorMessages.postMediaNotFound;
      case ApiErrorCodes.mediaAccessDenied:
        return ErrorMessages.postMediaAccessDenied;
      case ApiErrorCodes.mediaNotReady:
        return ErrorMessages.postMediaNotReady;
      case ApiErrorCodes.unsupportedMediaType:
        return ErrorMessages.postUnsupportedMediaType;
      case ApiErrorCodes.invalidVideoDuration:
        return ErrorMessages.postInvalidVideoDuration;
      case ApiErrorCodes.invalidVisibility:
        return ErrorMessages.postInvalidVisibility;
      case ApiErrorCodes.postNotFound:
        return ErrorMessages.postNotFound;
      case ApiErrorCodes.postAccessDenied:
        return ErrorMessages.postAccessDenied;
      case ApiErrorCodes.postUpdateDenied:
        return ErrorMessages.postUpdateDenied;
      case ApiErrorCodes.postDeleteDenied:
        return ErrorMessages.postDeleteDenied;
      case ApiErrorCodes.invalidReactionIcon:
        return ErrorMessages.postInvalidReactionIcon;
      default:
        return null;
    }
  }
}
