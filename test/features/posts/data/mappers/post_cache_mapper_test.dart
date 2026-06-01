import 'package:beacon_app/features/posts/data/mappers/post_cache_mapper.dart';
import 'package:beacon_app/features/posts/data/models/post_media_model.dart';
import 'package:beacon_app/features/posts/data/models/post_model.dart';
import 'package:beacon_app/features/posts/data/models/reaction_summary_model.dart';
import 'package:beacon_app/features/posts/domain/entities/post_visibility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostCacheMapper', () {
    test('tạo key cache theo user scope, feed type và friend id', () {
      expect(
        postListScopeKey(
          cacheScopeUserId: ' user-1 ',
          feedType: ' friend ',
          friendId: ' friend-1 ',
        ),
        'user-1:friend:friend-1',
      );
      expect(
        postCacheKey(listScopeKey: 'user-1:all', postId: ' post-1 '),
        'user-1:all:post-1',
      );
    });

    test('roundtrip Post qua cache giữ URL media mới nhất', () {
      final post = PostModel(
        id: 'post-1',
        ownerUserId: 'user-1',
        owner: null,
        media: const PostMediaModel(
          id: 'media-1',
          url: 'https://example.com/media-new.jpg',
          type: 'image',
          thumbnailUrl: 'https://example.com/thumb-new.jpg',
          durationSeconds: null,
          width: 1080,
          height: 1080,
        ),
        caption: 'Caption',
        visibility: PostVisibility.friends,
        status: 'published',
        createdAtUtc: DateTime.utc(2026, 6, 1, 1),
        updatedAtUtc: DateTime.utc(2026, 6, 1, 2),
        latitude: 10.5,
        longitude: 106.7,
        dailySafetyRecordId: null,
        dailySafetyRecord: null,
        reactionSummary: const ReactionSummaryModel(totalCount: 0, icons: {}),
        myReaction: null,
      );

      final cache = post.toCache(
        listScopeKey: 'user-1:all',
        cacheScopeUserId: 'user-1',
        sortOrder: 2,
        cachedAtUtc: DateTime.utc(2026, 6, 1, 3),
      );
      final restored = cache.toDomain();

      expect(cache.cacheKey, 'user-1:all:post-1');
      expect(cache.sortOrder, 2);
      expect(restored.id, post.id);
      expect(restored.media.url, 'https://example.com/media-new.jpg');
      expect(restored.media.thumbnailUrl, 'https://example.com/thumb-new.jpg');
      expect(restored.updatedAtUtc, DateTime.utc(2026, 6, 1, 2));
    });
  });
}
