import '../entities/post.dart';
import '../services/posts_realtime_service.dart';

class SubscribeNewPostsRealtimeUseCase {
  SubscribeNewPostsRealtimeUseCase(this._realtimeService);

  final PostsRealtimeService _realtimeService;

  Future<void> call({required void Function(Post post) onPost}) {
    return _realtimeService.subscribeNewPosts(onPost: onPost);
  }

  void Function() unsubscribe() {
    return _realtimeService.unsubscribeNewPosts();
  }
}
