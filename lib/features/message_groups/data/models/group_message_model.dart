import '../../domain/entities/group_message.dart';

class GroupMessageModel extends GroupMessage {
  const GroupMessageModel({
    required super.id,
    required super.groupId,
    required super.senderId,
    required super.senderFamilyName,
    required super.senderGivenName,
    required super.content,
    required super.createdAtUtc,
  });

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) {
    return GroupMessageModel(
      id: json['id']?.toString() ?? '',
      groupId: json['groupId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderFamilyName: json['senderFamilyName']?.toString() ?? '',
      senderGivenName:
          json['senderGivenName']?.toString() ??
          json['senderUsername']?.toString() ??
          '',
      content: json['content']?.toString() ?? '',
      createdAtUtc: _toDate(json['createdAtUtc']),
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
