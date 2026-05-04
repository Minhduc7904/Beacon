import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/error_messages.dart';

class FriendsErrorCodeMapper {
  FriendsErrorCodeMapper._();

  static String? mapCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.friendTypeValidationError;
      case ApiErrorCodes.friendNotFound:
        return ErrorMessages.friendNotFound;
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      default:
        return null;
    }
  }
}
