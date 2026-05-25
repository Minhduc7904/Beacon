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

class MessageGroupsRemoteDatasourceImpl
    implements MessageGroupsRemoteDatasource {
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
    }
  }

  @override
  Future<MessageGroupDetailModel> createMessageGroup({
    required List<String> memberUserIds,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.messageGroups,
        data: {'memberUserIds': memberUserIds},
      );

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
    }
  }

  @override
  Future<GroupMessageModel> sendPostMessage({
    required String postId,
    required String clientMessageId,
    String? content,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.messageGroupMessages,
        data: {
          'content': content?.trim().isEmpty == true ? null : content?.trim(),
          'clientMessageId': clientMessageId.trim(),
          'postId': postId.trim(),
        },
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
      // ignore: dead_code
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
  Future<GroupMessagePageModel> searchMessages({
    required String groupId,
    required String search,
    String? cursor,
    int? limit,
  }) async {
    try {
      final query = <String, dynamic>{'search': search.trim()};
      if (cursor != null && cursor.trim().isNotEmpty) {
        query['cursor'] = cursor.trim();
      }
      if (limit != null) {
        query['limit'] = limit;
      }

      final response = await _dioClient.get(
        ApiEndpoints.messageGroupMessageSearch(groupId),
        queryParameters: query,
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
  Future<MessageGroupDetailModel> getGroupDetail({
    required String groupId,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.messageGroupDetail(groupId),
      );

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

  @override
  Future<void> addMembers({
    required String groupId,
    required List<String> targetUserIds,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.messageGroupMembers(groupId),
        data: {'targetUserIds': targetUserIds},
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> updateMemberCustomName({
    required String groupId,
    required String userId,
    String? customName,
  }) async {
    try {
      final trimmed = customName?.trim();
      final response = await _dioClient.patch(
        ApiEndpoints.messageGroupMemberCustomName(groupId, userId),
        data: {
          'customName': trimmed == null || trimmed.isEmpty ? null : trimmed,
        },
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> updateMemberRole({
    required String groupId,
    required String targetUserId,
    required int role,
  }) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.messageGroupOwner(groupId),
        data: {
          'targetUserId': targetUserId,
          'role': role,
        },
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> approveMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      final response = await _dioClient.patch(
        ApiEndpoints.messageGroupMemberApprove(groupId, userId),
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> denyMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoints.messageGroupMemberDeny(groupId, userId),
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> updateMuteStatus({
    required String groupId,
    required bool isMuted,
  }) async {
    try {
      final response = await _dioClient.patch(
        ApiEndpoints.messageGroupMute(groupId),
        data: {'isMuted': isMuted},
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> removeMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoints.messageGroupMember(groupId, userId),
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> deleteGroup({required String groupId}) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoints.messageGroupDetail(groupId),
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> leaveGroup({required String groupId}) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoints.messageGroupLeave(groupId),
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> updateRequireApprovalToAddMembers({
    required String groupId,
    required bool requireApprovalToAddMembers,
  }) async {
    try {
      final response = await _dioClient.patch(
        ApiEndpoints.messageGroupRequireApproval(groupId),
        data: {
          'requireApprovalToAddMembers': requireApprovalToAddMembers,
        },
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> updateGroupName({
    required String groupId,
    required String name,
  }) async {
    try {
      final response = await _dioClient.patch(
        ApiEndpoints.messageGroupName(groupId),
        data: {'name': name},
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> updateGroupAvatar({
    required String groupId,
    required String filePath,
  }) async {
    try {
      final fileName = filePath.split(RegExp(r'[\\/]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName.isEmpty ? 'group_avatar.jpg' : fileName,
        ),
      });

      final response = await _dioClient.put(
        ApiEndpoints.messageGroupAvatar(groupId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> markSeen({
    required String groupId,
    required String lastSeenMessageId,
  }) async {
    try {
      final response = await _dioClient.patch(
        ApiEndpoints.messageGroupSeen(groupId),
        data: {'lastSeenMessageId': lastSeenMessageId},
      );
      ApiHandler.handle<void>(
        response,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: MessageGroupsErrorCodeMapper.mapCode,
      );
      rethrow;
    }
  }
}
