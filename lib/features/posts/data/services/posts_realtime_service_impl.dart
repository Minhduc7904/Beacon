import '../../../../core/realtime/signalr_service.dart';
import '../../domain/entities/post.dart';
import '../../domain/services/posts_realtime_service.dart';
import '../models/post_model.dart';

class PostsRealtimeServiceImpl implements PostsRealtimeService {
  PostsRealtimeServiceImpl(this._signalRService);

  static const String _receiveNewPostEvent = 'ReceiveNewPost';

  final SignalRService _signalRService;
  void Function()? _unsubscribeNewPosts;

  @override
  Future<void> subscribeNewPosts({
    required void Function(Post post) onPost,
  }) async {
    await _signalRService.connect();
    _unsubscribeNewPosts?.call();
    _unsubscribeNewPosts = _signalRService.on(_receiveNewPostEvent, (dto) {
      onPost(PostModel.fromJson(dto));
    });
  }

  @override
  void Function() unsubscribeNewPosts() {
    return () {
      _unsubscribeNewPosts?.call();
      _unsubscribeNewPosts = null;
    };
  }
}
