import 'package:beacon_app/core/notifications/push_notification_service.dart';
import 'package:beacon_app/core/realtime/signalr_service.dart';
import 'package:beacon_app/features/friends/domain/entities/friend_presence_event.dart';
import 'package:beacon_app/features/friends/domain/services/friends_realtime_service.dart';
import 'package:beacon_app/features/message_groups/domain/entities/group_message.dart';
import 'package:beacon_app/features/message_groups/domain/services/message_group_realtime_service.dart';
import 'package:beacon_app/features/posts/domain/entities/post.dart';
import 'package:beacon_app/features/posts/domain/services/posts_realtime_service.dart';
import 'package:flutter/foundation.dart';

class FakeSignalRService implements SignalRService {
  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> connect() async {
    _isConnected = true;
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
  }

  @override
  Future<void> invoke(String methodName, {List<Object?>? args}) async {}

  @override
  VoidCallback on(
    String eventName,
    void Function(Map<String, dynamic>) handler,
  ) {
    return () {};
  }

  @override
  VoidCallback onArgs(
    String eventName,
    void Function(List<Object?>? args) handler,
  ) {
    return () {};
  }
}

class FakePushNotificationService implements PushNotificationService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> requestNotificationPermission() async {}

  @override
  Future<void> registerCurrentDeviceToken() async {}

  @override
  Future<void> syncCurrentDeviceTokenIfAuthorized() async {}

  @override
  Future<void> deleteCurrentDeviceToken() async {}

  @override
  String? consumePendingPostReactionPostId() => null;

  @override
  Future<void> dispose() async {}
}

class FakeMessageGroupRealtimeService implements MessageGroupRealtimeService {
  @override
  Future<void> joinGroup({
    required String groupId,
    required void Function(GroupMessage message) onMessage,
  }) async {}

  @override
  Future<void> leaveGroup(String groupId) async {}

  @override
  Future<void> sendTypingStatus({
    required String groupId,
    required bool isTyping,
  }) async {}

  @override
  Future<void> subscribeMessageGroupSeen({
    required void Function(String groupId, String lastSeenMessageId)
    onMessageGroupSeen,
  }) async {}

  @override
  Future<void> subscribeMessageSeenStatus({
    required String groupId,
    required MessageSeenStatusHandler onSeenStatus,
  }) async {}

  @override
  Future<void> subscribeNewMessages({
    required void Function(GroupMessage message) onMessage,
  }) async {}

  @override
  Future<void> subscribeTypingStatus({
    required String groupId,
    required void Function(String typingUserId, bool isTyping) onTypingStatus,
  }) async {}

  @override
  Future<void> subscribeUnreadCounts({
    required void Function(String groupId, int unreadCount) onUnreadCount,
  }) async {}

  @override
  void Function() unsubscribeMessageGroupSeen() => () {};

  @override
  void Function(String groupId) unsubscribeMessageSeenStatus() => (_) {};

  @override
  void Function() unsubscribeNewMessages() => () {};

  @override
  void Function(String groupId) unsubscribeTypingStatus() => (_) {};

  @override
  void Function() unsubscribeUnreadCounts() => () {};
}

class FakeFriendsRealtimeService implements FriendsRealtimeService {
  @override
  Future<void> subscribePresence({
    required void Function(FriendPresenceEvent event) onPresence,
  }) async {}

  @override
  void Function() unsubscribePresence() => () {};
}

class FakePostsRealtimeService implements PostsRealtimeService {
  @override
  Future<void> subscribeNewPosts({
    required void Function(Post post) onPost,
  }) async {}

  @override
  void Function() unsubscribeNewPosts() => () {};
}
