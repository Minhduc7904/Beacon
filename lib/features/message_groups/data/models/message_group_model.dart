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
    return DateTime.tryParse(raw);
  }
}
