import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/friends_error_code_mapper.dart';
import '../models/friend_page_model.dart';
import '../models/friend_presence_page_model.dart';
import '../models/friend_profile_model.dart';
import 'friends_remote_datasource.dart';

class FriendsRemoteDatasourceImpl implements FriendsRemoteDatasource {
  final DioClient _dioClient;

  FriendsRemoteDatasourceImpl(this._dioClient);

  @override
  Future<FriendPageModel> getFriends({
    String? search,
    String? cursor,
    int? limit,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (search != null && search.trim().isNotEmpty) {
        query['search'] = search.trim();
      }
      if (cursor != null && cursor.trim().isNotEmpty) {
        query['cursor'] = cursor.trim();
      }
      if (limit != null) {
        query['limit'] = limit;
      }

      final response = await _dioClient.get(
        ApiEndpoints.friends,
        queryParameters: query.isEmpty ? null : query,
      );

      final result = ApiHandler.handle<FriendPageModel>(
        response,
        fromJsonT: (json) =>
            FriendPageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<FriendPresencePageModel> getFriendsPresence({
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
        ApiEndpoints.friendsPresence,
        queryParameters: query.isEmpty ? null : query,
      );

      final result = ApiHandler.handle<FriendPresencePageModel>(
        response,
        fromJsonT: (json) =>
            FriendPresencePageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<FriendPageModel> searchFriends({
    required String search,
    String? cursor,
    int? limit,
  }) async {
    try {
      final query = <String, dynamic>{'search': search};
      if (cursor != null && cursor.trim().isNotEmpty) {
        query['cursor'] = cursor.trim();
      }
      if (limit != null) {
        query['limit'] = limit;
      }

      final response = await _dioClient.get(
        ApiEndpoints.friendsSearch,
        queryParameters: query,
      );

      final result = ApiHandler.handle<FriendPageModel>(
        response,
        fromJsonT: (json) => FriendPageModel.fromSearchList(
          json is List ? json : const <dynamic>[],
        ),
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<FriendProfileModel> getFriendDetail({required String userId}) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.friendByUserId(userId),
      );

      final result = ApiHandler.handle<FriendProfileModel>(
        response,
        fromJsonT: (json) =>
            FriendProfileModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> updateFriendType({
    required String userId,
    required int type,
  }) async {
    try {
      final response = await _dioClient.patch(
        ApiEndpoints.friendTypeByUserId(userId),
        data: {'type': type},
      );

      ApiHandler.handle<dynamic>(
        response,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> deleteFriend({required String userId}) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoints.friendDeleteByUserId(userId),
      );

      ApiHandler.handle<dynamic>(
        response,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: FriendsErrorCodeMapper.mapCode,
      );
    }
  }
}
