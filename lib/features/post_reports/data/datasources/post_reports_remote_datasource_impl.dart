import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/post_reports_error_code_mapper.dart';
import '../models/post_report_model.dart';
import 'post_reports_remote_datasource.dart';

class PostReportsRemoteDatasourceImpl implements PostReportsRemoteDatasource {
  final DioClient _dioClient;

  PostReportsRemoteDatasourceImpl(this._dioClient);

  @override
  Future<PostReportModel> reportPost({
    required String postId,
    required String reason,
    String? description,
  }) async {
    final body = <String, dynamic>{'reason': reason};
    if (description != null) {
      body['description'] = description;
    }

    try {
      final response = await _dioClient.post(
        ApiEndpoints.postReports(postId),
        data: body,
      );

      final result = ApiHandler.handle<PostReportModel>(
        response,
        fromJsonT: (json) =>
            PostReportModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: PostReportsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostReportsErrorCodeMapper.mapCode,
      );
    }
  }
}
