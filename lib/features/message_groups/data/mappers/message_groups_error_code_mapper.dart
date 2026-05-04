import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/error_messages.dart';

class MessageGroupsErrorCodeMapper {
  MessageGroupsErrorCodeMapper._();

  static String? mapCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.messageGroupValidationError;
      case ApiErrorCodes.messageGroupForbidden:
        return ErrorMessages.messageGroupForbidden;
      case ApiErrorCodes.messageGroupNotFound:
        return ErrorMessages.messageGroupNotFound;
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      default:
        return null;
    }
  }
}
