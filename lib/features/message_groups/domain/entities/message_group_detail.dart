import 'message_group_member.dart';

class MessageGroupDetail {
  final String groupId;
  final bool isPrivate;
  final DateTime? createdAtUtc;
  final String? displayName;
  final String? displayAvatarUrl;
  final List<MessageGroupMember> members;
  final bool requireApprovalToAddMembers;

  const MessageGroupDetail({
    required this.groupId,
    required this.isPrivate,
    required this.createdAtUtc,
    required this.displayName,
    required this.displayAvatarUrl,
    required this.members,
    required this.requireApprovalToAddMembers,
  });
}
