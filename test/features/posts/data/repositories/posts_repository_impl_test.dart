import 'package:beacon_app/core/cache/current_user_cache_scope.dart';
import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/core/network/network_info.dart';
import 'package:beacon_app/features/posts/data/datasources/posts_local_datasource.dart';
import 'package:beacon_app/features/posts/data/datasources/posts_remote_datasource.dart';
import 'package:beacon_app/features/posts/data/models/post_media_model.dart';
import 'package:beacon_app/features/posts/data/models/post_model.dart';
import 'package:beacon_app/features/posts/data/models/post_page_model.dart';
import 'package:beacon_app/features/posts/data/models/post_reaction_page_model.dart';
import 'package:beacon_app/features/posts/data/models/post_reaction_result_model.dart';
import 'package:beacon_app/features/posts/data/models/reaction_summary_model.dart';
import 'package:beacon_app/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:beacon_app/features/posts/domain/entities/post_reaction_icon.dart';
import 'package:beacon_app/features/posts/domain/entities/post_visibility.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsRemoteDatasource extends Mock implements PostsRemoteDatasource {}

class MockPostsLocalDatasource extends Mock implements PostsLocalDatasource {}

class MockCurrentUserCacheScope extends Mock implements CurrentUserCacheScope {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

PostModel _postModel({
  String id = 'post-1',
  String? caption = 'Caption',
  PostVisibility visibility = PostVisibility.friends,
  String mediaUrl = 'https://example.com/media.jpg',
  String? thumbnailUrl,
  DateTime? updatedAtUtc,
}) {
  return PostModel(
    id: id,
    ownerUserId: 'user-1',
    owner: null,
    media: PostMediaModel(
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
    createdAtUtc: DateTime.utc(2026, 5, 26),
    updatedAtUtc: updatedAtUtc,
    latitude: 10.5,
    longitude: 106.7,
    dailySafetyRecordId: null,
    dailySafetyRecord: null,
    reactionSummary: const ReactionSummaryModel(totalCount: 0, icons: {}),
    myReaction: null,
  );
}

PostPageModel _postPageModel({List<PostModel>? items, String? nextCursor}) {
  return PostPageModel(items: items ?? [_postModel()], nextCursor: nextCursor);
}

PostReactionResultModel _reactionResultModel({
  String postId = 'post-1',
  PostReactionIcon icon = PostReactionIcon.heart,
}) {
  return PostReactionResultModel(
    postId: postId,
    myReaction: null,
    reactionSummary: ReactionSummaryModel(totalCount: 1, icons: {icon: 1}),
  );
}

PostReactionPageModel _reactionPageModel() {
  return const PostReactionPageModel(
    items: [],
    summary: ReactionSummaryModel(totalCount: 0, icons: {}),
    nextCursor: null,
    hasMore: false,
  );
}

void _stubNetwork(MockNetworkInfo networkInfo, bool isConnected) {
  when(() => networkInfo.isConnected).thenAnswer((_) async => isConnected);
}

void _expectLeft<T>(Either<Failure, T> result, Matcher matcher) {
  result.fold(
    (failure) => expect(failure, matcher),
    (_) => fail('Expected Left'),
  );
}

void _expectRightSame<T>(Either<Failure, T> result, T expected) {
  result.fold(
    (_) => fail('Expected Right'),
    (actual) => expect(actual, same(expected)),
  );
}

void main() {
  late MockPostsRemoteDatasource remoteDatasource;
  late MockPostsLocalDatasource localDatasource;
  late MockCurrentUserCacheScope currentUserCacheScope;
  late MockNetworkInfo networkInfo;
  late PostsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_postPageModel());
    registerFallbackValue(_postModel());
  });

  setUp(() {
    remoteDatasource = MockPostsRemoteDatasource();
    localDatasource = MockPostsLocalDatasource();
    currentUserCacheScope = MockCurrentUserCacheScope();
    networkInfo = MockNetworkInfo();
    when(
      () => currentUserCacheScope.getCurrentUserId(),
    ).thenAnswer((_) async => null);
    repository = PostsRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
      currentUserCacheScope: currentUserCacheScope,
      networkInfo: networkInfo,
    );
  });

  group('PostsRepositoryImpl network guard', () {
    test('offline trả NetworkFailure và không gọi remote', () async {
      _stubNetwork(networkInfo, false);

      final feed = await repository.getFeedPosts(cursor: 'cursor-1', limit: 10);
      final myPosts = await repository.getMyPosts(cursor: 'cursor-1', limit: 10);
      final friendPosts = await repository.getFriendPosts(
        friendId: 'friend-1',
        cursor: 'cursor-1',
        limit: 10,
      );
      final create = await repository.createPost(
        mediaId: 'media-1',
        caption: 'Caption',
        visibility: PostVisibility.private,
        latitude: 10.5,
        longitude: 106.7,
      );
      final update = await repository.updatePost(
        postId: 'post-1',
        caption: 'Caption mới',
        visibility: PostVisibility.private,
      );
      final delete = await repository.deletePost(postId: 'post-1');
      final setReaction = await repository.setReaction(
        postId: 'post-1',
        icon: PostReactionIcon.like,
      );
      final setReactionIcon = await repository.setReactionIcon(
        postId: 'post-1',
        icon: 'heart',
      );
      final deleteReaction = await repository.deleteReaction(postId: 'post-1');
      final reactions = await repository.getReactions(
        postId: 'post-1',
        cursor: 'cursor-1',
        limit: 10,
      );

      final networkFailure = isA<NetworkFailure>().having(
        (failure) => failure.message,
        'message',
        'No internet connection',
      );
      _expectLeft(feed, networkFailure);
      _expectLeft(myPosts, networkFailure);
      _expectLeft(friendPosts, networkFailure);
      _expectLeft(create, networkFailure);
      _expectLeft(update, networkFailure);
      _expectLeft(delete, networkFailure);
      _expectLeft(setReaction, networkFailure);
      _expectLeft(setReactionIcon, networkFailure);
      _expectLeft(deleteReaction, networkFailure);
      _expectLeft(reactions, networkFailure);
      verifyNever(
        () => remoteDatasource.getFeedPosts(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
      verifyNever(
        () => remoteDatasource.getMyPosts(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
      verifyNever(
        () => remoteDatasource.getFriendPosts(
          friendId: any(named: 'friendId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
      verifyNever(
        () => remoteDatasource.createPost(
          mediaId: any(named: 'mediaId'),
          caption: any(named: 'caption'),
          visibility: any(named: 'visibility'),
          latitude: any(named: 'latitude'),
          longitude: any(named: 'longitude'),
        ),
      );
      verifyNever(
        () => remoteDatasource.updatePost(
          postId: any(named: 'postId'),
          caption: any(named: 'caption'),
          visibility: any(named: 'visibility'),
        ),
      );
      verifyNever(
        () => remoteDatasource.deletePost(postId: any(named: 'postId')),
      );
      verifyNever(
        () => remoteDatasource.setReactionIcon(
          postId: any(named: 'postId'),
          icon: any(named: 'icon'),
        ),
      );
      verifyNever(
        () => remoteDatasource.deleteReaction(postId: any(named: 'postId')),
      );
      verifyNever(
        () => remoteDatasource.getReactions(
          postId: any(named: 'postId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
    });
  });

  group('PostsRepositoryImpl get/list posts', () {
    test('getFeedPosts online gọi remote đúng params và trả page', () async {
      _stubNetwork(networkInfo, true);
      final page = _postPageModel(nextCursor: 'next-1');
      when(
        () => remoteDatasource.getFeedPosts(cursor: 'cursor-1', limit: 20),
      ).thenAnswer((_) async => page);

      final result = await repository.getFeedPosts(
        cursor: 'cursor-1',
        limit: 20,
      );

      _expectRightSame(result, page);
      verify(
        () => remoteDatasource.getFeedPosts(cursor: 'cursor-1', limit: 20),
      ).called(1);
    });

    test('getMyPosts online trả empty page đúng theo remote', () async {
      _stubNetwork(networkInfo, true);
      const page = PostPageModel(items: [], nextCursor: null);
      when(
        () => remoteDatasource.getMyPosts(cursor: null, limit: null),
      ).thenAnswer((_) async => page);

      final result = await repository.getMyPosts();

      _expectRightSame(result, page);
      verify(
        () => remoteDatasource.getMyPosts(cursor: null, limit: null),
      ).called(1);
    });

    test('getFriendPosts online gọi remote đúng params và trả page', () async {
      _stubNetwork(networkInfo, true);
      final page = _postPageModel();
      when(
        () => remoteDatasource.getFriendPosts(
          friendId: 'friend-1',
          cursor: 'cursor-1',
          limit: 10,
        ),
      ).thenAnswer((_) async => page);

      final result = await repository.getFriendPosts(
        friendId: 'friend-1',
        cursor: 'cursor-1',
        limit: 10,
      );

      _expectRightSame(result, page);
      verify(
        () => remoteDatasource.getFriendPosts(
          friendId: 'friend-1',
          cursor: 'cursor-1',
          limit: 10,
        ),
      ).called(1);
    });

    test('remote exception của getFeedPosts được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.getFeedPosts(cursor: null, limit: null),
      ).thenThrow(const ServerException(message: 'Không tải được feed'));

      final result = await repository.getFeedPosts();

      _expectLeft(
        result,
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'Không tải được feed',
        ),
      );
    });

    test('getFeedPosts online lưu page remote vào cache theo user scope', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => currentUserCacheScope.getCurrentUserId(),
      ).thenAnswer((_) async => 'user-1');
      final page = _postPageModel(nextCursor: 'next-1');
      when(
        () => remoteDatasource.getFeedPosts(cursor: null, limit: 20),
      ).thenAnswer((_) async => page);
      when(
        () => localDatasource.upsertPostPage(
          listScopeKey: any(named: 'listScopeKey'),
          cacheScopeUserId: any(named: 'cacheScopeUserId'),
          feedType: any(named: 'feedType'),
          friendId: any(named: 'friendId'),
          page: any(named: 'page'),
          isFirstPage: any(named: 'isFirstPage'),
          cachedAtUtc: any(named: 'cachedAtUtc'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.getFeedPosts(limit: 20);

      _expectRightSame(result, page);
      verify(
        () => localDatasource.upsertPostPage(
          listScopeKey: 'user-1:all',
          cacheScopeUserId: 'user-1',
          feedType: 'all',
          friendId: null,
          page: page,
          isFirstPage: true,
          cachedAtUtc: any(named: 'cachedAtUtc'),
        ),
      ).called(1);
    });

    test('getFeedPosts offline có cache thì trả cache và không gọi remote', () async {
      _stubNetwork(networkInfo, false);
      when(
        () => currentUserCacheScope.getCurrentUserId(),
      ).thenAnswer((_) async => 'user-1');
      final cachedPage = _postPageModel(
        items: [
          _postModel(
            id: 'post-1',
            mediaUrl: 'https://example.com/cached.jpg',
            thumbnailUrl: 'https://example.com/cached-thumb.jpg',
          ),
        ],
      );
      when(
        () => localDatasource.getCachedPosts(listScopeKey: 'user-1:all'),
      ).thenAnswer((_) async => cachedPage);

      final result = await repository.getFeedPosts(limit: 20);

      _expectRightSame(result, cachedPage);
      verify(
        () => localDatasource.getCachedPosts(listScopeKey: 'user-1:all'),
      ).called(1);
      verifyNever(
        () => remoteDatasource.getFeedPosts(
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      );
    });
  });

  group('PostsRepositoryImpl createPost', () {
    test('online gọi remote đúng params và truyền visibility.value', () async {
      _stubNetwork(networkInfo, true);
      final post = _postModel(visibility: PostVisibility.private);
      when(
        () => remoteDatasource.createPost(
          mediaId: 'media-1',
          caption: 'Caption',
          visibility: 'private',
          latitude: 10.5,
          longitude: 106.7,
        ),
      ).thenAnswer((_) async => post);

      final result = await repository.createPost(
        mediaId: 'media-1',
        caption: 'Caption',
        visibility: PostVisibility.private,
        latitude: 10.5,
        longitude: 106.7,
      );

      _expectRightSame(result, post);
      verify(
        () => remoteDatasource.createPost(
          mediaId: 'media-1',
          caption: 'Caption',
          visibility: 'private',
          latitude: 10.5,
          longitude: 106.7,
        ),
      ).called(1);
    });

    test('remote exception của createPost được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.createPost(
          mediaId: 'media-1',
          caption: null,
          visibility: 'friends',
          latitude: null,
          longitude: null,
        ),
      ).thenThrow(const ServerException(message: 'Tạo bài viết thất bại'));

      final result = await repository.createPost(
        mediaId: 'media-1',
        visibility: PostVisibility.friends,
      );

      _expectLeft(
        result,
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'Tạo bài viết thất bại',
        ),
      );
    });
  });

  group('PostsRepositoryImpl updatePost', () {
    test('online gọi remote đúng postId và visibility.value', () async {
      _stubNetwork(networkInfo, true);
      final post = _postModel(caption: 'Caption mới');
      when(
        () => remoteDatasource.updatePost(
          postId: 'post-1',
          caption: 'Caption mới',
          visibility: 'private',
        ),
      ).thenAnswer((_) async => post);

      final result = await repository.updatePost(
        postId: 'post-1',
        caption: 'Caption mới',
        visibility: PostVisibility.private,
      );

      _expectRightSame(result, post);
      verify(
        () => remoteDatasource.updatePost(
          postId: 'post-1',
          caption: 'Caption mới',
          visibility: 'private',
        ),
      ).called(1);
    });

    test('remote exception của updatePost được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.updatePost(
          postId: 'post-1',
          caption: null,
          visibility: null,
        ),
      ).thenThrow(const UnauthorizedException(message: 'Không có quyền sửa'));

      final result = await repository.updatePost(postId: 'post-1');

      _expectLeft(
        result,
        isA<UnauthorizedFailure>().having(
          (failure) => failure.message,
          'message',
          'Không có quyền sửa',
        ),
      );
    });

    test('updatePost online success cập nhật cache local theo user scope', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => currentUserCacheScope.getCurrentUserId(),
      ).thenAnswer((_) async => 'user-1');
      final post = _postModel(
        caption: 'Caption mới',
        mediaUrl: 'https://example.com/media-new.jpg',
        thumbnailUrl: 'https://example.com/thumb-new.jpg',
      );
      when(
        () => remoteDatasource.updatePost(
          postId: 'post-1',
          caption: 'Caption mới',
          visibility: 'friends',
        ),
      ).thenAnswer((_) async => post);
      when(
        () => localDatasource.updatePostInUserCaches(
          cacheScopeUserId: any(named: 'cacheScopeUserId'),
          post: any(named: 'post'),
          cachedAtUtc: any(named: 'cachedAtUtc'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.updatePost(
        postId: 'post-1',
        caption: 'Caption mới',
        visibility: PostVisibility.friends,
      );

      _expectRightSame(result, post);
      verify(
        () => localDatasource.updatePostInUserCaches(
          cacheScopeUserId: 'user-1',
          post: post,
          cachedAtUtc: any(named: 'cachedAtUtc'),
        ),
      ).called(1);
    });
  });

  group('PostsRepositoryImpl deletePost', () {
    test('online gọi remote đúng postId và trả true', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.deletePost(postId: 'post-1'),
      ).thenAnswer((_) async {});

      final result = await repository.deletePost(postId: 'post-1');

      result.fold(
        (_) => fail('Expected Right'),
        (isDeleted) => expect(isDeleted, isTrue),
      );
      verify(() => remoteDatasource.deletePost(postId: 'post-1')).called(1);
    });

    test('remote exception của deletePost được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.deletePost(postId: 'post-1'),
      ).thenThrow(const ServerException(message: 'Xóa bài viết thất bại'));

      final result = await repository.deletePost(postId: 'post-1');

      _expectLeft(
        result,
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'Xóa bài viết thất bại',
        ),
      );
    });

    test('deletePost online success xóa post khỏi cache local theo user scope', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => currentUserCacheScope.getCurrentUserId(),
      ).thenAnswer((_) async => 'user-1');
      when(
        () => remoteDatasource.deletePost(postId: 'post-1'),
      ).thenAnswer((_) async {});
      when(
        () => localDatasource.deletePostFromUserCaches(
          cacheScopeUserId: any(named: 'cacheScopeUserId'),
          postId: any(named: 'postId'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.deletePost(postId: 'post-1');

      result.fold(
        (_) => fail('Expected Right'),
        (isDeleted) => expect(isDeleted, isTrue),
      );
      verify(
        () => localDatasource.deletePostFromUserCaches(
          cacheScopeUserId: 'user-1',
          postId: 'post-1',
        ),
      ).called(1);
    });
  });

  group('PostsRepositoryImpl reaction', () {
    test('setReaction gọi remote setReactionIcon bằng enum value', () async {
      _stubNetwork(networkInfo, true);
      final reactionResult = _reactionResultModel(icon: PostReactionIcon.like);
      when(
        () => remoteDatasource.setReactionIcon(
          postId: 'post-1',
          icon: 'like',
        ),
      ).thenAnswer((_) async => reactionResult);

      final result = await repository.setReaction(
        postId: 'post-1',
        icon: PostReactionIcon.like,
      );

      _expectRightSame(result, reactionResult);
      verify(
        () => remoteDatasource.setReactionIcon(
          postId: 'post-1',
          icon: 'like',
        ),
      ).called(1);
    });

    test('setReactionIcon gọi remote đúng icon string', () async {
      _stubNetwork(networkInfo, true);
      final reactionResult = _reactionResultModel();
      when(
        () => remoteDatasource.setReactionIcon(
          postId: 'post-1',
          icon: 'custom',
        ),
      ).thenAnswer((_) async => reactionResult);

      final result = await repository.setReactionIcon(
        postId: 'post-1',
        icon: 'custom',
      );

      _expectRightSame(result, reactionResult);
      verify(
        () => remoteDatasource.setReactionIcon(
          postId: 'post-1',
          icon: 'custom',
        ),
      ).called(1);
    });

    test('deleteReaction gọi remote đúng postId', () async {
      _stubNetwork(networkInfo, true);
      final reactionResult = _reactionResultModel();
      when(
        () => remoteDatasource.deleteReaction(postId: 'post-1'),
      ).thenAnswer((_) async => reactionResult);

      final result = await repository.deleteReaction(postId: 'post-1');

      _expectRightSame(result, reactionResult);
      verify(
        () => remoteDatasource.deleteReaction(postId: 'post-1'),
      ).called(1);
    });

    test('remote exception của reaction được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.setReactionIcon(
          postId: 'post-1',
          icon: 'heart',
        ),
      ).thenThrow(const NetworkException(message: 'Mất kết nối'));

      final result = await repository.setReactionIcon(
        postId: 'post-1',
        icon: 'heart',
      );

      _expectLeft(
        result,
        isA<NetworkFailure>().having(
          (failure) => failure.message,
          'message',
          'Mất kết nối',
        ),
      );
    });
  });

  group('PostsRepositoryImpl getReactions', () {
    test('online gọi remote đúng params và trả page', () async {
      _stubNetwork(networkInfo, true);
      final page = _reactionPageModel();
      when(
        () => remoteDatasource.getReactions(
          postId: 'post-1',
          cursor: 'cursor-1',
          limit: 10,
        ),
      ).thenAnswer((_) async => page);

      final result = await repository.getReactions(
        postId: 'post-1',
        cursor: 'cursor-1',
        limit: 10,
      );

      _expectRightSame(result, page);
      verify(
        () => remoteDatasource.getReactions(
          postId: 'post-1',
          cursor: 'cursor-1',
          limit: 10,
        ),
      ).called(1);
    });

    test('remote exception của getReactions được map thành Failure', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.getReactions(
          postId: 'post-1',
          cursor: null,
          limit: null,
        ),
      ).thenThrow(Exception('Lỗi lạ'));

      final result = await repository.getReactions(postId: 'post-1');

      _expectLeft(
        result,
        isA<ServerFailure>().having(
          (failure) => failure.message,
          'message',
          'Exception: Lỗi lạ',
        ),
      );
    });
  });
}
