import '../../domain/entities/message_group_member.dart';

class MessageGroupMemberModel extends MessageGroupMember {
  const MessageGroupMemberModel({
    required super.userId,
    required super.familyName,
    required super.givenName,
    required super.avatarUrl,
    required super.role,
    required super.lastSeenMessageId,
  });

  factory MessageGroupMemberModel.fromJson(Map<String, dynamic> json) {
    return MessageGroupMemberModel(
      userId: json['userId']?.toString() ?? '',
      familyName: json['familyName']?.toString(),
      givenName: json['givenName']?.toString() ?? json['username']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      role: _toInt(json['role']),
      lastSeenMessageId: json['lastSeenMessageId']?.toString(),
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
}
