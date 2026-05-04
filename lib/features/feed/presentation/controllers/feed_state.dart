import '../../domain/entities/feed_post.dart';

enum FeedStatus { initial, loading, loaded, error }

class FeedState {
  final FeedStatus status;
  final List<FeedPost> posts;
  final String? errorMessage;

  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.errorMessage,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<FeedPost>? posts,
    String? errorMessage,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
