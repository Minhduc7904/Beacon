import '../../../../core/realtime/realtime_config.dart';
import '../../../../core/realtime/realtime_logger.dart';
import '../../../../core/realtime/signalr_service.dart';
import '../constants/message_group_realtime_constants.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/services/message_group_realtime_service.dart';

class MessageGroupRealtimeServiceImpl implements MessageGroupRealtimeService {
  MessageGroupRealtimeServiceImpl(this._signalRService);

  final SignalRService _signalRService;
  final Map<String, void Function()> _unsubscribeByGroupId = {};
  void Function()? _unsubscribeGlobalNewMessage;

  @override
  Future<void> subscribeNewMessages({
    required void Function(GroupMessage message) onMessage,
  }) async {
    await _signalRService.connect();
    _unsubscribeGlobalNewMessage?.call();
    _unsubscribeGlobalNewMessage = _signalRService.on(
      MessageGroupRealtimeConstants.receiveNewMessageEvent,
      (dto) {
        final message = _mapMessageDto(dto);
        if (message == null) {
          return;
        }
        onMessage(message);
      },
    );
  }

  @override
  void Function() unsubscribeNewMessages() {
    return () {
      _unsubscribeGlobalNewMessage?.call();
      _unsubscribeGlobalNewMessage = null;
    };
  }

  @override
  Future<void> joinGroup({
    required String groupId,
    required void Function(GroupMessage message) onMessage,
  }) async {
    final trimmedGroupId = groupId.trim();
    if (trimmedGroupId.isEmpty) {
      return;
    }

    await _signalRService.connect();
    _unsubscribeByGroupId[trimmedGroupId]?.call();
    final unsubscribeReceiveNewMessage = _signalRService.on(
      MessageGroupRealtimeConstants.receiveNewMessageEvent,
      (dto) {
        final message = _mapMessageDto(dto);
        if (message == null || message.groupId != trimmedGroupId) {
          return;
        }
        onMessage(message);
      },
    );
    final unsubscribeReceiveMessage = _signalRService.on(
      MessageGroupRealtimeConstants.messageReceivedEvent,
      (dto) {
        final message = _mapMessageDto(dto);
        if (message == null || message.groupId != trimmedGroupId) {
          return;
        }
        onMessage(message);
      },
    );
    _unsubscribeByGroupId[trimmedGroupId] = () {
      unsubscribeReceiveNewMessage();
      unsubscribeReceiveMessage();
    };
    try {
      await _signalRService.invoke(
        MessageGroupRealtimeConstants.joinMessageGroupMethod,
        args: [
          <String, dynamic>{'messageGroupId': trimmedGroupId},
        ],
      );
      RealtimeLogger.joinGroup(url: _hubUrl, groupId: trimmedGroupId);
    } catch (error) {
      RealtimeLogger.joinGroupError(
        url: _hubUrl,
        groupId: trimmedGroupId,
        error: error,
      );
      rethrow;
    }
  }

  @override
  Future<void> leaveGroup(String groupId) async {
    final trimmedGroupId = groupId.trim();
    if (trimmedGroupId.isEmpty) {
      return;
    }

    _unsubscribeByGroupId.remove(trimmedGroupId)?.call();
    try {
      await _signalRService.invoke(
        MessageGroupRealtimeConstants.leaveMessageGroupMethod,
        args: [
          <String, dynamic>{'messageGroupId': trimmedGroupId},
        ],
      );
      RealtimeLogger.leaveGroup(url: _hubUrl, groupId: trimmedGroupId);
    } catch (error) {
      RealtimeLogger.leaveGroupError(
        url: _hubUrl,
        groupId: trimmedGroupId,
        error: error,
      );
      rethrow;
    }
  }

  String get _hubUrl => RealtimeConfig.signalRHubUrl;

  GroupMessage? _mapMessageDto(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final incomingGroupId = json['groupId']?.toString() ?? '';
    final senderId = json['senderId']?.toString() ?? '';
    final content = json['content']?.toString() ?? '';
    final senderFamilyName = json['senderFamilyName']?.toString() ?? '';
    final senderGivenName = json['senderGivenName']?.toString() ?? '';
    final createdAtRaw = json['createdAtUtc']?.toString();

    if (id.isEmpty || incomingGroupId.isEmpty || senderId.isEmpty) {
      return null;
    }

    final createdAtUtc = (createdAtRaw == null || createdAtRaw.trim().isEmpty)
        ? null
        : DateTime.tryParse(createdAtRaw);

    return GroupMessage(
      id: id,
      groupId: incomingGroupId,
      senderId: senderId,
      senderFamilyName: senderFamilyName,
      senderGivenName: senderGivenName,
      content: content,
      createdAtUtc: createdAtUtc,
    );
  }
}
