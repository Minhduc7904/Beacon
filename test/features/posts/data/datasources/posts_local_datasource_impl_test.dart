import 'package:beacon_app/core/database/app_database.dart';
import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/features/posts/data/datasources/posts_local_datasource_impl.dart';
import 'package:beacon_app/features/posts/data/models/post_media_model.dart';
import 'package:beacon_app/features/posts/data/models/post_model.dart';
import 'package:beacon_app/features/posts/data/models/post_page_model.dart';
import 'package:beacon_app/features/posts/data/models/reaction_summary_model.dart';
import 'package:beacon_app/features/posts/domain/entities/post_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

class FakeAppDatabase implements AppDatabase {
  int readCount = 0;
  int writeCount = 0;

  @override
  Future<T> read<T>(Future<T> Function(Isar isar) action) {
    readCount++;
    throw StateError('read should not be called');
  }

  @override
  Future<T> write<T>(Future<T> Function(Isar isar) action) {
    writeCount++;
    throw StateError('write should not be called');
  }

  @override
  Future<void> clearAll() async {}

  @override
  Future<void> close() async {}
}

void main() {
  group('PostsLocalDatasourceImpl', () {
    test('không đọc database khi listScopeKey rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = PostsLocalDatasourceImpl(database);

      await expectLater(
        datasource.getCachedPosts(listScopeKey: ' '),
        throwsA(isA<CacheException>()),
      );
      expect(database.readCount, 0);
    });

    test('không ghi database khi listScopeKey rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = PostsLocalDatasourceImpl(database);

      await expectLater(
        datasource.upsertPostPage(
          listScopeKey: ' ',
          cacheScopeUserId: 'user-1',
          feedType: 'all',
          page: const PostPageModel(items: [], nextCursor: null),
          isFirstPage: true,
          cachedAtUtc: DateTime.utc(2026, 6, 1),
        ),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });

    test('không ghi database khi cacheScopeUserId rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = PostsLocalDatasourceImpl(database);

      await expectLater(
        datasource.upsertPostPage(
          listScopeKey: 'user-1:all',
          cacheScopeUserId: ' ',
          feedType: 'all',
          page: const PostPageModel(items: [], nextCursor: null),
          isFirstPage: true,
          cachedAtUtc: DateTime.utc(2026, 6, 1),
        ),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });

    test('không ghi database khi postId rỗng lúc xóa cache', () async {
      final database = FakeAppDatabase();
      final datasource = PostsLocalDatasourceImpl(database);

      await expectLater(
        datasource.deletePost(listScopeKey: 'user-1:all', postId: ' '),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });

    test('không ghi database khi update cache với user rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = PostsLocalDatasourceImpl(database);

      await expectLater(
        datasource.updatePostInUserCaches(
          cacheScopeUserId: ' ',
          post: _post(),
          cachedAtUtc: DateTime.utc(2026, 6, 1),
        ),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });

    test('không ghi database khi xóa cache theo user rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = PostsLocalDatasourceImpl(database);

      await expectLater(
        datasource.deletePostFromUserCaches(
          cacheScopeUserId: ' ',
          postId: 'post-1',
        ),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });
  });
}

PostModel _post() {
  return PostModel(
    id: 'post-1',
    ownerUserId: 'user-1',
    owner: null,
    media: const PostMediaModel(
      id: 'media-1',
      url: 'https://example.com/media.jpg',
      type: 'image',
      thumbnailUrl: null,
      durationSeconds: null,
      width: null,
      height: null,
    ),
    caption: null,
    visibility: PostVisibility.friends,
    status: 'published',
    createdAtUtc: DateTime.utc(2026, 6, 1),
    updatedAtUtc: null,
    latitude: null,
    longitude: null,
    dailySafetyRecordId: null,
    dailySafetyRecord: null,
    reactionSummary: const ReactionSummaryModel(totalCount: 0, icons: {}),
    myReaction: null,
  );
}
