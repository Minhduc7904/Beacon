import 'dart:async';

import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/core/messages/app_message_notifier.dart';
import 'package:beacon_app/features/feed/domain/entities/feed_filter.dart';
import 'package:beacon_app/features/feed/domain/entities/feed_reaction.dart';
import 'package:beacon_app/features/feed/presentation/controllers/feed_notifier.dart';
import 'package:beacon_app/features/feed/presentation/controllers/feed_state.dart';
import 'package:beacon_app/features/posts/domain/entities/my_reaction.dart';
import 'package:beacon_app/features/posts/domain/entities/post.dart';
import 'package:beacon_app/features/posts/domain/entities/post_media.dart';
import 'package:beacon_app/features/posts/domain/entities/post_owner.dart';
import 'package:beacon_app/features/posts/domain/entities/post_page.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_detail.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_icon.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_page.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_result.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_user.dart';
import 'package:beacon_app/features/posts/domain/entities/post_visibility.dart';
import 'package:beacon_app/features/posts/domain/entities/reaction_summary.dart';
import 'package:beacon_app/features/posts/domain/usecase/delete_post_reaction_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/delete_post_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/get_feed_posts_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/get_friend_posts_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/get_my_posts_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/get_post_reactions_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/set_post_reaction_icon_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/set_post_reaction_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/subscribe_new_posts_realtime_usecase.dart';
import 'package:beacon_app/features/posts/domain/usecase/update_post_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFeedPostsUseCase extends Mock implements GetFeedPostsUseCase {}

class MockGetMyPostsUseCase extends Mock implements GetMyPostsUseCase {}

class MockGetFriendPostsUseCase extends Mock implements GetFriendPostsUseCase {}

class MockSetPostReactionUseCase extends Mock
    implements SetPostReactionUseCase {}

class MockSetPostReactionIconUseCase extends Mock
    implements SetPostReactionIconUseCase {}

class MockDeletePostReactionUseCase extends Mock
    implements DeletePostReactionUseCase {}

class MockGetPostReactionsUseCase extends Mock
    implements GetPostReactionsUseCase {}

class MockUpdatePostUseCase extends Mock implements UpdatePostUseCase {}

class MockDeletePostUseCase extends Mock implements DeletePostUseCase {}

class MockSubscribeNewPostsRealtimeUseCase extends Mock
    implements SubscribeNewPostsRealtimeUseCase {}

class MockAppMessageNotifier extends Mock implements AppMessageNotifier {}

Post _post({
  String id = 'post-1',
  String ownerUserId = 'owner-1',
  String ownerName = ' Mai Nguyen ',
  String? ownerAvatarUrl = 'https://example.com/avatar.jpg',
  String mediaUrl = 'https://example.com/image.jpg',
  String? thumbnailUrl = ' https://example.com/thumb.jpg ',
  String? caption = 'Caption gốc',
  PostVisibility visibility = PostVisibility.friends,
  DateTime? createdAtUtc,
  ReactionSummary reactionSummary = const ReactionSummary.empty(),
  MyReaction? myReaction,
}) {
  return Post(
    id: id,
    ownerUserId: ownerUserId,
    owner: PostOwner(
      id: ownerUserId,
      displayName: ownerName,
      avatarUrl: ownerAvatarUrl,
    ),
    media: PostMedia(
      id: 'media-$id',
      url: mediaUrl,
      type: 'image',
      thumbnailUrl: thumbnailUrl,
      durationSeconds: null,
      width: 1080,
      height: 1080,
    ),
    caption: caption,
    visibility: visibility,
    status: 'published',
    createdAtUtc: createdAtUtc ?? DateTime.utc(2026, 5, 26, 8),
    updatedAtUtc: null,
    latitude: null,
    longitude: null,
    dailySafetyRecordId: null,
    dailySafetyRecord: null,
    reactionSummary: reactionSummary,
    myReaction: myReaction,
  );
}

ReactionSummary _summary(Map<PostReactionIcon, int> icons) {
  return ReactionSummary(
    totalCount: icons.values.fold<int>(0, (sum, count) => sum + count),
    icons: icons,
  );
}

PostReactionResult _reactionResult({
  String postId = 'post-1',
  MyReaction? myReaction,
  ReactionSummary reactionSummary = const ReactionSummary.empty(),
}) {
  return PostReactionResult(
    postId: postId,
    myReaction: myReaction,
    reactionSummary: reactionSummary,
  );
}

PostReactionPage _reactionPage() {
  return PostReactionPage(
    items: [
      PostReactionDetail(
        reactionId: 'reaction-1',
        icon: 'like',
        reactedAtUtc: DateTime.utc(2026, 5, 26, 9),
        user: const PostReactionUser(
          id: 'user-1',
          displayName: 'Mai Nguyen',
          avatarUrl: null,
        ),
      ),
    ],
    summary: _summary({PostReactionIcon.like: 1}),
    nextCursor: null,
    hasMore: false,
  );
}

void main() {
  late MockGetFeedPostsUseCase getFeedPostsUseCase;
  late MockGetMyPostsUseCase getMyPostsUseCase;
  late MockGetFriendPostsUseCase getFriendPostsUseCase;
  late MockSetPostReactionUseCase setPostReactionUseCase;
  late MockSetPostReactionIconUseCase setPostReactionIconUseCase;
  late MockDeletePostReactionUseCase deletePostReactionUseCase;
  late MockGetPostReactionsUseCase getPostReactionsUseCase;
  late MockUpdatePostUseCase updatePostUseCase;
  late MockDeletePostUseCase deletePostUseCase;
  late MockSubscribeNewPostsRealtimeUseCase subscribeNewPostsRealtimeUseCase;
  late MockAppMessageNotifier messageNotifier;
  late FeedNotifier notifier;

  setUpAll(() {
    registerFallbackValue(
      const SetPostReactionParams(
        postId: 'fallback-post',
        icon: PostReactionIcon.like,
      ),
    );
    registerFallbackValue(
      const SetPostReactionIconParams(postId: 'fallback-post', icon: 'like'),
    );
    registerFallbackValue(
      const DeletePostReactionParams(postId: 'fallback-post'),
    );
    registerFallbackValue(
      const GetPostReactionsParams(postId: 'fallback-post'),
    );
    registerFallbackValue(
      const UpdatePostParams(
        postId: 'fallback-post',
        caption: 'caption',
        visibility: PostVisibility.friends,
      ),
    );
    registerFallbackValue(const DeletePostParams(postId: 'fallback-post'));
  });

  setUp(() {
    getFeedPostsUseCase = MockGetFeedPostsUseCase();
    getMyPostsUseCase = MockGetMyPostsUseCase();
    getFriendPostsUseCase = MockGetFriendPostsUseCase();
    setPostReactionUseCase = MockSetPostReactionUseCase();
    setPostReactionIconUseCase = MockSetPostReactionIconUseCase();
    deletePostReactionUseCase = MockDeletePostReactionUseCase();
    getPostReactionsUseCase = MockGetPostReactionsUseCase();
    updatePostUseCase = MockUpdatePostUseCase();
    deletePostUseCase = MockDeletePostUseCase();
    subscribeNewPostsRealtimeUseCase = MockSubscribeNewPostsRealtimeUseCase();
    messageNotifier = MockAppMessageNotifier();

    when(
      () => subscribeNewPostsRealtimeUseCase.call(onPost: any(named: 'onPost')),
    ).thenAnswer((_) async {});
    when(
      () => subscribeNewPostsRealtimeUseCase.unsubscribe(),
    ).thenReturn(() {});
    when(
      () => getFeedPostsUseCase.cached(limit: any(named: 'limit')),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    when(
      () => getMyPostsUseCase.cached(limit: any(named: 'limit')),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    when(
      () => getFriendPostsUseCase.cached(
        friendId: any(named: 'friendId'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => const Left(NetworkFailure()));

    notifier = FeedNotifier(
      getFeedPostsUseCase,
      getMyPostsUseCase,
      getFriendPostsUseCase,
      setPostReactionUseCase,
      setPostReactionIconUseCase,
      deletePostReactionUseCase,
      getPostReactionsUseCase,
      updatePostUseCase,
      deletePostUseCase,
      subscribeNewPostsRealtimeUseCase,
      messageNotifier,
    );
  });

  void stubFeedPage(PostPage page) {
    when(
      () => getFeedPostsUseCase(
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => Right(page));
  }

  Future<void> seedLoadedPosts(List<Post> posts, {String? nextCursor}) async {
    stubFeedPage(PostPage(items: posts, nextCursor: nextCursor));

    await notifier.load();

    clearInteractions(getFeedPostsUseCase);
    clearInteractions(messageNotifier);
  }

  group('FeedNotifier initial', () {
    test('khởi tạo với FeedState mặc định', () {
      expect(notifier.state.status, FeedStatus.initial);
      expect(notifier.state.viewMode, FeedViewMode.single);
      expect(notifier.state.filter, const FeedFilter.all());
      expect(notifier.state.posts, isEmpty);
      expect(notifier.state.nextCursor, isNull);
      expect(notifier.state.hasMore, isFalse);
      expect(notifier.state.isLoadingMore, isFalse);
      expect(notifier.state.errorMessage, isNull);
      expect(notifier.state.postReactionPages, isEmpty);
      expect(notifier.state.loadingReactionPostIds, isEmpty);
    });
  });

  group('FeedNotifier load', () {
    test(
      'load all success gọi getFeedPosts và map Post sang FeedPost',
      () async {
        final pageCompleter = Completer<Either<Failure, PostPage>>();
        final post = _post(
          reactionSummary: _summary({
            PostReactionIcon.heart: 2,
            PostReactionIcon.like: 0,
          }),
          myReaction: const MyReaction(icon: PostReactionIcon.heart),
        );
        when(
          () => getFeedPostsUseCase(
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) => pageCompleter.future);

        final future = notifier.load();

        await Future<void>.delayed(Duration.zero);
        expect(notifier.state.status, FeedStatus.loading);
        expect(notifier.state.posts, isEmpty);

        pageCompleter.complete(
          Right(PostPage(items: [post], nextCursor: 'cursor-1')),
        );
        await future;

        verify(() => getFeedPostsUseCase(cursor: null, limit: 20)).called(1);
        expect(notifier.state.status, FeedStatus.loaded);
        expect(notifier.state.hasMore, isTrue);
        expect(notifier.state.nextCursor, 'cursor-1');
        expect(notifier.state.errorMessage, isNull);

        final feedPost = notifier.state.posts.single;
        expect(feedPost.id, post.id);
        expect(feedPost.authorName, 'Mai Nguyen');
        expect(feedPost.imageUrl, 'https://example.com/thumb.jpg');
        expect(feedPost.caption, post.caption);
        expect(feedPost.createdAt, DateTime.utc(2026, 5, 26, 15));
        expect(feedPost.reactionCounts, equals({ReactionType.heart: 2}));
        expect(feedPost.myReaction, ReactionType.heart);
      },
    );

    test('load failure phát message và chuyển sang FeedStatus.error', () async {
      const failure = ServerFailure(message: 'Không tải được bài viết');
      when(
        () => getFeedPostsUseCase(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.load();

      verify(() => messageNotifier.addError(failure.message)).called(1);
      expect(notifier.state.status, FeedStatus.error);
      expect(notifier.state.posts, isEmpty);
      expect(notifier.state.hasMore, isFalse);
      expect(notifier.state.nextCursor, isNull);
      expect(notifier.state.errorMessage, failure.message);
    });

    test('load ưu tiên cache rồi refresh remote mới nhất', () async {
      final remoteCompleter = Completer<Either<Failure, PostPage>>();
      final cachedPost = _post(
        id: 'post-1',
        mediaUrl: 'https://example.com/cached.jpg',
        thumbnailUrl: 'https://example.com/cached-thumb.jpg',
      );
      final remotePost = _post(
        id: 'post-1',
        mediaUrl: 'https://example.com/remote.jpg',
        thumbnailUrl: 'https://example.com/remote-thumb.jpg',
      );
      when(
        () => getFeedPostsUseCase.cached(limit: any(named: 'limit')),
      ).thenAnswer(
        (_) async => Right(PostPage(items: [cachedPost], nextCursor: null)),
      );
      when(
        () => getFeedPostsUseCase(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) => remoteCompleter.future);

      final future = notifier.load();

      await Future<void>.delayed(Duration.zero);
      expect(notifier.state.status, FeedStatus.loaded);
      expect(notifier.state.isRefreshing, isTrue);
      expect(
        notifier.state.posts.single.imageUrl,
        'https://example.com/cached-thumb.jpg',
      );

      remoteCompleter.complete(
        Right(PostPage(items: [remotePost], nextCursor: null)),
      );
      await future;

      expect(notifier.state.status, FeedStatus.loaded);
      expect(notifier.state.isRefreshing, isFalse);
      expect(
        notifier.state.posts.single.imageUrl,
        'https://example.com/remote-thumb.jpg',
      );
    });
  });

  group('FeedNotifier loadMore', () {
    test('loadMore success append posts và cập nhật cursor', () async {
      await seedLoadedPosts([_post(id: 'post-1')], nextCursor: 'cursor-1');
      final moreCompleter = Completer<Either<Failure, PostPage>>();
      when(
        () => getFeedPostsUseCase(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) => moreCompleter.future);

      final future = notifier.loadMore();

      expect(notifier.state.isLoadingMore, isTrue);

      moreCompleter.complete(
        Right(
          PostPage(
            items: [_post(id: 'post-2')],
            nextCursor: 'cursor-2',
          ),
        ),
      );
      await future;

      verify(
        () => getFeedPostsUseCase(cursor: 'cursor-1', limit: 20),
      ).called(1);
      expect(notifier.state.isLoadingMore, isFalse);
      expect(notifier.state.hasMore, isTrue);
      expect(notifier.state.nextCursor, 'cursor-2');
      expect(
        notifier.state.posts.map((post) => post.id),
        orderedEquals(['post-1', 'post-2']),
      );
    });

    test('loadMore failure giữ posts cũ và set errorMessage', () async {
      final existingPost = _post(id: 'post-1');
      await seedLoadedPosts([existingPost], nextCursor: 'cursor-1');
      const failure = NetworkFailure(message: 'Mất kết nối');
      when(
        () => getFeedPostsUseCase(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.loadMore();

      verify(() => messageNotifier.addError(failure.message)).called(1);
      expect(notifier.state.isLoadingMore, isFalse);
      expect(notifier.state.posts.single.id, existingPost.id);
      expect(notifier.state.errorMessage, failure.message);
    });

    test('loadMore không gọi usecase khi hasMore false', () async {
      await seedLoadedPosts([_post(id: 'post-1')]);

      await notifier.loadMore();

      verifyNever(
        () => getFeedPostsUseCase(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
    });
  });

  group('FeedNotifier filter/view mode', () {
    test('updateFilter me gọi getMyPosts và reset feed', () async {
      when(
        () => getMyPostsUseCase(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async =>
            Right(PostPage(items: [_post(id: 'me-post')], nextCursor: null)),
      );

      await notifier.updateFilter(const FeedFilter.me());

      verify(() => getMyPostsUseCase(cursor: null, limit: 20)).called(1);
      expect(notifier.state.filter, const FeedFilter.me());
      expect(notifier.state.status, FeedStatus.loaded);
      expect(notifier.state.posts.single.id, 'me-post');
    });

    test('updateFilter friend trim friendId khi gọi usecase', () async {
      when(
        () => getFriendPostsUseCase(
          friendId: any(named: 'friendId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => Right(
          PostPage(items: [_post(id: 'friend-post')], nextCursor: null),
        ),
      );

      await notifier.updateFilter(
        const FeedFilter.friend(friendId: '  friend-1  ', friendName: 'Mai'),
      );

      verify(
        () => getFriendPostsUseCase(
          friendId: 'friend-1',
          cursor: null,
          limit: 20,
        ),
      ).called(1);
      expect(notifier.state.filter.type, FeedFilterType.friend);
      expect(notifier.state.posts.single.id, 'friend-post');
    });

    test('updateViewMode chỉ cập nhật state local', () {
      notifier.updateViewMode(FeedViewMode.grid);

      expect(notifier.state.viewMode, FeedViewMode.grid);
      verifyNever(
        () => getFeedPostsUseCase(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
    });
  });

  group('FeedNotifier reaction', () {
    test('toggleReaction success gọi set reaction và cập nhật post', () async {
      await seedLoadedPosts([_post(id: 'post-1')]);
      final result = _reactionResult(
        myReaction: const MyReaction(icon: PostReactionIcon.like),
        reactionSummary: _summary({PostReactionIcon.like: 1}),
      );
      when(
        () => setPostReactionUseCase.call(any()),
      ).thenAnswer((_) async => Right(result));

      await notifier.toggleReaction('post-1', ReactionType.like);

      final captured =
          verify(
                () => setPostReactionUseCase.call(captureAny()),
              ).captured.single
              as SetPostReactionParams;
      expect(captured.postId, 'post-1');
      expect(captured.icon, PostReactionIcon.like);
      verifyNever(() => deletePostReactionUseCase.call(any()));
      expect(notifier.state.posts.single.myReaction, ReactionType.like);
      expect(
        notifier.state.posts.single.reactionCounts,
        equals({ReactionType.like: 1}),
      );
    });

    test(
      'toggleReaction cùng reaction thì gọi delete và clear reaction',
      () async {
        await seedLoadedPosts([
          _post(
            id: 'post-1',
            reactionSummary: _summary({PostReactionIcon.like: 1}),
            myReaction: const MyReaction(icon: PostReactionIcon.like),
          ),
        ]);
        when(
          () => deletePostReactionUseCase.call(any()),
        ).thenAnswer((_) async => Right(_reactionResult()));

        await notifier.toggleReaction('post-1', ReactionType.like);

        verify(() => deletePostReactionUseCase.call(any())).called(1);
        verifyNever(() => setPostReactionUseCase.call(any()));
        expect(notifier.state.posts.single.myReaction, isNull);
        expect(notifier.state.posts.single.reactionCounts, isEmpty);
      },
    );

    test('setReactionIcon success trả true và cập nhật post', () async {
      await seedLoadedPosts([_post(id: 'post-1')]);
      final result = _reactionResult(
        myReaction: const MyReaction(icon: PostReactionIcon.heart),
        reactionSummary: _summary({PostReactionIcon.heart: 2}),
      );
      when(
        () => setPostReactionIconUseCase.call(any()),
      ).thenAnswer((_) async => Right(result));

      final success = await notifier.setReactionIcon('post-1', 'heart');

      final captured =
          verify(
                () => setPostReactionIconUseCase.call(captureAny()),
              ).captured.single
              as SetPostReactionIconParams;
      expect(success, isTrue);
      expect(captured.postId, 'post-1');
      expect(captured.icon, 'heart');
      expect(notifier.state.posts.single.myReaction, ReactionType.heart);
      expect(
        notifier.state.posts.single.reactionCounts,
        equals({ReactionType.heart: 2}),
      );
    });

    test('setReactionIcon failure trả false và giữ post cũ', () async {
      await seedLoadedPosts([_post(id: 'post-1')]);
      const failure = ServerFailure(message: 'Không react được');
      when(
        () => setPostReactionIconUseCase.call(any()),
      ).thenAnswer((_) async => const Left(failure));

      final success = await notifier.setReactionIcon('post-1', 'heart');

      verify(() => messageNotifier.addError(failure.message)).called(1);
      expect(success, isFalse);
      expect(notifier.state.posts.single.myReaction, isNull);
      expect(notifier.state.posts.single.reactionCounts, isEmpty);
    });
  });

  group('FeedNotifier update/delete post', () {
    test('updatePost success thay caption/visibility đúng post', () async {
      await seedLoadedPosts([_post(id: 'post-1')]);
      final updated = _post(
        id: 'post-1',
        caption: 'Caption mới',
        visibility: PostVisibility.private,
      );
      when(
        () => updatePostUseCase.call(any()),
      ).thenAnswer((_) async => Right(updated));

      await notifier.updatePost(
        postId: 'post-1',
        caption: 'Caption mới',
        visibility: PostVisibility.private,
      );

      final captured =
          verify(() => updatePostUseCase.call(captureAny())).captured.single
              as UpdatePostParams;
      expect(captured.postId, 'post-1');
      expect(captured.caption, 'Caption mới');
      expect(captured.visibility, PostVisibility.private);
      verify(
        () => messageNotifier.addSuccess('Đã cập nhật bài đăng'),
      ).called(1);
      expect(notifier.state.posts.single.caption, 'Caption mới');
      expect(notifier.state.posts.single.visibility, PostVisibility.private);
    });

    test('updatePost failure phát error và giữ post cũ', () async {
      await seedLoadedPosts([_post(id: 'post-1', caption: 'Caption cũ')]);
      const failure = ServerFailure(message: 'Không cập nhật được bài đăng');
      when(
        () => updatePostUseCase.call(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.updatePost(
        postId: 'post-1',
        caption: 'Caption mới',
        visibility: PostVisibility.private,
      );

      verify(() => messageNotifier.addError(failure.message)).called(1);
      expect(notifier.state.posts.single.caption, 'Caption cũ');
      expect(notifier.state.posts.single.visibility, PostVisibility.friends);
    });

    test('deletePost success xóa đúng post khỏi state', () async {
      await seedLoadedPosts([_post(id: 'post-1'), _post(id: 'post-2')]);
      when(
        () => deletePostUseCase.call(any()),
      ).thenAnswer((_) async => const Right(true));

      await notifier.deletePost('post-1');

      final captured =
          verify(() => deletePostUseCase.call(captureAny())).captured.single
              as DeletePostParams;
      expect(captured.postId, 'post-1');
      verify(() => messageNotifier.addSuccess('Đã xóa bài đăng')).called(1);
      expect(
        notifier.state.posts.map((post) => post.id),
        orderedEquals(['post-2']),
      );
    });

    test('deletePost failure phát error và giữ danh sách cũ', () async {
      await seedLoadedPosts([_post(id: 'post-1'), _post(id: 'post-2')]);
      const failure = ServerFailure(message: 'Không xóa được bài đăng');
      when(
        () => deletePostUseCase.call(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.deletePost('post-1');

      verify(() => messageNotifier.addError(failure.message)).called(1);
      expect(
        notifier.state.posts.map((post) => post.id),
        orderedEquals(['post-1', 'post-2']),
      );
    });
  });

  group('FeedNotifier post reactions page', () {
    test(
      'loadPostReactions success cập nhật page và clear loading id',
      () async {
        final pageCompleter = Completer<Either<Failure, PostReactionPage>>();
        final page = _reactionPage();
        when(
          () => getPostReactionsUseCase.call(any()),
        ).thenAnswer((_) => pageCompleter.future);

        final future = notifier.loadPostReactions('post-1');

        expect(notifier.state.loadingReactionPostIds, contains('post-1'));

        pageCompleter.complete(Right(page));
        await future;

        final captured =
            verify(
                  () => getPostReactionsUseCase.call(captureAny()),
                ).captured.single
                as GetPostReactionsParams;
        expect(captured.postId, 'post-1');
        expect(captured.limit, 20);
        expect(captured.cursor, isNull);
        expect(notifier.state.postReactionPages['post-1'], same(page));
        expect(
          notifier.state.loadingReactionPostIds,
          isNot(contains('post-1')),
        );
      },
    );

    test('loadPostReactions failure chỉ clear loading id', () async {
      const failure = ServerFailure(message: 'Không tải được reactions');
      when(
        () => getPostReactionsUseCase.call(any()),
      ).thenAnswer((_) async => const Left(failure));

      await notifier.loadPostReactions('post-1');

      expect(notifier.state.postReactionPages, isEmpty);
      expect(notifier.state.loadingReactionPostIds, isEmpty);
      verifyNever(() => messageNotifier.addError(any()));
    });
  });
}
