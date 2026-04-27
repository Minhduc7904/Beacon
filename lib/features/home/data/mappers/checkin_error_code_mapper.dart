import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/validation_messages.dart';

class CheckinErrorCodeMapper {
  CheckinErrorCodeMapper._();

  static String? mapCheckinCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.checkinValidationError;
      case ApiErrorCodes.mediaNotFound:
        return ErrorMessages.checkinMediaNotFound;
      case ApiErrorCodes.alreadyCheckedIn:
        return ErrorMessages.checkinAlreadyCheckedIn;
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      default:
        return null;
    }
  }

  static String? mapTodayStatusCode(String code) {
    switch (code) {
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      default:
        return null;
    }
  }
}
