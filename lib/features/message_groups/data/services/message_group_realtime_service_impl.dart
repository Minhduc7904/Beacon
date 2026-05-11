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
  final Map<String, void Function()> _unsubscribeTypingByGroupId = {};
  final Map<String, void Function()> _unsubscribeSeenByGroupId = {};
  void Function()? _unsubscribeGlobalNewMessage;
  void Function()? _unsubscribeUnreadCount;
  void Function()? _unsubscribeMessageGroupSeen;

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
  Future<void> subscribeUnreadCounts({
    required void Function(String groupId, int unreadCount) onUnreadCount,
  }) async {
    await _signalRService.connect();
    _unsubscribeUnreadCount?.call();
    _unsubscribeUnreadCount = _signalRService.onArgs(
      MessageGroupRealtimeConstants.receiveUnreadMessageCountEvent,
      (args) {
        if (args == null || args.length < 2) {
          return;
        }
        final groupId = args[0]?.toString() ?? '';
        final unreadCount = _toInt(args[1]);
        if (groupId.isEmpty) {
          return;
        }
        onUnreadCount(groupId, unreadCount);
      },
    );
  }

  @override
  void Function() unsubscribeUnreadCounts() {
    return () {
      _unsubscribeUnreadCount?.call();
      _unsubscribeUnreadCount = null;
    };
  }

  @override
  Future<void> subscribeMessageGroupSeen({
    required void Function(String groupId, String lastSeenMessageId)
    onMessageGroupSeen,
  }) async {
    await _signalRService.connect();
    _unsubscribeMessageGroupSeen?.call();
    _unsubscribeMessageGroupSeen = _signalRService.onArgs(
      MessageGroupRealtimeConstants.receiveMessageGroupSeenEvent,
      (args) {
        if (args == null || args.length < 2) {
          return;
        }
        final groupId = args[0]?.toString() ?? '';
        final lastSeenMessageId = args[1]?.toString() ?? '';
        if (groupId.isEmpty || lastSeenMessageId.isEmpty) {
          return;
        }
        onMessageGroupSeen(groupId, lastSeenMessageId);
      },
    );
  }

  @override
  void Function() unsubscribeMessageGroupSeen() {
    return () {
      _unsubscribeMessageGroupSeen?.call();
      _unsubscribeMessageGroupSeen = null;
    };
  }

  @override
  Future<void> subscribeMessageSeenStatus({
    required String groupId,
    required void Function(String? seenByUserId, String lastSeenMessageId)
    onSeenStatus,
  }) async {
    final trimmedGroupId = groupId.trim();
    if (trimmedGroupId.isEmpty) {
      return;
    }

    await _signalRService.connect();
    _unsubscribeSeenByGroupId[trimmedGroupId]?.call();

    final unsubscribeMessageSeen = _signalRService.onArgs(
      MessageGroupRealtimeConstants.receiveMessageSeenEvent,
      (args) {
        if (args == null || args.length < 3) {
          return;
        }
        final incomingGroupId = args[0]?.toString() ?? '';
        final seenByUserId = args[1]?.toString();
        final lastSeenMessageId = args[2]?.toString() ?? '';
        if (incomingGroupId != trimmedGroupId || lastSeenMessageId.isEmpty) {
          return;
        }
        onSeenStatus(seenByUserId, lastSeenMessageId);
      },
    );

    // Backward-compatible fallback if backend only sends (groupId, lastSeenMessageId).
    final unsubscribeMessageGroupSeen = _signalRService.onArgs(
      MessageGroupRealtimeConstants.receiveMessageGroupSeenEvent,
      (args) {
        if (args == null || args.length < 2) {
          return;
        }
        final incomingGroupId = args[0]?.toString() ?? '';
        final lastSeenMessageId = args[1]?.toString() ?? '';
        if (incomingGroupId != trimmedGroupId || lastSeenMessageId.isEmpty) {
          return;
        }
        onSeenStatus(null, lastSeenMessageId);
      },
    );

    _unsubscribeSeenByGroupId[trimmedGroupId] = () {
      unsubscribeMessageSeen();
      unsubscribeMessageGroupSeen();
    };
  }

  @override
  void Function(String groupId) unsubscribeMessageSeenStatus() {
    return (groupId) {
      final trimmedGroupId = groupId.trim();
      if (trimmedGroupId.isEmpty) {
        return;
      }
      _unsubscribeSeenByGroupId.remove(trimmedGroupId)?.call();
    };
  }

  @override
  Future<void> subscribeTypingStatus({
    required String groupId,
    required void Function(String typingUserId, bool isTyping) onTypingStatus,
  }) async {
    final trimmedGroupId = groupId.trim();
    if (trimmedGroupId.isEmpty) {
      return;
    }

    await _signalRService.connect();
    _unsubscribeTypingByGroupId[trimmedGroupId]?.call();
    _unsubscribeTypingByGroupId[trimmedGroupId] = _signalRService.onArgs(
      MessageGroupRealtimeConstants.receiveTypingStatusEvent,
      (args) {
        if (args == null || args.length < 3) {
          return;
        }
        final incomingGroupId = args[0]?.toString() ?? '';
        final typingUserId = args[1]?.toString() ?? '';
        final isTyping = _toBool(args[2]);
        if (incomingGroupId != trimmedGroupId || typingUserId.isEmpty) {
          return;
        }
        onTypingStatus(typingUserId, isTyping);
      },
    );
  }

  @override
  void Function(String groupId) unsubscribeTypingStatus() {
    return (groupId) {
      final trimmedGroupId = groupId.trim();
      if (trimmedGroupId.isEmpty) {
        return;
      }
      _unsubscribeTypingByGroupId.remove(trimmedGroupId)?.call();
    };
  }

  @override
  Future<void> sendTypingStatus({
    required String groupId,
    required bool isTyping,
  }) async {
    final trimmedGroupId = groupId.trim();
    if (trimmedGroupId.isEmpty) {
      return;
    }

    await _signalRService.invoke(
      MessageGroupRealtimeConstants.sendTypingStatusMethod,
      args: [
        <String, dynamic>{
          'messageGroupId': trimmedGroupId,
          'isTyping': isTyping,
        },
      ],
    );
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
        : _toUtcDate(createdAtRaw);

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

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final raw = value?.toString().trim().toLowerCase();
    return raw == 'true' || raw == '1';
  }

  DateTime? _toUtcDate(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }

    final hasTimezoneSuffix =
        raw.endsWith('Z') ||
        raw.contains('+') ||
        raw.substring(10).contains('-');
    if (hasTimezoneSuffix) {
      return parsed.toUtc();
    }

    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }
}
