import '../../domain/entities/message_group_member.dart';

class MessageGroupMemberModel extends MessageGroupMember {
  const MessageGroupMemberModel({
    required super.userId,
    required super.familyName,
    required super.givenName,
    required super.avatarUrl,
  });

  factory MessageGroupMemberModel.fromJson(Map<String, dynamic> json) {
    return MessageGroupMemberModel(
      userId: json['userId']?.toString() ?? '',
      familyName: json['familyName']?.toString(),
      givenName: json['givenName']?.toString() ?? json['username']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}
