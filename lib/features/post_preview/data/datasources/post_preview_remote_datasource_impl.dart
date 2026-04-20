import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/post_preview_error_code_mapper.dart';
import '../models/media_upload_result_model.dart';
import 'post_preview_remote_datasource.dart';

class PostPreviewRemoteDatasourceImpl implements PostPreviewRemoteDatasource {
  final DioClient _dioClient;

  PostPreviewRemoteDatasourceImpl(this._dioClient);

  @override
  Future<MediaUploadResultModel> uploadPostMedia({
    required String filePath,
  }) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName.isEmpty ? 'upload.jpg' : fileName,
        ),
      });

      final response = await _dioClient.post(
        ApiEndpoints.postMediaUpload,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final result = ApiHandler.handle<MediaUploadResultModel>(
        response,
        fromJsonT: (json) =>
            MediaUploadResultModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: PostPreviewErrorCodeMapper.mapUploadCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostPreviewErrorCodeMapper.mapUploadCode,
      );
    }
  }
}
