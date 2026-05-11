import '../entities/group_message.dart';
import '../services/message_group_realtime_service.dart';

class SubscribeNewMessagesRealtimeUseCase {
  SubscribeNewMessagesRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call({required void Function(GroupMessage message) onMessage}) {
    return _realtimeService.subscribeNewMessages(onMessage: onMessage);
  }

  void Function() unsubscribe() {
    return _realtimeService.unsubscribeNewMessages();
  }
}
