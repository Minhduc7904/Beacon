import '../../domain/entities/feed_filter.dart';
import '../../domain/entities/feed_post.dart';

enum FeedStatus { initial, loading, loaded, error }

enum FeedViewMode { single, grid }

class FeedState {
  final FeedStatus status;
  final FeedViewMode viewMode;
  final FeedFilter filter;
  final List<FeedPost> posts;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const FeedState({
    this.status = FeedStatus.initial,
    this.viewMode = FeedViewMode.single,
    this.filter = const FeedFilter.all(),
    this.posts = const [],
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  FeedState copyWith({
    FeedStatus? status,
    FeedViewMode? viewMode,
    FeedFilter? filter,
    List<FeedPost>? posts,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FeedState(
      status: status ?? this.status,
      viewMode: viewMode ?? this.viewMode,
      filter: filter ?? this.filter,
      posts: posts ?? this.posts,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
