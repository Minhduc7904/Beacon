import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/validation_messages.dart';

class PostPreviewErrorCodeMapper {
  PostPreviewErrorCodeMapper._();

  static String? mapUploadCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.postMediaUploadValidationError;
      case ApiErrorCodes.invalidFileType:
        return ErrorMessages.postMediaInvalidFileType;
      case ApiErrorCodes.fileTooLarge:
        return ErrorMessages.postMediaFileTooLarge;
      case ApiErrorCodes.uploadFailed:
        return ErrorMessages.postMediaUploadFailed;
      default:
        return null;
    }
  }
}
