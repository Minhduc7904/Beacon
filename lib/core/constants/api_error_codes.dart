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
  static const String mediaAccessDenied = 'MEDIA_ACCESS_DENIED';
  static const String mediaNotReady = 'MEDIA_NOT_READY';
  static const String unsupportedMediaType = 'UNSUPPORTED_MEDIA_TYPE';
  static const String invalidVideoDuration = 'INVALID_VIDEO_DURATION';

  // Check-in
  static const String mediaNotFound = 'MEDIA_NOT_FOUND';
  static const String alreadyCheckedIn = 'ALREADY_CHECKED_IN';

  // Posts / reactions
  static const String invalidVisibility = 'INVALID_VISIBILITY';
  static const String postNotFound = 'POST_NOT_FOUND';
  static const String postAccessDenied = 'POST_ACCESS_DENIED';
  static const String postUpdateDenied = 'POST_UPDATE_DENIED';
  static const String postDeleteDenied = 'POST_DELETE_DENIED';
  static const String invalidReactionIcon = 'INVALID_REACTION_ICON';

  // Friend requests
  static const String selfFriendRequest = 'SELF_FRIEND_REQUEST';
  static const String friendRequestDuplicate = 'FRIEND_REQUEST_DUPLICATE';
  static const String alreadyFriends = 'ALREADY_FRIENDS';
  static const String friendRequestNotFound = 'FRIEND_REQUEST_NOT_FOUND';
  static const String friendRequestForbidden = 'FRIEND_REQUEST_FORBIDDEN';
  static const String friendRequestNotPending = 'FRIEND_REQUEST_NOT_PENDING';

  // Friends
  static const String friendNotFound = 'FRIEND_NOT_FOUND';

  // Message groups
  static const String messageGroupForbidden = 'MESSAGE_GROUP_FORBIDDEN';
  static const String messageGroupNotFound = 'MESSAGE_GROUP_NOT_FOUND';
  static const String groupMemberAlreadyExists = 'GROUP_MEMBER_ALREADY_EXISTS';
  static const String groupMemberNotFound = 'GROUP_MEMBER_NOT_FOUND';
  static const String groupMemberNotPending = 'GROUP_MEMBER_NOT_PENDING';
}
