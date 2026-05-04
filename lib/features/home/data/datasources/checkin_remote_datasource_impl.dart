import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/checkin_error_code_mapper.dart';
import '../models/checkin_record_model.dart';
import '../models/today_status_model.dart';
import 'checkin_remote_datasource.dart';

class CheckinRemoteDatasourceImpl implements CheckinRemoteDatasource {
  final DioClient _dioClient;

  CheckinRemoteDatasourceImpl(this._dioClient);

  @override
  Future<CheckinRecordModel> checkin({String? note, String? mediaId}) async {
    final body = <String, dynamic>{};

    if (note != null && note.trim().isNotEmpty) {
      body['note'] = note.trim();
    }

    if (mediaId != null && mediaId.trim().isNotEmpty) {
      body['mediaId'] = mediaId.trim();
    }

    try {
      final response = await _dioClient.post(ApiEndpoints.checkins, data: body);

      final result = ApiHandler.handle<CheckinRecordModel>(
        response,
        fromJsonT: (json) =>
            CheckinRecordModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: CheckinErrorCodeMapper.mapCheckinCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: CheckinErrorCodeMapper.mapCheckinCode,
      );
    }
  }

  @override
  Future<TodayStatusModel> getTodayStatus() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.todayStatus);

      final result = ApiHandler.handle<TodayStatusModel>(
        response,
        fromJsonT: (json) =>
            TodayStatusModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: CheckinErrorCodeMapper.mapTodayStatusCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: CheckinErrorCodeMapper.mapTodayStatusCode,
      );
    }
  }
}
