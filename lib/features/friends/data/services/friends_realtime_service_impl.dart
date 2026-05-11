import '../../../../core/realtime/signalr_service.dart';
import '../../domain/entities/friend_presence_event.dart';
import '../../domain/services/friends_realtime_service.dart';
import '../constants/friends_realtime_constants.dart';

class FriendsRealtimeServiceImpl implements FriendsRealtimeService {
  FriendsRealtimeServiceImpl(this._signalRService);

  final SignalRService _signalRService;
  void Function()? _unsubscribePresence;

  @override
  Future<void> subscribePresence({
    required void Function(FriendPresenceEvent event) onPresence,
  }) async {
    await _signalRService.connect();
    _unsubscribePresence?.call();
    _unsubscribePresence = _signalRService.onArgs(
      FriendsRealtimeConstants.receivePresenceEvent,
      (args) {
        final event = _mapPresenceEvent(args);
        if (event == null) {
          return;
        }
        onPresence(event);
      },
    );
  }

  @override
  void Function() unsubscribePresence() {
    return () {
      _unsubscribePresence?.call();
      _unsubscribePresence = null;
    };
  }

  FriendPresenceEvent? _mapPresenceEvent(List<Object?>? args) {
    if (args == null || args.isEmpty) {
      return null;
    }

    final payload = args.first;
    if (payload is Map) {
      return _mapPresenceMap(Map<String, dynamic>.from(payload));
    }

    if (args.length < 3) {
      return null;
    }

    final userId = args[0]?.toString() ?? '';
    if (userId.isEmpty) {
      return null;
    }

    return FriendPresenceEvent(
      userId: userId,
      isOnline: _toBool(args[1]),
      lastActiveAtUtc: _toUtcDate(args[2]),
    );
  }

  FriendPresenceEvent? _mapPresenceMap(Map<String, dynamic> json) {
    final userId = json['userId']?.toString() ?? '';
    if (userId.isEmpty) {
      return null;
    }

    return FriendPresenceEvent(
      userId: userId,
      isOnline: _toBool(json['isOnline']),
      lastActiveAtUtc: _toUtcDate(json['lastActiveAtUtc']),
    );
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

  DateTime? _toUtcDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
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
