import '../services/message_group_realtime_service.dart';

class SendTypingStatusRealtimeUseCase {
  SendTypingStatusRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call({required String groupId, required bool isTyping}) {
    return _realtimeService.sendTypingStatus(
      groupId: groupId,
      isTyping: isTyping,
    );
  }
}
