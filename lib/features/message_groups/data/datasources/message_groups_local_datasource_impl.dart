import 'package:isar/isar.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/entities/group_message_page.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_page.dart';
import '../local_models/group_message_cache.dart';
import '../local_models/group_message_list_cache.dart';
import '../local_models/message_group_cache.dart';
import '../local_models/message_group_detail_cache.dart';
import '../local_models/message_group_list_cache.dart';
import '../mappers/group_message_cache_mapper.dart';
import '../mappers/message_group_cache_mapper.dart';
import '../mappers/message_group_detail_cache_mapper.dart';
import 'message_groups_local_datasource.dart';

class MessageGroupsLocalDatasourceImpl implements MessageGroupsLocalDatasource {
  MessageGroupsLocalDatasourceImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<MessageGroup>> watchMessageGroups({
    required String cacheScopeUserId,
  }) {
    final scope = _requireCacheScopeUserId(cacheScopeUserId);
    return _database
        .watch(
          (isar) => isar
              .collection<MessageGroupCache>()
              .filter()
              .cacheScopeUserIdEqualTo(scope)
              .watch(fireImmediately: true),
        )
        .map(_sortedGroupCachesToDomain);
  }

  @override
  Future<MessageGroupPage?> getCachedMessageGroups({
    required String cacheScopeUserId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      return await _database.read((isar) async {
        final caches = await isar
            .collection<MessageGroupCache>()
            .filter()
            .cacheScopeUserIdEqualTo(scope)
            .findAll();
        if (caches.isEmpty) {
          return null;
        }

        final listCache = await isar
            .collection<MessageGroupListCache>()
            .getByCacheScopeUserId(scope);

        return MessageGroupPage(
          items: _sortedGroupCachesToDomain(caches),
          nextCursor: listCache?.nextCursor,
          limit: listCache?.limit ?? caches.length,
          hasMore: listCache?.hasMore ?? false,
        );
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertMessageGroups({
    required String cacheScopeUserId,
    required MessageGroupPage page,
    required bool isFirstPage,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      await _database.write<void>((isar) async {
        final caches = page.items
            .where((group) => group.groupId.trim().isNotEmpty)
            .map((group) => group.toCache(
                  cacheScopeUserId: scope,
                  cachedAtUtc: cachedAtUtc,
                ))
            .toList();

        if (caches.isNotEmpty) {
          await isar.collection<MessageGroupCache>().putAllByCacheKey(caches);
        }

        final existingListCache = await isar
            .collection<MessageGroupListCache>()
            .getByCacheScopeUserId(scope);
        final listCache = MessageGroupListCache()
          ..id = existingListCache?.id ?? Isar.autoIncrement
          ..cacheScopeUserId = scope
          ..nextCursor = page.nextCursor
          ..limit = page.limit
          ..hasMore = page.hasMore
          ..cachedAtUtc = cachedAtUtc.toUtc();
        await isar
            .collection<MessageGroupListCache>()
            .putByCacheScopeUserId(listCache);

        if (isFirstPage && !page.hasMore) {
          final incomingIds = page.items
              .map((group) => group.groupId.trim())
              .where((id) => id.isNotEmpty)
              .toSet();
          final existing = await isar
              .collection<MessageGroupCache>()
              .filter()
              .cacheScopeUserIdEqualTo(scope)
              .findAll();
          final removed = existing
              .where((cache) => !incomingIds.contains(cache.groupId))
              .toList();

          if (removed.isNotEmpty) {
            await isar
                .collection<MessageGroupCache>()
                .deleteAll(removed.map((cache) => cache.id).toList());
            await _deleteGroupCaches(
              isar,
              cacheScopeUserId: scope,
              groupIds: removed.map((cache) => cache.groupId).toList(),
            );
          }
        }
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertMessageGroup({
    required String cacheScopeUserId,
    required MessageGroup group,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      if (group.groupId.trim().isEmpty) {
        return;
      }
      await _database.write<void>((isar) async {
        final cache = group.toCache(
          cacheScopeUserId: scope,
          cachedAtUtc: cachedAtUtc,
        );
        await isar.collection<MessageGroupCache>().putByCacheKey(cache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> deleteMessageGroup({
    required String cacheScopeUserId,
    required String groupId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedGroupId = _requireCacheKey(groupId);
      await _database.write<void>((isar) async {
        final cacheKey = messageGroupCacheKey(
          cacheScopeUserId: scope,
          groupId: normalizedGroupId,
        );
        final cache = await isar
            .collection<MessageGroupCache>()
            .getByCacheKey(cacheKey);
        if (cache != null) {
          await isar.collection<MessageGroupCache>().delete(cache.id);
        }

        await _deleteGroupCaches(
          isar,
          cacheScopeUserId: scope,
          groupIds: [normalizedGroupId],
        );
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Stream<MessageGroupDetail?> watchMessageGroupDetail({
    required String cacheScopeUserId,
    required String groupId,
  }) {
    final scope = _requireCacheScopeUserId(cacheScopeUserId);
    final normalizedGroupId = _requireCacheKey(groupId);
    final cacheKey = messageGroupDetailCacheKey(
      cacheScopeUserId: scope,
      groupId: normalizedGroupId,
    );

    return _database
        .watch(
          (isar) => isar
              .collection<MessageGroupDetailCache>()
              .filter()
              .cacheKeyEqualTo(cacheKey)
              .watch(fireImmediately: true),
        )
        .map((items) => items.isEmpty ? null : items.first.toDomain());
  }

  @override
  Future<MessageGroupDetail?> getCachedMessageGroupDetail({
    required String cacheScopeUserId,
    required String groupId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedGroupId = _requireCacheKey(groupId);
      return await _database.read((isar) async {
        final cacheKey = messageGroupDetailCacheKey(
          cacheScopeUserId: scope,
          groupId: normalizedGroupId,
        );
        final cache = await isar
            .collection<MessageGroupDetailCache>()
            .getByCacheKey(cacheKey);
        return cache?.toDomain();
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertMessageGroupDetail({
    required String cacheScopeUserId,
    required MessageGroupDetail detail,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      if (detail.groupId.trim().isEmpty) {
        return;
      }
      await _database.write<void>((isar) async {
        final cache = detail.toCache(
          cacheScopeUserId: scope,
          cachedAtUtc: cachedAtUtc,
        );
        await isar.collection<MessageGroupDetailCache>().putByCacheKey(cache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Stream<List<GroupMessage>> watchGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
  }) {
    final scope = _requireCacheScopeUserId(cacheScopeUserId);
    final normalizedGroupId = _requireCacheKey(groupId);
    return _database
        .watch(
          (isar) => isar
              .collection<GroupMessageCache>()
              .filter()
              .cacheScopeUserIdEqualTo(scope)
              .groupIdEqualTo(normalizedGroupId)
              .watch(fireImmediately: true),
        )
        .map(_sortedMessageCachesToDomain);
  }

  @override
  Future<GroupMessagePage?> getCachedGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedGroupId = _requireCacheKey(groupId);
      return await _database.read((isar) async {
        final caches = await isar
            .collection<GroupMessageCache>()
            .filter()
            .cacheScopeUserIdEqualTo(scope)
            .groupIdEqualTo(normalizedGroupId)
            .findAll();
        if (caches.isEmpty) {
          return null;
        }

        final listCacheKey = groupMessageListCacheKey(
          cacheScopeUserId: scope,
          groupId: normalizedGroupId,
        );
        final listCache = await isar
            .collection<GroupMessageListCache>()
            .getByCacheKey(listCacheKey);

        return GroupMessagePage(
          items: _sortedMessageCachesToDomain(caches),
          nextCursor: listCache?.nextCursor,
          limit: listCache?.limit ?? caches.length,
          hasMore: listCache?.hasMore ?? false,
        );
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
    required GroupMessagePage page,
    required bool isFirstPage,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedGroupId = _requireCacheKey(groupId);
      await _database.write<void>((isar) async {
        final existing = await isar
            .collection<GroupMessageCache>()
            .filter()
            .cacheScopeUserIdEqualTo(scope)
            .groupIdEqualTo(normalizedGroupId)
            .findAll();

        final incoming = page.items
            .where((message) => message.id.trim().isNotEmpty)
            .map((message) => message.toCache(
                  cacheScopeUserId: scope,
                  cachedAtUtc: cachedAtUtc,
                ))
            .toList();

        if (isFirstPage) {
          if (existing.isNotEmpty) {
            await isar.collection<GroupMessageCache>().deleteAll(
                  existing.map((cache) => cache.id).toList(),
                );
          }
          if (incoming.isNotEmpty) {
            await isar.collection<GroupMessageCache>().putAllByCacheKey(
                  incoming,
                );
          }
        } else {
          final mergedById = <String, GroupMessageCache>{
            for (final cache in existing) cache.messageId: cache,
          };
          for (final incomingCache in incoming) {
            mergedById[incomingCache.messageId] = incomingCache;
          }
          final merged = mergedById.values.toList();
          if (existing.isNotEmpty) {
            await isar.collection<GroupMessageCache>().deleteAll(
                  existing.map((cache) => cache.id).toList(),
                );
          }
          if (merged.isNotEmpty) {
            await isar.collection<GroupMessageCache>().putAllByCacheKey(merged);
          }
        }

        final listCacheKey = groupMessageListCacheKey(
          cacheScopeUserId: scope,
          groupId: normalizedGroupId,
        );
        final existingListCache = await isar
            .collection<GroupMessageListCache>()
            .getByCacheKey(listCacheKey);
        final listCache = GroupMessageListCache()
          ..id = existingListCache?.id ?? Isar.autoIncrement
          ..cacheKey = listCacheKey
          ..cacheScopeUserId = scope
          ..groupId = normalizedGroupId
          ..nextCursor = page.nextCursor
          ..limit = page.limit
          ..hasMore = page.hasMore
          ..cachedAtUtc = cachedAtUtc.toUtc();
        await isar.collection<GroupMessageListCache>().putByCacheKey(listCache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> upsertGroupMessage({
    required String cacheScopeUserId,
    required GroupMessage message,
    required DateTime cachedAtUtc,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      if (message.id.trim().isEmpty || message.groupId.trim().isEmpty) {
        return;
      }
      await _database.write<void>((isar) async {
        final cache = message.toCache(
          cacheScopeUserId: scope,
          cachedAtUtc: cachedAtUtc,
        );
        await isar.collection<GroupMessageCache>().putByCacheKey(cache);
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  @override
  Future<void> deleteGroupMessages({
    required String cacheScopeUserId,
    required String groupId,
  }) async {
    try {
      final scope = _requireCacheScopeUserId(cacheScopeUserId);
      final normalizedGroupId = _requireCacheKey(groupId);
      await _database.write<void>((isar) async {
        final caches = await isar
            .collection<GroupMessageCache>()
            .filter()
            .cacheScopeUserIdEqualTo(scope)
            .groupIdEqualTo(normalizedGroupId)
            .findAll();
        if (caches.isNotEmpty) {
          await isar
              .collection<GroupMessageCache>()
              .deleteAll(caches.map((cache) => cache.id).toList());
        }

        final listCacheKey = groupMessageListCacheKey(
          cacheScopeUserId: scope,
          groupId: normalizedGroupId,
        );
        final listCache = await isar
            .collection<GroupMessageListCache>()
            .getByCacheKey(listCacheKey);
        if (listCache != null) {
          await isar.collection<GroupMessageListCache>().delete(listCache.id);
        }
      });
    } on CacheException {
      rethrow;
    } catch (error) {
      throw CacheException(message: error.toString());
    }
  }

  List<MessageGroup> _sortedGroupCachesToDomain(
    List<MessageGroupCache> caches,
  ) {
    final sorted = [...caches]
      ..sort((a, b) {
        final aTime =
            a.lastMessageAtUtc ?? a.createdAtUtc ?? _fallbackUtcDate;
        final bTime =
            b.lastMessageAtUtc ?? b.createdAtUtc ?? _fallbackUtcDate;
        return bTime.compareTo(aTime);
      });

    return sorted.map((cache) => cache.toDomain()).toList();
  }

  List<GroupMessage> _sortedMessageCachesToDomain(
    List<GroupMessageCache> caches,
  ) {
    final sorted = [...caches]
      ..sort((a, b) {
        final aTime = a.createdAtUtc ?? _fallbackUtcDate;
        final bTime = b.createdAtUtc ?? _fallbackUtcDate;
        return aTime.compareTo(bTime);
      });

    return sorted.map((cache) => cache.toDomain()).toList();
  }

  Future<void> _deleteGroupCaches(
    Isar isar, {
    required String cacheScopeUserId,
    required List<String> groupIds,
  }) async {
    if (groupIds.isEmpty) {
      return;
    }

    final normalizedIds = groupIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toList();
    if (normalizedIds.isEmpty) {
      return;
    }

    for (final groupId in normalizedIds) {
      final detailCacheKey = messageGroupDetailCacheKey(
        cacheScopeUserId: cacheScopeUserId,
        groupId: groupId,
      );
      final detailCache = await isar
          .collection<MessageGroupDetailCache>()
          .getByCacheKey(detailCacheKey);
      if (detailCache != null) {
        await isar.collection<MessageGroupDetailCache>().delete(detailCache.id);
      }

      final messageCaches = await isar
          .collection<GroupMessageCache>()
          .filter()
          .cacheScopeUserIdEqualTo(cacheScopeUserId)
          .groupIdEqualTo(groupId)
          .findAll();
      if (messageCaches.isNotEmpty) {
        await isar
            .collection<GroupMessageCache>()
            .deleteAll(messageCaches.map((cache) => cache.id).toList());
      }

      final listCacheKey = groupMessageListCacheKey(
        cacheScopeUserId: cacheScopeUserId,
        groupId: groupId,
      );
      final listCache = await isar
          .collection<GroupMessageListCache>()
          .getByCacheKey(listCacheKey);
      if (listCache != null) {
        await isar.collection<GroupMessageListCache>().delete(listCache.id);
      }
    }
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

final DateTime _fallbackUtcDate = DateTime.fromMillisecondsSinceEpoch(
  0,
  isUtc: true,
);
