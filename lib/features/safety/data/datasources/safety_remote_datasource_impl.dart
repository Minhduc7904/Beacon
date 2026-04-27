import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/safety_error_code_mapper.dart';
import '../models/safety_settings_model.dart';
import 'safety_remote_datasource.dart';

class SafetyRemoteDatasourceImpl implements SafetyRemoteDatasource {
  final DioClient _dioClient;

  SafetyRemoteDatasourceImpl(this._dioClient);

  @override
  Future<SafetySettingsModel> getSafetySettings() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.safetySettings);

      final result = ApiHandler.handle<SafetySettingsModel>(
        response,
        fromJsonT: (json) =>
            SafetySettingsModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: SafetyErrorCodeMapper.mapGetCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: SafetyErrorCodeMapper.mapGetCode,
      );
      rethrow;
    }
  }

  @override
  Future<SafetySettingsModel> updateSafetySettings({
    required Map<String, dynamic> body,
  }) async {
    /// ❌ chặn request rỗng (double safety)
    if (body.isEmpty) {
      throw Exception('No fields to update');
    }

    try {
      /// 🔥 log debug (rất hữu ích)
      // ignore: avoid_print
      print('PATCH /safety-settings: $body');

      final response = await _dioClient.patch(
        ApiEndpoints.safetySettings,
        data: body,
      );

      final result = ApiHandler.handle<SafetySettingsModel>(
        response,
        fromJsonT: (json) =>
            SafetySettingsModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: SafetyErrorCodeMapper.mapUpdateCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: SafetyErrorCodeMapper.mapUpdateCode,
      );
      rethrow;
    }
  }
}
