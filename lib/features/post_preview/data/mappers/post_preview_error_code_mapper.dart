class PostPreviewErrorCodeMapper {
  PostPreviewErrorCodeMapper._();

  static String? mapUploadCode(String code) {
    switch (code) {
      case 'VALIDATION_ERROR':
        return 'File không hợp lệ hoặc vượt quá dung lượng cho phép';
      case 'INVALID_FILE_TYPE':
        return 'Loại file không được hỗ trợ';
      case 'FILE_TOO_LARGE':
        return 'File vượt quá dung lượng cho phép';
      case 'UPLOAD_FAILED':
        return 'Upload thất bại. Vui lòng thử lại';
      default:
        return null;
    }
  }
}
