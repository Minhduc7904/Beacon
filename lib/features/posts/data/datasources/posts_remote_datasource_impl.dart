import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../mappers/posts_error_code_mapper.dart';
import '../models/post_model.dart';
import '../models/post_page_model.dart';
import '../models/post_reaction_result_model.dart';
import 'posts_remote_datasource.dart';

class PostsRemoteDatasourceImpl implements PostsRemoteDatasource {
  final DioClient _dioClient;

  PostsRemoteDatasourceImpl(this._dioClient);

  @override
  Future<PostModel> createPost({
    required String mediaId,
    String? caption,
    required String visibility,
  }) async {
    final body = <String, dynamic>{
      'mediaId': mediaId,
      'visibility': visibility,
    };

    if (caption != null) {
      body['caption'] = caption;
    }

    try {
      final response = await _dioClient.post(ApiEndpoints.posts, data: body);

      final result = ApiHandler.handle<PostModel>(
        response,
        fromJsonT: (json) => PostModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<PostPageModel> getFeedPosts({String? cursor, int? limit}) {
    return _getPostPage(ApiEndpoints.postsFeed, cursor: cursor, limit: limit);
  }

  @override
  Future<PostPageModel> getFriendPosts({
    required String friendId,
    String? cursor,
    int? limit,
  }) {
    return _getPostPage(
      ApiEndpoints.postsFriend(friendId),
      cursor: cursor,
      limit: limit,
    );
  }

  @override
  Future<PostPageModel> getMyPosts({String? cursor, int? limit}) {
    return _getPostPage(ApiEndpoints.postsMe, cursor: cursor, limit: limit);
  }

  @override
  Future<PostModel> updatePost({
    required String postId,
    String? caption,
    String? visibility,
  }) async {
    final body = <String, dynamic>{};
    if (caption != null) {
      body['caption'] = caption;
    }
    if (visibility != null) {
      body['visibility'] = visibility;
    }

    try {
      final response = await _dioClient.patch(
        ApiEndpoints.postById(postId),
        data: body,
      );

      final result = ApiHandler.handle<PostModel>(
        response,
        fromJsonT: (json) => PostModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<void> deletePost({required String postId}) async {
    try {
      final response = await _dioClient.delete(ApiEndpoints.postById(postId));

      ApiHandler.handle<dynamic>(
        response,
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<PostReactionResultModel> setReaction({
    required String postId,
    required String icon,
  }) async {
    try {
      final response = await _dioClient.put(
        ApiEndpoints.postReaction(postId),
        data: {'icon': icon},
      );

      final result = ApiHandler.handle<PostReactionResultModel>(
        response,
        fromJsonT: (json) =>
            PostReactionResultModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );
    }
  }

  @override
  Future<PostReactionResultModel> deleteReaction({
    required String postId,
  }) async {
    try {
      final response = await _dioClient.delete(
        ApiEndpoints.postReaction(postId),
      );

      final result = ApiHandler.handle<PostReactionResultModel>(
        response,
        fromJsonT: (json) =>
            PostReactionResultModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );
    }
  }

  Future<PostPageModel> _getPostPage(
    String path, {
    String? cursor,
    int? limit,
  }) async {
    final query = <String, dynamic>{};
    if (cursor != null && cursor.trim().isNotEmpty) {
      query['cursor'] = cursor.trim();
    }
    if (limit != null) {
      query['limit'] = limit;
    }

    try {
      final response = await _dioClient.get(
        path,
        queryParameters: query.isEmpty ? null : query,
      );

      final result = ApiHandler.handle<PostPageModel>(
        response,
        fromJsonT: (json) =>
            PostPageModel.fromJson(json as Map<String, dynamic>),
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );

      return result.data!;
    } on DioException catch (e) {
      ApiHandler.rethrowDioException(
        e,
        codeMessageMapper: PostsErrorCodeMapper.mapCode,
      );
    }
  }
}
