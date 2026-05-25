import '../entities/post.dart';

abstract class PostsRealtimeService {
  Future<void> subscribeNewPosts({required void Function(Post post) onPost});

  void Function() unsubscribeNewPosts();
}
