import '../models/media_upload_result_model.dart';

abstract class PostPreviewRemoteDatasource {
  Future<MediaUploadResultModel> uploadPostMedia({required String filePath});
}
