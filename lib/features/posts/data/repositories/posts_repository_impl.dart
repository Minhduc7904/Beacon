import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/cache/current_user_cache_scope.dart';
import '../../../../core/cache/media_file_cache_service.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_page.dart';
import '../../domain/entities/post_reaction_icon.dart';
import '../../domain/entities/post_reaction_page.dart';
import '../../domain/entities/post_reaction_result.dart';
import '../../domain/entities/post_visibility.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_local_datasource.dart';
import '../datasources/posts_remote_datasource.dart';
import '../mappers/post_cache_mapper.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDatasource _remoteDatasource;
  final PostsLocalDatasource _localDatasource;
  final CurrentUserCacheScope _currentUserCacheScope;
  final MediaFileCacheService? _mediaFileCacheService;
  final NetworkInfo _networkInfo;
  final DateTime Function() _nowUtc;

  PostsRepositoryImpl({
    required PostsRemoteDatasource remoteDatasource,
    required PostsLocalDatasource localDatasource,
    required CurrentUserCacheScope currentUserCacheScope,
    MediaFileCacheService? mediaFileCacheService,
    required NetworkInfo networkInfo,
    DateTime Function()? nowUtc,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _currentUserCacheScope = currentUserCacheScope,
       _mediaFileCacheService = mediaFileCacheService,
       _networkInfo = networkInfo,
       _nowUtc = nowUtc ?? (() => DateTime.now().toUtc());

  @override
  Future<Either<Failure, Post>> createPost({
    required String mediaId,
    String? caption,
    required PostVisibility visibility,
    double? latitude,
    double? longitude,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final post = await _remoteDatasource.createPost(
        mediaId: mediaId,
        caption: caption,
        visibility: visibility.value,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(post);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, PostPage>> getFeedPosts({String? cursor, int? limit}) {
    return _getPostPage(
      feedType: 'all',
      cursor: cursor,
      load: () => _remoteDatasource.getFeedPosts(cursor: cursor, limit: limit),
    );
  }

  @override
  Future<Either<Failure, PostPage>> getCachedFeedPosts({int? limit}) {
    return _getCachedPostPage(feedType: 'all');
  }

  @override
  Future<Either<Failure, PostPage>> getFriendPosts({
    required String friendId,
    String? cursor,
    int? limit,
  }) {
    return _getPostPage(
      feedType: 'friend',
      friendId: friendId,
      cursor: cursor,
      load: () => _remoteDatasource.getFriendPosts(
        friendId: friendId,
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, PostPage>> getCachedFriendPosts({
    required String friendId,
    int? limit,
  }) {
    return _getCachedPostPage(feedType: 'friend', friendId: friendId);
  }

  @override
  Future<Either<Failure, PostPage>> getMyPosts({String? cursor, int? limit}) {
    return _getPostPage(
      feedType: 'me',
      cursor: cursor,
      load: () => _remoteDatasource.getMyPosts(cursor: cursor, limit: limit),
    );
  }

  @override
  Future<Either<Failure, PostPage>> getCachedMyPosts({int? limit}) {
    return _getCachedPostPage(feedType: 'me');
  }

  @override
  Future<Either<Failure, Post>> updatePost({
    required String postId,
    String? caption,
    PostVisibility? visibility,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final post = await _remoteDatasource.updatePost(
        postId: postId,
        caption: caption,
        visibility: visibility?.value,
      );
      await _updatePostCacheIfScoped(post);
      return Right(post);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.deletePost(postId: postId);
      await _deletePostCacheIfScoped(postId);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, PostReactionResult>> setReaction({
    required String postId,
    required PostReactionIcon icon,
  }) {
    return _changeReaction(
      () => _remoteDatasource.setReactionIcon(postId: postId, icon: icon.value),
    );
  }

  @override
  Future<Either<Failure, PostReactionResult>> setReactionIcon({
    required String postId,
    required String icon,
  }) {
    return _changeReaction(
      () => _remoteDatasource.setReactionIcon(postId: postId, icon: icon),
    );
  }

  @override
  Future<Either<Failure, PostReactionResult>> deleteReaction({
    required String postId,
  }) {
    return _changeReaction(
      () => _remoteDatasource.deleteReaction(postId: postId),
    );
  }

  @override
  Future<Either<Failure, PostReactionPage>> getReactions({
    required String postId,
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final page = await _remoteDatasource.getReactions(
        postId: postId,
        cursor: cursor,
        limit: limit,
      );
      return Right(page);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<Either<Failure, PostReactionResult>> _changeReaction(
    Future<PostReactionResult> Function() change,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await change();
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<Either<Failure, PostPage>> _getPostPage({
    required String feedType,
    String? friendId,
    String? cursor,
    required Future<PostPage> Function() load,
  }) async {
    if (!await _networkInfo.isConnected) {
      if (cursor != null && cursor.trim().isNotEmpty) {
        return const Left(NetworkFailure());
      }
      return _getCachedPostPage(feedType: feedType, friendId: friendId);
    }

    try {
      final page = await load();
      await _upsertPostPageCache(
        feedType: feedType,
        friendId: friendId,
        cursor: cursor,
        page: page,
      );
      unawaited(_cachePostPageMediaIfScoped(page));
      return Right(page);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<Either<Failure, PostPage>> _getCachedPostPage({
    required String feedType,
    String? friendId,
  }) async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return const Left(NetworkFailure());
      }

      final page = await _localDatasource.getCachedPosts(
        listScopeKey: postListScopeKey(
          cacheScopeUserId: cacheScopeUserId,
          feedType: feedType,
          friendId: friendId,
        ),
      );
      if (page == null) {
        return const Left(NetworkFailure());
      }

      return Right(page);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<void> _upsertPostPageCache({
    required String feedType,
    String? friendId,
    String? cursor,
    required PostPage page,
  }) async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return;
      }

      await _localDatasource.upsertPostPage(
        listScopeKey: postListScopeKey(
          cacheScopeUserId: cacheScopeUserId,
          feedType: feedType,
          friendId: friendId,
        ),
        cacheScopeUserId: cacheScopeUserId,
        feedType: feedType,
        friendId: friendId,
        page: page,
        isFirstPage: cursor == null || cursor.trim().isEmpty,
        cachedAtUtc: _nowUtc(),
      );
    } on Exception {
      // Cache write is best-effort; remote success remains source of truth.
    }
  }

  Future<void> _updatePostCacheIfScoped(Post post) async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return;
      }

      await _localDatasource.updatePostInUserCaches(
        cacheScopeUserId: cacheScopeUserId,
        post: post,
        cachedAtUtc: _nowUtc(),
      );
    } on Exception {
      // Cache write is best-effort; remote success remains source of truth.
    }
  }

  Future<void> _cachePostPageMediaIfScoped(PostPage page) async {
    final mediaFileCacheService = _mediaFileCacheService;
    if (mediaFileCacheService == null || page.items.isEmpty) {
      return;
    }

    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return;
      }

      final protectedPaths = <String>{};
      for (final post in page.items) {
        final thumbnailUrl = post.media.thumbnailUrl?.trim();
        final originalUrl = post.media.url.trim();
        String? localThumbnailPath;
        String? localImagePath;

        if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
          localThumbnailPath = await mediaFileCacheService.cachePostMedia(
            remoteUrl: thumbnailUrl,
            mediaId: post.media.id,
            objectKey: null,
            variant: MediaFileCacheVariant.thumbnail,
          );
        }

        if ((thumbnailUrl == null || thumbnailUrl.isEmpty) &&
            originalUrl.isNotEmpty) {
          localImagePath = await mediaFileCacheService.cachePostMedia(
            remoteUrl: originalUrl,
            mediaId: post.media.id,
            objectKey: null,
            variant: MediaFileCacheVariant.original,
          );
        }

        if (localThumbnailPath == null && localImagePath == null) {
          continue;
        }

        protectedPaths.addAll([
          if (localThumbnailPath != null) localThumbnailPath,
          if (localImagePath != null) localImagePath,
        ]);

        await _localDatasource.updatePostMediaCacheInUserCaches(
          cacheScopeUserId: cacheScopeUserId,
          postId: post.id,
          mediaCacheKey: mediaFileCacheService.cacheKeyFor(
            mediaId: post.media.id,
            objectKey: null,
            remoteUrl: post.media.url,
          ),
          localImagePath: localImagePath,
          localThumbnailPath: localThumbnailPath,
          mediaCachedAtUtc: _nowUtc(),
        );
      }

      final deletedPaths = await mediaFileCacheService.cleanupPostMedia(
        protectedPaths: protectedPaths,
      );
      if (deletedPaths.isNotEmpty) {
        await _localDatasource.clearDeletedMediaPaths(
          cacheScopeUserId: cacheScopeUserId,
          deletedPaths: deletedPaths,
          cachedAtUtc: _nowUtc(),
        );
      }
    } on Exception {
      // Media file cache is best-effort; post metadata stays usable offline.
    }
  }

  Future<void> _deletePostCacheIfScoped(String postId) async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return;
      }

      await _localDatasource.deletePostFromUserCaches(
        cacheScopeUserId: cacheScopeUserId,
        postId: postId,
      );
    } on Exception {
      // Cache delete is best-effort; remote success remains source of truth.
    }
  }
}
