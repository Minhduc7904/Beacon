import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/message_groups_error_code_mapper.dart';
import '../models/message_group_detail_model.dart';
import '../models/group_message_model.dart';
import '../models/group_message_page_model.dart';
import '../models/message_group_page_model.dart';
import 'message_groups_remote_datasource.dart';

class MessageGroupsRemoteDatasourceImpl implements MessageGroupsRemoteDatasource {
  final DioClient _dioClient;

  MessageGroupsRemoteDatasourceImpl(this._dioClient);

  @override
  Future<MessageGroupPageModel> getMessageGroups({
    String? cursor,
    int? limit,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (cursor != null && cursor.trim().isNotEmpty) {
        query['cursor'] = cursor.trim();
      }
      if (limit != null) {
        query['limit'] = limit;
      }

      final response = await _dioClient.get(
        ApiEndpoints.messageGroups,
        queryParameters: query.isEmpty ? null : query,
      );

      final result = ApiHandler.handle<MessageGroupPageModel>(
        response,
        fromJsonT: (json) =>
            MessageGroupPageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }

  @override
  Future<GroupMessageModel> sendMessage({
    required String groupId,
    required String content,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.messageGroupMessage(groupId),
        data: {'content': content},
      );

      final result = ApiHandler.handle<GroupMessageModel>(
        response,
        fromJsonT: (json) =>
            GroupMessageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }

  @override
  Future<GroupMessagePageModel> getMessages({
    required String groupId,
    String? cursor,
    int? limit,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (cursor != null && cursor.trim().isNotEmpty) {
        query['cursor'] = cursor.trim();
      }
      if (limit != null) {
        query['limit'] = limit;
      }

      final response = await _dioClient.get(
        ApiEndpoints.messageGroupMessage(groupId),
        queryParameters: query.isEmpty ? null : query,
      );

      final result = ApiHandler.handle<GroupMessagePageModel>(
        response,
        fromJsonT: (json) =>
            GroupMessagePageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }

  @override
  Future<MessageGroupDetailModel> getGroupDetail({required String groupId}) async {
    try {
      final response = await _dioClient.get(ApiEndpoints.messageGroupDetail(groupId));

      final result = ApiHandler.handle<MessageGroupDetailModel>(
        response,
        fromJsonT: (json) =>
            MessageGroupDetailModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }
}
