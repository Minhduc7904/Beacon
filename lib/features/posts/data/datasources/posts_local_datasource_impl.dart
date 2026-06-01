import 'package:isar/isar.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_page.dart';
import '../local_models/post_cache.dart';
import '../local_models/post_list_cache.dart';
import '../mappers/post_cache_mapper.dart';
import 'posts_local_datasource.dart';

class PostsLocalDatasourceImpl implements PostsLocalDatasource {
  final AppDatabase _database;

  PostsLocalDatasourceImpl(this._database);

  @override
  Future<PostPage?> getCachedPosts({required String listScopeKey}) async {
    try {
      final scope = _requireCacheKey(listScopeKey);
      return await _database.read((isar) async {
        final listCache = await isar
            .collection<PostListCache>()
            .getByListScopeKey(scope);
        if (listCache == null) {
          return null;
        }

        final posts = await isar
            .collection<PostCache>()
            .filter()
            .listScopeKeyEqualTo(scope)
            .sortBySortOrder()
            .findAll();
        if (posts.isEmpty) {
          return null;
        }

        return posts.toPostPage(nextCursor: listCache.nextCursor);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertPostPage({
    required String listScopeKey,
    required String cacheScopeUserId,
    required String feedType,
    String? friendId,
    required PostPage page,
    required bool isFirstPage,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final scope = _requireCacheKey(listScopeKey);
      final userId = _requireCacheScopeUserId(cacheScopeUserId);
      await _database.write<void>((isar) async {
        final currentListCache = await isar
            .collection<PostListCache>()
            .getByListScopeKey(scope);
        final existing = await isar
            .collection<PostCache>()
            .filter()
            .listScopeKeyEqualTo(scope)
            .sortBySortOrder()
            .findAll();

        final merged = _mergePostCaches(
          existing: existing,
          listScopeKey: scope,
          cacheScopeUserId: userId,
          page: page,
          isFirstPage: isFirstPage,
          cachedAtUtc: cachedAtUtc,
        );

        if (_sameCachedPage(
          existing: existing,
          merged: merged,
          currentListCache: currentListCache,
          nextCursor: page.nextCursor,
        )) {
          return;
        }

        await isar.collection<PostCache>().deleteAll(
          existing.map((cache) => cache.id).toList(),
        );
        if (merged.isNotEmpty) {
          await isar.collection<PostCache>().putAll(merged);
        }

        final listCache = PostListCache()
          ..id = currentListCache?.id ?? Isar.autoIncrement
          ..listScopeKey = scope
          ..cacheScopeUserId = userId
          ..feedType = feedType.trim()
          ..friendId = friendId?.trim()
          ..nextCursor = page.nextCursor
          ..cachedAtUtc = cachedAtUtc.toUtc();
        await isar.collection<PostListCache>().putByListScopeKey(listCache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> deletePost({
    required String listScopeKey,
    required String postId,
  }) async {
    try {
      final scope = _requireCacheKey(listScopeKey);
      final normalizedPostId = _requireCacheKey(postId);
      await _database.write<void>((isar) async {
        final cache = await isar
            .collection<PostCache>()
            .getByCacheKey(postCacheKey(
              listScopeKey: scope,
              postId: normalizedPostId,
            ));
        if (cache == null) {
          return;
        }

        await isar.collection<PostCache>().delete(cache.id);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> updatePostInUserCaches({
    required String cacheScopeUserId,
    required Post post,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final userId = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedPostId = _requireCacheKey(post.id);
      await _database.write<void>((isar) async {
        final caches = await isar
            .collection<PostCache>()
            .filter()
            .cacheScopeUserIdEqualTo(userId)
            .postIdEqualTo(normalizedPostId)
            .findAll();
        if (caches.isEmpty) {
          return;
        }

        final updated = [
          for (final cache in caches)
            _postWithPreservedMediaCache(
              post: post,
              existingCache: cache,
            ).toCache(
              listScopeKey: cache.listScopeKey,
              cacheScopeUserId: userId,
              sortOrder: cache.sortOrder,
              cachedAtUtc: cachedAtUtc,
            )..id = cache.id,
        ];
        await isar.collection<PostCache>().putAllByCacheKey(updated);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> updatePostMediaCacheInUserCaches({
    required String cacheScopeUserId,
    required String postId,
    required String? mediaCacheKey,
    required String? localImagePath,
    required String? localThumbnailPath,
    required DateTime mediaCachedAtUtc,
  }) async {
    try {
      final userId = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedPostId = _requireCacheKey(postId);
      await _database.write<void>((isar) async {
        final caches = await isar
            .collection<PostCache>()
            .filter()
            .cacheScopeUserIdEqualTo(userId)
            .postIdEqualTo(normalizedPostId)
            .findAll();
        if (caches.isEmpty) {
          return;
        }

        final updated = <PostCache>[];
        for (final cache in caches) {
          final post = cache.toDomain();
          final media = post.media.copyWith(
            mediaCacheKey: mediaCacheKey,
            localImagePath: localImagePath,
            localThumbnailPath: localThumbnailPath,
            mediaCachedAtUtc: mediaCachedAtUtc.toUtc(),
          );
          updated.add(
            post
                .copyWith(media: media)
                .toCache(
                  listScopeKey: cache.listScopeKey,
                  cacheScopeUserId: userId,
                  sortOrder: cache.sortOrder,
                  cachedAtUtc: cache.cachedAtUtc,
                )
              ..id = cache.id,
          );
        }

        await isar.collection<PostCache>().putAllByCacheKey(updated);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> clearDeletedMediaPaths({
    required String cacheScopeUserId,
    required Set<String> deletedPaths,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final userId = _requireCacheScopeUserId(cacheScopeUserId);
      if (deletedPaths.isEmpty) {
        return;
      }

      await _database.write<void>((isar) async {
        final caches = await isar
            .collection<PostCache>()
            .filter()
            .cacheScopeUserIdEqualTo(userId)
            .findAll();
        if (caches.isEmpty) {
          return;
        }

        final updated = <PostCache>[];
        for (final cache in caches) {
          final post = cache.toDomain();
          final media = post.media;
          final hasDeletedImage =
              media.localImagePath != null &&
              deletedPaths.contains(media.localImagePath);
          final hasDeletedThumbnail =
              media.localThumbnailPath != null &&
              deletedPaths.contains(media.localThumbnailPath);
          if (!hasDeletedImage && !hasDeletedThumbnail) {
            continue;
          }

          updated.add(
            post
                .copyWith(
                  media: media.copyWith(
                    clearLocalImagePath: hasDeletedImage,
                    clearLocalThumbnailPath: hasDeletedThumbnail,
                    clearMediaCachedAtUtc: hasDeletedImage && hasDeletedThumbnail,
                  ),
                )
                .toCache(
                  listScopeKey: cache.listScopeKey,
                  cacheScopeUserId: userId,
                  sortOrder: cache.sortOrder,
                  cachedAtUtc: cachedAtUtc,
                )
              ..id = cache.id,
          );
        }

        if (updated.isNotEmpty) {
          await isar.collection<PostCache>().putAllByCacheKey(updated);
        }
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> deletePostFromUserCaches({
    required String cacheScopeUserId,
    required String postId,
  }) async {
    try {
      final userId = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedPostId = _requireCacheKey(postId);
      await _database.write<void>((isar) async {
        final caches = await isar
            .collection<PostCache>()
            .filter()
            .cacheScopeUserIdEqualTo(userId)
            .postIdEqualTo(normalizedPostId)
            .findAll();
        if (caches.isEmpty) {
          return;
        }

        await isar
            .collection<PostCache>()
            .deleteAll(caches.map((cache) => cache.id).toList());
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  List<PostCache> _mergePostCaches({
    required List<PostCache> existing,
    required String listScopeKey,
    required String cacheScopeUserId,
    required PostPage page,
    required bool isFirstPage,
    required DateTime cachedAtUtc,
  }) {
    final existingByPostId = {
      for (final cache in existing) cache.postId: cache,
    };
    final pageCaches = [
      for (var index = 0; index < page.items.length; index += 1)
        _postWithPreservedMediaCache(
          post: page.items[index],
          existingCache: existingByPostId[page.items[index].id],
        ).toCache(
          listScopeKey: listScopeKey,
          cacheScopeUserId: cacheScopeUserId,
          sortOrder: index,
          cachedAtUtc: cachedAtUtc,
        ),
    ];

    if (isFirstPage) {
      return pageCaches;
    }

    final pageCachesByPostId = {
      for (final cache in pageCaches) cache.postId: cache,
    };
    final merged = <PostCache>[];
    for (final cache in existing) {
      final remoteCache = pageCachesByPostId.remove(cache.postId);
      if (remoteCache != null) {
        merged.add(remoteCache);
      } else {
        cache.cachedAtUtc = cachedAtUtc.toUtc();
        merged.add(cache);
      }
    }
    merged.addAll(pageCachesByPostId.values);
    for (var index = 0; index < merged.length; index += 1) {
      merged[index].sortOrder = index;
    }

    return merged;
  }

  Post _postWithPreservedMediaCache({
    required Post post,
    required PostCache? existingCache,
  }) {
    if (existingCache == null) {
      return post;
    }

    final cachedMedia = existingCache.toDomain().media;
    if (cachedMedia.id.trim().isNotEmpty &&
        post.media.id.trim().isNotEmpty &&
        cachedMedia.id.trim() != post.media.id.trim()) {
      return post;
    }

    return post.copyWith(
      media: post.media.copyWith(
        localImagePath: cachedMedia.localImagePath,
        localThumbnailPath: cachedMedia.localThumbnailPath,
        mediaCacheKey: cachedMedia.mediaCacheKey,
        mediaCachedAtUtc: cachedMedia.mediaCachedAtUtc,
      ),
    );
  }

  bool _sameCachedPage({
    required List<PostCache> existing,
    required List<PostCache> merged,
    required PostListCache? currentListCache,
    required String? nextCursor,
  }) {
    if (currentListCache == null ||
        currentListCache.nextCursor != nextCursor ||
        existing.length != merged.length) {
      return false;
    }

    for (var index = 0; index < existing.length; index += 1) {
      final left = existing[index];
      final right = merged[index];
      if (left.cacheKey != right.cacheKey ||
          left.listScopeKey != right.listScopeKey ||
          left.cacheScopeUserId != right.cacheScopeUserId ||
          left.postId != right.postId ||
          left.sortOrder != right.sortOrder ||
          left.postJson != right.postJson) {
        return false;
      }
    }

    return true;
  }

  String _requireCacheScopeUserId(String cacheScopeUserId) {
    final scope = cacheScopeUserId.trim();
    if (scope.isEmpty) {
      throw const CacheException(message: 'Missing cache scope user id');
    }

    return scope;
  }

  String _requireCacheKey(String cacheKey) {
    final key = cacheKey.trim();
    if (key.isEmpty) {
      throw const CacheException(message: 'Missing cache key');
    }

    return key;
  }
}
