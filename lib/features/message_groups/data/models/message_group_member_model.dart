import '../../domain/entities/message_group_member.dart';

class MessageGroupMemberModel extends MessageGroupMember {
  const MessageGroupMemberModel({
    required super.userId,
    required super.familyName,
    required super.givenName,
    required super.customName,
    required super.avatarUrl,
    required super.role,
    required super.lastSeenMessageId,
    required super.lastSeenAtUtc,
  });

  factory MessageGroupMemberModel.fromJson(Map<String, dynamic> json) {
    return MessageGroupMemberModel(
      userId: json['userId']?.toString() ?? '',
      familyName: json['familyName']?.toString(),
      givenName: json['givenName']?.toString() ?? json['username']?.toString(),
      customName: json['customName']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      role: _toInt(json['role']),
      lastSeenMessageId: json['lastSeenMessageId']?.toString(),
      lastSeenAtUtc: _toUtcDate(
        json['lastSeenAtUtc'] ??
            json['lastSeenAt'] ??
            json['seenAtUtc'] ??
            json['seenAt'] ??
            json['readAtUtc'] ??
            json['readAt'],
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
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
        (raw.length > 10 && raw.substring(10).contains('-'));
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
