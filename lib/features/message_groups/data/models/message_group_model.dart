import '../../domain/entities/message_group.dart';

class MessageGroupModel extends MessageGroup {
  const MessageGroupModel({
    required super.groupId,
    required super.isPrivate,
    required super.createdAtUtc,
    required super.lastMessageContent,
    required super.lastMessageAtUtc,
    required super.lastMessageSenderFamilyName,
    required super.lastMessageSenderGivenName,
  });

  factory MessageGroupModel.fromJson(Map<String, dynamic> json) {
    return MessageGroupModel(
      groupId: json['groupId']?.toString() ?? '',
      isPrivate: json['isPrivate'] == true,
      createdAtUtc: _toDate(json['createdAtUtc']),
      lastMessageContent: json['lastMessageContent']?.toString(),
      lastMessageAtUtc: _toDate(json['lastMessageAtUtc']),
      lastMessageSenderFamilyName: json['lastMessageSenderFamilyName']
          ?.toString(),
      lastMessageSenderGivenName:
          json['lastMessageSenderGivenName']?.toString() ??
          json['lastMessageSenderUsername']?.toString(),
    );
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
