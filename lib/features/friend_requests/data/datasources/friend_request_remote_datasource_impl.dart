import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/friend_request_error_code_mapper.dart';
import '../models/friend_request_model.dart';
import '../models/friend_request_page_model.dart';
import 'friend_request_remote_datasource.dart';

class FriendRequestRemoteDatasourceImpl implements FriendRequestRemoteDatasource {
  final DioClient _dioClient;

  FriendRequestRemoteDatasourceImpl(this._dioClient);

  @override
  Future<FriendRequestModel> sendFriendRequest({required String receiverId}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.friendRequests,
        data: {'receiverId': receiverId},
      );

      final result = ApiHandler.handle<FriendRequestModel>(
        response,
        fromJsonT: (json) =>
            FriendRequestModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }

  @override
  Future<void> acceptFriendRequest({required String id}) async {
    try {
      final response = await _dioClient.post(ApiEndpoints.friendRequestAccept(id));
      ApiHandler.handle<dynamic>(
        response,
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }

  @override
  Future<void> declineFriendRequest({required String id}) async {
    try {
      final response =
          await _dioClient.post(ApiEndpoints.friendRequestDecline(id));
      ApiHandler.handle<dynamic>(
        response,
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }

  @override
  Future<FriendRequestPageModel> getReceivedRequests({
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
        ApiEndpoints.friendRequestsReceived,
        queryParameters: query.isEmpty ? null : query,
      );

      final result = ApiHandler.handle<FriendRequestPageModel>(
        response,
        fromJsonT: (json) =>
            FriendRequestPageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }

  @override
  Future<FriendRequestPageModel> getSentRequests({
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
        ApiEndpoints.friendRequestsSent,
        queryParameters: query.isEmpty ? null : query,
      );

      final result = ApiHandler.handle<FriendRequestPageModel>(
        response,
        fromJsonT: (json) =>
            FriendRequestPageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendRequestErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }
}
