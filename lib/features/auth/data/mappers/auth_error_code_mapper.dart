import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/validation_messages.dart';

class AuthErrorCodeMapper {
  AuthErrorCodeMapper._();

  static const String registerUsernameExistsMessage =
      ErrorMessages.registerUsernameExists;

  static String? mapCheckPhoneCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.checkPhoneValidationError;
      default:
        return null;
    }
  }

  static String? mapCheckEmailCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.checkEmailValidationError;
      default:
        return null;
    }
  }

  static String? mapLoginCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.loginValidationError;
      case ApiErrorCodes.invalidCredentials:
        return ErrorMessages.loginInvalidCredentials;
      case ApiErrorCodes.accountInactive:
        return ErrorMessages.accountInactive;
      default:
        return null;
    }
  }

  static String mapRegisterCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.registerValidationError;
      case ApiErrorCodes.usernameAlreadyExists:
        return registerUsernameExistsMessage;
      case ApiErrorCodes.emailAlreadyExists:
        return ErrorMessages.registerEmailExists;
      case ApiErrorCodes.phoneAlreadyExists:
        return ErrorMessages.registerPhoneExists;
      default:
        return ErrorMessages.registerFailedFallback;
    }
  }

  static String? mapMeCode(String code) {
    switch (code) {
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      case ApiErrorCodes.userNotFound:
        return ErrorMessages.userNotFound;
      default:
        return null;
    }
  }

  static String? mapUpdateMeCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.updateMeValidationError;
      case ApiErrorCodes.userNotFound:
        return ErrorMessages.userNotFound;
      case ApiErrorCodes.emailAlreadyInUse:
        return ErrorMessages.updateMeEmailAlreadyInUse;
      case ApiErrorCodes.phoneAlreadyInUse:
        return ErrorMessages.updateMePhoneAlreadyInUse;
      default:
        return null;
    }
  }

  static String? mapUpdateAvatarCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.updateAvatarValidationError;
      case ApiErrorCodes.userNotFound:
        return ErrorMessages.userNotFound;
      case ApiErrorCodes.uploadFailed:
        return ErrorMessages.updateAvatarUploadFailed;
      default:
        return null;
    }
  }
}
