import '../entities/group_message.dart';
import '../services/message_group_realtime_service.dart';

class JoinMessageGroupRealtimeUseCase {
  JoinMessageGroupRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call({
    required String groupId,
    required void Function(GroupMessage message) onMessage,
  }) {
    return _realtimeService.joinGroup(groupId: groupId, onMessage: onMessage);
  }
}
