import '../services/message_group_realtime_service.dart';

class SubscribeMessageSeenStatusRealtimeUseCase {
  SubscribeMessageSeenStatusRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call({
    required String groupId,
    required MessageSeenStatusHandler onSeenStatus,
  }) {
    return _realtimeService.subscribeMessageSeenStatus(
      groupId: groupId,
      onSeenStatus: onSeenStatus,
    );
  }

  void Function(String groupId) unsubscribe() {
    return _realtimeService.unsubscribeMessageSeenStatus();
  }
}
