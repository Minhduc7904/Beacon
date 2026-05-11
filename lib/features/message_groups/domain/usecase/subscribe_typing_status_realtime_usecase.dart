import '../services/message_group_realtime_service.dart';

class SubscribeTypingStatusRealtimeUseCase {
  SubscribeTypingStatusRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call({
    required String groupId,
    required void Function(String typingUserId, bool isTyping) onTypingStatus,
  }) {
    return _realtimeService.subscribeTypingStatus(
      groupId: groupId,
      onTypingStatus: onTypingStatus,
    );
  }

  void Function(String groupId) unsubscribe() {
    return _realtimeService.unsubscribeTypingStatus();
  }
}
