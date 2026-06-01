import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/messages/app_message_notifier.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../posts/domain/entities/post.dart';
import '../../../posts/domain/entities/post_page.dart';
import '../../../posts/domain/entities/post_reaction_icon.dart';
import '../../../posts/domain/entities/post_reaction_result.dart';
import '../../../posts/domain/entities/post_visibility.dart';
import '../../../posts/domain/entities/reaction_summary.dart';
import '../../../posts/domain/usecase/delete_post_usecase.dart';
import '../../../posts/domain/usecase/delete_post_reaction_usecase.dart';
import '../../../posts/domain/usecase/get_feed_posts_usecase.dart';
import '../../../posts/domain/usecase/get_friend_posts_usecase.dart';
import '../../../posts/domain/usecase/get_my_posts_usecase.dart';
import '../../../posts/domain/usecase/get_post_reactions_usecase.dart';
import '../../../posts/domain/usecase/set_post_reaction_icon_usecase.dart';
import '../../../posts/domain/usecase/set_post_reaction_usecase.dart';
import '../../../posts/domain/usecase/subscribe_new_posts_realtime_usecase.dart';
import '../../../posts/domain/usecase/update_post_usecase.dart';
import '../../domain/entities/feed_filter.dart';
import '../../domain/entities/feed_post.dart';
import '../../domain/entities/feed_reaction.dart';
import 'feed_state.dart';

class FeedNotifier extends StateNotifier<FeedState> {
  static const int _pageLimit = 20;

  final GetFeedPostsUseCase _getFeedPostsUseCase;
  final GetMyPostsUseCase _getMyPostsUseCase;
  final GetFriendPostsUseCase _getFriendPostsUseCase;
  final SetPostReactionUseCase _setPostReactionUseCase;
  final SetPostReactionIconUseCase _setPostReactionIconUseCase;
  final DeletePostReactionUseCase _deletePostReactionUseCase;
  final GetPostReactionsUseCase _getPostReactionsUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final SubscribeNewPostsRealtimeUseCase _subscribeNewPostsRealtimeUseCase;
  final AppMessageNotifier _messageNotifier;

  final Set<String> _reactingPostIds = <String>{};

  void Function()? _unsubscribeNewPosts;
  bool _isBindingRealtime = false;

  FeedNotifier(
    this._getFeedPostsUseCase,
    this._getMyPostsUseCase,
    this._getFriendPostsUseCase,
    this._setPostReactionUseCase,
    this._setPostReactionIconUseCase,
    this._deletePostReactionUseCase,
    this._getPostReactionsUseCase,
    this._updatePostUseCase,
    this._deletePostUseCase,
    this._subscribeNewPostsRealtimeUseCase,
    this._messageNotifier,
  ) : super(const FeedState());

  Future<void> load({bool forceRefresh = false}) async {
    if (!mounted) {
      return;
    }

    unawaited(_bindRealtime());

    if (!mounted) {
      return;
    }

    if (state.status == FeedStatus.loading && !forceRefresh) {
      return;
    }

    final activeFilter = state.filter;
    var hasVisiblePosts = !forceRefresh && state.posts.isNotEmpty;

    final cachedResult = await _loadCachedPage(
      filter: activeFilter,
      limit: _pageLimit,
    );

    if (!mounted) {
      return;
    }

    cachedResult.fold(
      (_) {
        if (!mounted) {
          return;
        }

        if (!hasVisiblePosts) {
          state = state.copyWith(
            status: FeedStatus.loading,
            posts: const <FeedPost>[],
            isLoadingMore: false,
            isRefreshing: false,
            hasMore: false,
            clearNextCursor: true,
            clearErrorMessage: true,
            postReactionPages: const {},
            loadingReactionPostIds: const {},
          );
        } else {
          state = state.copyWith(
            isLoadingMore: false,
            isRefreshing: true,
            clearErrorMessage: true,
          );
        }
      },
      (page) {
        if (!mounted) {
          return;
        }

        final cachedPosts = page.items.map(_mapPost).toList();

        if (cachedPosts.isNotEmpty) {
          hasVisiblePosts = true;
          state = state.copyWith(
            status: FeedStatus.loaded,
            posts: cachedPosts,
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
            isLoadingMore: false,
            isRefreshing: true,
            clearErrorMessage: true,
            postReactionPages: const {},
            loadingReactionPostIds: const {},
          );
        } else if (!hasVisiblePosts) {
          state = state.copyWith(
            status: FeedStatus.loading,
            posts: const <FeedPost>[],
            isLoadingMore: false,
            isRefreshing: false,
            hasMore: false,
            clearNextCursor: true,
            clearErrorMessage: true,
            postReactionPages: const {},
            loadingReactionPostIds: const {},
          );
        }
      },
    );

    final result = await _loadPage(filter: activeFilter, limit: _pageLimit);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        if (!mounted) {
          return;
        }

        if (!hasVisiblePosts) {
          _messageNotifier.addError(failure.message);
          state = state.copyWith(
            status: FeedStatus.error,
            errorMessage: failure.message,
            isRefreshing: false,
            hasMore: false,
            clearNextCursor: true,
          );
          return;
        }

        state = state.copyWith(
          isRefreshing: false,
          errorMessage: failure.message,
        );
      },
      (page) {
        if (!mounted) {
          return;
        }

        final remotePosts = page.items.map(_mapPost).toList();

        state = state.copyWith(
          status: FeedStatus.loaded,
          posts: remotePosts,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          isRefreshing: false,
          clearErrorMessage: true,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (!mounted) {
      return;
    }

    if (state.status != FeedStatus.loaded ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final cursor = state.nextCursor;
    if (cursor == null || cursor.trim().isEmpty) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearErrorMessage: true);

    final result = await _loadPage(
      filter: state.filter,
      cursor: cursor,
      limit: _pageLimit,
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        if (!mounted) {
          return;
        }

        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
      (page) {
        if (!mounted) {
          return;
        }

        final nextPosts = page.items.map(_mapPost).toList();

        state = state.copyWith(
          posts: _mergeNextPagePosts(state.posts, nextPosts),
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          isLoadingMore: false,
          clearErrorMessage: true,
        );
      },
    );
  }

  Future<void> updateFilter(FeedFilter filter) async {
    if (!mounted) {
      return;
    }

    if (state.filter == filter) {
      return;
    }

    state = state.copyWith(filter: filter);
    await load(forceRefresh: true);
  }

  void updateViewMode(FeedViewMode viewMode) {
    if (!mounted) {
      return;
    }

    if (state.viewMode == viewMode) {
      return;
    }

    state = state.copyWith(viewMode: viewMode);
  }

  void applyIncomingPost(Post post) {
    if (!mounted) {
      return;
    }

    if (!_shouldIncludeIncomingPost(post)) {
      return;
    }

    final posts = List<FeedPost>.from(state.posts);
    final incoming = _mapPost(post);
    final existingIndex = posts.indexWhere((item) => item.id == incoming.id);

    if (existingIndex >= 0) {
      posts[existingIndex] = incoming;
    } else {
      posts.add(incoming);
    }

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (!mounted) {
      return;
    }

    state = state.copyWith(
      status: FeedStatus.loaded,
      posts: posts,
      clearErrorMessage: true,
    );
  }

  Future<void> updatePost({
    required String postId,
    String? caption,
    required PostVisibility visibility,
  }) async {
    final result = await _updatePostUseCase(
      UpdatePostParams(
        postId: postId,
        caption: caption,
        visibility: visibility,
      ),
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        if (!mounted) {
          return;
        }

        _messageNotifier.addError(failure.message);
      },
      (post) {
        if (!mounted) {
          return;
        }

        final posts = List<FeedPost>.from(state.posts);
        final idx = posts.indexWhere((item) => item.id == post.id);

        if (idx == -1) {
          return;
        }

        posts[idx] = posts[idx].copyWith(
          caption: post.caption,
          visibility: post.visibility,
        );

        state = state.copyWith(posts: posts);
        _messageNotifier.addSuccess('Đã cập nhật bài đăng');
      },
    );
  }

  Future<void> deletePost(String postId) async {
    final result = await _deletePostUseCase(DeletePostParams(postId: postId));

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        if (!mounted) {
          return;
        }

        _messageNotifier.addError(failure.message);
      },
      (_) {
        if (!mounted) {
          return;
        }

        final posts = state.posts
            .where((post) => post.id != postId)
            .toList(growable: false);

        state = state.copyWith(posts: posts);
        _messageNotifier.addSuccess('Đã xóa bài đăng');
      },
    );
  }

  Future<void> toggleReaction(String postId, ReactionType type) async {
    if (!mounted) {
      return;
    }

    if (_reactingPostIds.contains(postId)) {
      return;
    }

    final posts = List<FeedPost>.from(state.posts);
    final idx = posts.indexWhere((p) => p.id == postId);

    if (idx == -1) {
      return;
    }

    final post = posts[idx];
    final icon = _mapFeedReactionType(type);

    if (icon == null) {
      return;
    }

    _reactingPostIds.add(postId);

    final result = post.myReaction == type
        ? await _deletePostReactionUseCase(
            DeletePostReactionParams(postId: postId),
          )
        : await _setPostReactionUseCase(
            SetPostReactionParams(postId: postId, icon: icon),
          );

    _reactingPostIds.remove(postId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        if (!mounted) {
          return;
        }

        _messageNotifier.addError(failure.message);
      },
      (reactionResult) {
        if (!mounted) {
          return;
        }

        _applyReactionResult(reactionResult);
      },
    );
  }

  Future<bool> setReactionIcon(String postId, String icon) async {
    if (!mounted) {
      return false;
    }

    if (_reactingPostIds.contains(postId)) {
      return false;
    }

    final posts = List<FeedPost>.from(state.posts);
    final idx = posts.indexWhere((p) => p.id == postId);

    if (idx == -1) {
      return false;
    }

    _reactingPostIds.add(postId);

    final result = await _setPostReactionIconUseCase(
      SetPostReactionIconParams(postId: postId, icon: icon),
    );

    _reactingPostIds.remove(postId);

    if (!mounted) {
      return false;
    }

    result.fold(
      (failure) {
        if (!mounted) {
          return;
        }

        _messageNotifier.addError(failure.message);
      },
      (reactionResult) {
        if (!mounted) {
          return;
        }

        _applyReactionResult(reactionResult);
      },
    );

    return result.isRight();
  }

  Future<void> loadPostReactions(String postId) async {
    if (!mounted) {
      return;
    }

    if (state.loadingReactionPostIds.contains(postId)) {
      return;
    }

    state = state.copyWith(
      loadingReactionPostIds: {...state.loadingReactionPostIds, postId},
    );

    final result = await _getPostReactionsUseCase(
      GetPostReactionsParams(postId: postId, limit: 20),
    );

    if (!mounted) {
      return;
    }

    final loadingIds = Set<String>.from(state.loadingReactionPostIds)
      ..remove(postId);

    result.fold(
      (_) {
        if (!mounted) {
          return;
        }

        state = state.copyWith(loadingReactionPostIds: loadingIds);
      },
      (page) {
        if (!mounted) {
          return;
        }

        state = state.copyWith(
          postReactionPages: {...state.postReactionPages, postId: page},
          loadingReactionPostIds: loadingIds,
        );
      },
    );
  }

  Future<Either<Failure, PostPage>> _loadPage({
    required FeedFilter filter,
    String? cursor,
    required int limit,
  }) {
    switch (filter.type) {
      case FeedFilterType.all:
        return _getFeedPostsUseCase(cursor: cursor, limit: limit);

      case FeedFilterType.me:
        return _getMyPostsUseCase(cursor: cursor, limit: limit);

      case FeedFilterType.friend:
        final friendId = filter.friendId?.trim() ?? '';
        return _getFriendPostsUseCase(
          friendId: friendId,
          cursor: cursor,
          limit: limit,
        );
    }
  }

  Future<Either<Failure, PostPage>> _loadCachedPage({
    required FeedFilter filter,
    required int limit,
  }) {
    switch (filter.type) {
      case FeedFilterType.all:
        return _getFeedPostsUseCase.cached(limit: limit);

      case FeedFilterType.me:
        return _getMyPostsUseCase.cached(limit: limit);

      case FeedFilterType.friend:
        final friendId = filter.friendId?.trim() ?? '';
        return _getFriendPostsUseCase.cached(friendId: friendId, limit: limit);
    }
  }

  List<FeedPost> _mergeNextPagePosts(
    List<FeedPost> existingPosts,
    List<FeedPost> nextPosts,
  ) {
    final posts = List<FeedPost>.from(existingPosts);

    for (final post in nextPosts) {
      final index = posts.indexWhere((item) => item.id == post.id);

      if (index >= 0) {
        posts[index] = post;
      } else {
        posts.add(post);
      }
    }

    return posts;
  }

  Future<void> _bindRealtime() async {
    if (!mounted) {
      return;
    }

    if (_isBindingRealtime || _unsubscribeNewPosts != null) {
      return;
    }

    _isBindingRealtime = true;

    try {
      await _subscribeNewPostsRealtimeUseCase.call(onPost: applyIncomingPost);

      if (!mounted) {
        return;
      }

      _unsubscribeNewPosts = _subscribeNewPostsRealtimeUseCase.unsubscribe();
    } finally {
      if (mounted) {
        _isBindingRealtime = false;
      }
    }
  }

  bool _shouldIncludeIncomingPost(Post post) {
    if (!mounted) {
      return false;
    }

    switch (state.filter.type) {
      case FeedFilterType.all:
        return true;

      case FeedFilterType.friend:
        return state.filter.friendId == post.ownerUserId;

      case FeedFilterType.me:
        return false;
    }
  }

  FeedPost _mapPost(Post post) {
    final ownerName = post.owner?.displayName.trim();
    final remoteThumbnailUrl = post.media.thumbnailUrl?.trim();
    final remoteImageUrl = post.media.url.trim();
    final imageUrl =
        remoteThumbnailUrl != null && remoteThumbnailUrl.isNotEmpty
        ? remoteThumbnailUrl
        : remoteImageUrl;

    return FeedPost(
      id: post.id,
      ownerUserId: post.ownerUserId,
      authorName: ownerName == null || ownerName.isEmpty
          ? 'Người dùng'
          : ownerName,
      authorAvatarUrl: post.owner?.avatarUrl,
      imageUrl: imageUrl,
      remoteThumbnailUrl: remoteThumbnailUrl == null ||
              remoteThumbnailUrl.isEmpty
          ? null
          : remoteThumbnailUrl,
      remoteImageUrl: remoteImageUrl,
      localThumbnailPath: post.media.localThumbnailPath,
      localImagePath: post.media.localImagePath,
      caption: post.caption,
      visibility: post.visibility,
      createdAt: TimeUtils.toVietnamTime(post.createdAtUtc),
      latitude: post.latitude,
      longitude: post.longitude,
      hasDailySafetyRecord: post.dailySafetyRecord != null,
      reactionCounts: _mapReactionSummary(post.reactionSummary),
      myReaction: _mapReactionIcon(post.myReaction?.icon),
    );
  }

  void _applyReactionResult(PostReactionResult result) {
    if (!mounted) {
      return;
    }

    final posts = List<FeedPost>.from(state.posts);
    final idx = posts.indexWhere((post) => post.id == result.postId);

    if (idx == -1) {
      return;
    }

    posts[idx] = posts[idx].copyWith(
      reactionCounts: _mapReactionSummary(result.reactionSummary),
      myReaction: _mapReactionIcon(result.myReaction?.icon),
      clearMyReaction: result.myReaction == null,
    );

    if (!mounted) {
      return;
    }

    state = state.copyWith(posts: posts);
  }

  Map<ReactionType, int> _mapReactionSummary(ReactionSummary summary) {
    final counts = <ReactionType, int>{};

    for (final entry in summary.icons.entries) {
      final reactionType = _mapReactionIcon(entry.key);

      if (reactionType != null && entry.value > 0) {
        counts[reactionType] = entry.value;
      }
    }

    return counts;
  }

  PostReactionIcon? _mapFeedReactionType(ReactionType type) {
    switch (type) {
      case ReactionType.heart:
        return PostReactionIcon.heart;

      case ReactionType.haha:
        return PostReactionIcon.haha;

      case ReactionType.like:
        return PostReactionIcon.like;

      case ReactionType.sad:
        return PostReactionIcon.sad;

      case ReactionType.wow:
        return PostReactionIcon.wow;
    }
  }

  ReactionType? _mapReactionIcon(PostReactionIcon? icon) {
    switch (icon) {
      case PostReactionIcon.heart:
        return ReactionType.heart;

      case PostReactionIcon.haha:
        return ReactionType.haha;

      case PostReactionIcon.like:
        return ReactionType.like;

      case PostReactionIcon.sad:
        return ReactionType.sad;

      case PostReactionIcon.wow:
        return ReactionType.wow;

      case null:
        return null;
    }
  }

  @override
  void dispose() {
    _unsubscribeNewPosts?.call();
    _unsubscribeNewPosts = null;
    _reactingPostIds.clear();
    super.dispose();
  }
}
