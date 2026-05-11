import '../../domain/entities/friend_presence.dart';

class FriendPresenceModel extends FriendPresence {
  const FriendPresenceModel({
    required super.userId,
    required super.familyName,
    required super.givenName,
    required super.avatarUrl,
    required super.isOnline,
    required super.lastActiveAtUtc,
  });

  factory FriendPresenceModel.fromJson(Map<String, dynamic> json) {
    return FriendPresenceModel(
      userId: json['userId']?.toString() ?? '',
      familyName: json['familyName']?.toString() ?? '',
      givenName: json['givenName']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
      isOnline: _toBool(json['isOnline']),
      lastActiveAtUtc: _toUtcDate(json['lastActiveAtUtc']),
    );
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    final raw = value?.toString().trim().toLowerCase();
    return raw == 'true' || raw == '1';
  }

  static DateTime? _toUtcDate(dynamic value) {
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
