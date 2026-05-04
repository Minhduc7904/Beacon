import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/error_messages.dart';

class SafetyErrorCodeMapper {
  SafetyErrorCodeMapper._();

  static String? mapGetCode(String code) {
    switch (code) {
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      default:
        return null;
    }
  }

  static String? mapUpdateCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.safetySettingsValidationError;
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      default:
        return null;
    }
  }
}
