import '../services/message_group_realtime_service.dart';

class SubscribeUnreadMessageCountRealtimeUseCase {
  SubscribeUnreadMessageCountRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call({
    required void Function(String groupId, int unreadCount) onUnreadCount,
  }) {
    return _realtimeService.subscribeUnreadCounts(onUnreadCount: onUnreadCount);
  }

  void Function() unsubscribe() {
    return _realtimeService.unsubscribeUnreadCounts();
  }
}
