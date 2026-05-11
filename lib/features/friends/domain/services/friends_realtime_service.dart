import '../entities/friend_presence_event.dart';

abstract class FriendsRealtimeService {
  Future<void> subscribePresence({
    required void Function(FriendPresenceEvent event) onPresence,
  });

  void Function() unsubscribePresence();
}
