import '../services/message_group_realtime_service.dart';

class SubscribeMessageGroupSeenRealtimeUseCase {
  SubscribeMessageGroupSeenRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call({
    required void Function(String groupId, String lastSeenMessageId)
    onMessageGroupSeen,
  }) {
    return _realtimeService.subscribeMessageGroupSeen(
      onMessageGroupSeen: onMessageGroupSeen,
    );
  }

  void Function() unsubscribe() {
    return _realtimeService.unsubscribeMessageGroupSeen();
  }
}
