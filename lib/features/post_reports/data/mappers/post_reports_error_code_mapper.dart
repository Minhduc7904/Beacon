import '../../../../core/constants/api_error_codes.dart';
import '../../../../core/constants/error_messages.dart';

class PostReportsErrorCodeMapper {
  PostReportsErrorCodeMapper._();

  static String? mapCode(String code) {
    switch (code) {
      case ApiErrorCodes.validationError:
        return ErrorMessages.postReportValidationError;
      case ApiErrorCodes.postNotFound:
        return ErrorMessages.postNotFound;
      case ApiErrorCodes.postAccessDenied:
        return ErrorMessages.postAccessDenied;
      case ApiErrorCodes.selfPostReportNotAllowed:
        return ErrorMessages.selfPostReportNotAllowed;
      case ApiErrorCodes.postReportAlreadyExists:
        return ErrorMessages.postReportAlreadyExists;
      default:
        return null;
    }
  }
}
