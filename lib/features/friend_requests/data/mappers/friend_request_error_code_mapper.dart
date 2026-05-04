import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/error_messages.dart';

class FriendRequestErrorCodeMapper {
  FriendRequestErrorCodeMapper._();

  static String? mapCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.friendRequestValidationError;
      case ApiErrorCodes.selfFriendRequest:
        return ErrorMessages.friendRequestSelfNotAllowed;
      case ApiErrorCodes.friendRequestDuplicate:
        return ErrorMessages.friendRequestDuplicate;
      case ApiErrorCodes.alreadyFriends:
        return ErrorMessages.friendRequestAlreadyFriends;
      case ApiErrorCodes.friendRequestNotFound:
        return ErrorMessages.friendRequestNotFound;
      case ApiErrorCodes.friendRequestForbidden:
        return ErrorMessages.friendRequestForbidden;
      case ApiErrorCodes.friendRequestNotPending:
        return ErrorMessages.friendRequestNotPending;
      case ApiErrorCodes.unauthorized:
        return ErrorMessages.unauthorized;
      default:
        return null;
    }
  }
}
