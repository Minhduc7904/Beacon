class ApiErrorCodes {
  ApiErrorCodes._();

  // Shared
  static const String validationError = 'VALIDATION_ERROR';

  // Auth
  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String accountInactive = 'ACCOUNT_INACTIVE';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String tokenInvalid = 'TOKEN_INVALID';
  static const String userNotFound = 'USER_NOT_FOUND';

  // Auth register conflicts
  static const String usernameAlreadyExists = 'USERNAME_ALREADY_EXISTS';
  static const String emailAlreadyExists = 'EMAIL_ALREADY_EXISTS';
  static const String phoneAlreadyExists = 'PHONE_ALREADY_EXISTS';

  // Auth profile conflicts
  static const String emailAlreadyInUse = 'EMAIL_ALREADY_IN_USE';
  static const String phoneAlreadyInUse = 'PHONE_ALREADY_IN_USE';

  // Storage / media upload
  static const String invalidFileType = 'INVALID_FILE_TYPE';
  static const String fileTooLarge = 'FILE_TOO_LARGE';
  static const String uploadFailed = 'UPLOAD_FAILED';

  // Check-in
  static const String mediaNotFound = 'MEDIA_NOT_FOUND';
  static const String alreadyCheckedIn = 'ALREADY_CHECKED_IN';
}
