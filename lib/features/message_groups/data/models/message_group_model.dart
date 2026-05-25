import '../../domain/entities/message_group.dart';

class MessageGroupModel extends MessageGroup {
  const MessageGroupModel({
    required super.groupId,
    required super.isPrivate,
    required super.createdAtUtc,
    required super.lastMessageId,
    required super.lastMessageContent,
    required super.lastMessageAtUtc,
    required super.lastMessageSenderFamilyName,
    required super.lastMessageSenderGivenName,
    required super.lastSeenMessageId,
    required super.isSeenLatest,
    required super.unreadCount,
    required super.displayName,
    required super.displayAvatarUrl,
    required super.peerUserId,
    required super.requireApprovalToAddMembers,
  });

  factory MessageGroupModel.fromJson(Map<String, dynamic> json) {
    return MessageGroupModel(
      groupId: json['groupId']?.toString() ?? '',
      isPrivate: _toBool(json['isPrivate']) ?? json['type'] == 0,
      createdAtUtc: _toDate(json['createdAtUtc']),
      lastMessageId: json['lastMessageId']?.toString(),
      lastMessageContent: json['lastMessageContent']?.toString(),
      lastMessageAtUtc: _toDate(json['lastMessageAtUtc']),
      lastMessageSenderFamilyName: json['lastMessageSenderFamilyName']
          ?.toString(),
      lastMessageSenderGivenName:
          json['lastMessageSenderGivenName']?.toString() ??
          json['lastMessageSenderUsername']?.toString(),
      lastSeenMessageId: json['lastSeenMessageId']?.toString(),
      isSeenLatest: _toBool(json['isSeenLatest']) ?? true,
      unreadCount: _toInt(json['unreadCount']),
      displayName: json['displayName']?.toString(),
      displayAvatarUrl: json['displayAvatarUrl']?.toString(),
      peerUserId: json['peerUserId']?.toString(),
      requireApprovalToAddMembers:
          _toBool(json['requireApprovalToAddMembers']) ?? false,
    );
  }

  static bool? _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }

    final raw = value?.toString().trim().toLowerCase();
    if (raw == null || raw.isEmpty) {
      return null;
    }
    if (raw == 'true' || raw == '1') {
      return true;
    }
    if (raw == 'false' || raw == '0') {
      return false;
    }
    return null;
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

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }

    // Backend currently sends UTC timestamps without timezone suffix.
    final hasTimezoneSuffix =
        raw.endsWith('Z') ||
        raw.contains('+') ||
        raw.substring(10).contains('-');

    if (hasTimezoneSuffix) {
      return parsed.toLocal();
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
    ).toLocal();
  }
}
