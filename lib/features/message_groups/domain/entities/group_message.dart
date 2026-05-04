class GroupMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderUsername;
  final String content;
  final DateTime? createdAtUtc;

  const GroupMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderUsername,
    required this.content,
    required this.createdAtUtc,
  });
}
