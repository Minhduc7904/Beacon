import '../entities/group_message.dart';

abstract class MessageGroupRealtimeService {
  Future<void> subscribeNewMessages({
    required void Function(GroupMessage message) onMessage,
  });

  void Function() unsubscribeNewMessages();

  Future<void> subscribeUnreadCounts({
    required void Function(String groupId, int unreadCount) onUnreadCount,
  });

  void Function() unsubscribeUnreadCounts();

  Future<void> subscribeMessageGroupSeen({
    required void Function(String groupId, String lastSeenMessageId)
    onMessageGroupSeen,
  });

  void Function() unsubscribeMessageGroupSeen();

  Future<void> subscribeTypingStatus({
    required String groupId,
    required void Function(String typingUserId, bool isTyping) onTypingStatus,
  });

  void Function(String groupId) unsubscribeTypingStatus();

  Future<void> sendTypingStatus({
    required String groupId,
    required bool isTyping,
  });

  Future<void> joinGroup({
    required String groupId,
    required void Function(GroupMessage message) onMessage,
  });

  Future<void> leaveGroup(String groupId);
}
