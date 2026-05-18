import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/messages/app_message_notifier.dart';
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
import '../../../posts/domain/usecase/set_post_reaction_usecase.dart';
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
  final DeletePostReactionUseCase _deletePostReactionUseCase;
  final UpdatePostUseCase _updatePostUseCase;
  final DeletePostUseCase _deletePostUseCase;
  final AppMessageNotifier _messageNotifier;
  final Set<String> _reactingPostIds = <String>{};

  FeedNotifier(
    this._getFeedPostsUseCase,
    this._getMyPostsUseCase,
    this._getFriendPostsUseCase,
    this._setPostReactionUseCase,
    this._deletePostReactionUseCase,
    this._updatePostUseCase,
    this._deletePostUseCase,
    this._messageNotifier,
  ) : super(const FeedState());

  Future<void> load({bool forceRefresh = false}) async {
    if (state.status == FeedStatus.loading && !forceRefresh) {
      return;
    }

    state = state.copyWith(
      status: FeedStatus.loading,
      posts: const <FeedPost>[],
      isLoadingMore: false,
      hasMore: false,
      clearNextCursor: true,
      clearErrorMessage: true,
    );

    final result = await _loadPage(filter: state.filter, limit: _pageLimit);

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          status: FeedStatus.error,
          errorMessage: failure.message,
          hasMore: false,
          clearNextCursor: true,
        );
      },
      (page) {
        state = state.copyWith(
          status: FeedStatus.loaded,
          posts: page.items.map(_mapPost).toList(),
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          clearErrorMessage: true,
        );
      },
    );
  }

  Future<void> loadMore() async {
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

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        );
      },
      (page) {
        state = state.copyWith(
          posts: [...state.posts, ...page.items.map(_mapPost)],
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
          isLoadingMore: false,
          clearErrorMessage: true,
        );
      },
    );
  }

  Future<void> updateFilter(FeedFilter filter) async {
    if (state.filter == filter) {
      return;
    }

    state = state.copyWith(filter: filter);
    await load(forceRefresh: true);
  }

  void updateViewMode(FeedViewMode viewMode) {
    if (state.viewMode == viewMode) {
      return;
    }

    state = state.copyWith(viewMode: viewMode);
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

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
      },
      (post) {
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

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
      },
      (_) {
        final posts = state.posts
            .where((post) => post.id != postId)
            .toList(growable: false);
        state = state.copyWith(posts: posts);
        _messageNotifier.addSuccess('Đã xóa bài đăng');
      },
    );
  }

  Future<void> toggleReaction(String postId, ReactionType type) async {
    if (_reactingPostIds.contains(postId)) {
      return;
    }

    final posts = List<FeedPost>.from(state.posts);
    final idx = posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

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

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
      },
      (reactionResult) {
        _applyReactionResult(reactionResult);
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

  FeedPost _mapPost(Post post) {
    final ownerName = post.owner?.displayName.trim();
    final imageUrl = post.media.thumbnailUrl?.trim().isNotEmpty == true
        ? post.media.thumbnailUrl!.trim()
        : post.media.url.trim();

    return FeedPost(
      id: post.id,
      ownerUserId: post.ownerUserId,
      authorName: ownerName == null || ownerName.isEmpty
          ? 'Người dùng'
          : ownerName,
      authorAvatarUrl: post.owner?.avatarUrl,
      imageUrl: imageUrl,
      caption: post.caption,
      visibility: post.visibility,
      createdAt: post.createdAtUtc.toLocal(),
      reactionCounts: _mapReactionSummary(post.reactionSummary),
      myReaction: _mapReactionIcon(post.myReaction?.icon),
    );
  }

  void _applyReactionResult(PostReactionResult result) {
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
}
