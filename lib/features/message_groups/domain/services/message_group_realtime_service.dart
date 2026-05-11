import '../entities/group_message.dart';

abstract class MessageGroupRealtimeService {
  Future<void> subscribeNewMessages({
    required void Function(GroupMessage message) onMessage,
  });

  void Function() unsubscribeNewMessages();

  Future<void> joinGroup({
    required String groupId,
    required void Function(GroupMessage message) onMessage,
  });

  Future<void> leaveGroup(String groupId);
}
