import '../entities/friend_presence_event.dart';
import '../services/friends_realtime_service.dart';

class SubscribeFriendPresenceRealtimeUseCase {
  SubscribeFriendPresenceRealtimeUseCase(this._realtimeService);

  final FriendsRealtimeService _realtimeService;

  Future<void> call({
    required void Function(FriendPresenceEvent event) onPresence,
  }) {
    return _realtimeService.subscribePresence(onPresence: onPresence);
  }

  void Function() unsubscribe() {
    return _realtimeService.unsubscribePresence();
  }
}
