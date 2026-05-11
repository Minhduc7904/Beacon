import '../services/message_group_realtime_service.dart';

class LeaveMessageGroupRealtimeUseCase {
  LeaveMessageGroupRealtimeUseCase(this._realtimeService);

  final MessageGroupRealtimeService _realtimeService;

  Future<void> call(String groupId) {
    return _realtimeService.leaveGroup(groupId);
  }
}
