import 'message_group_member.dart';

class MessageGroupDetail {
  final String groupId;
  final bool isPrivate;
  final DateTime? createdAtUtc;
  final List<MessageGroupMember> members;

  const MessageGroupDetail({
    required this.groupId,
    required this.isPrivate,
    required this.createdAtUtc,
    required this.members,
  });
}
