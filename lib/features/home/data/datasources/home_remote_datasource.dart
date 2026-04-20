import '../models/media_upload_result_model.dart';

abstract class HomeRemoteDatasource {
  Future<MediaUploadResultModel> uploadPostMedia({required String filePath});
}
