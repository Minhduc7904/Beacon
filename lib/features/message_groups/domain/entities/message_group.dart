class MessageGroup {
  final String groupId;
  final bool isPrivate;
  final DateTime? createdAtUtc;
  final String? lastMessageContent;
  final DateTime? lastMessageAtUtc;
  final String? lastMessageSenderUsername;

  const MessageGroup({
    required this.groupId,
    required this.isPrivate,
    required this.createdAtUtc,
    required this.lastMessageContent,
    required this.lastMessageAtUtc,
    required this.lastMessageSenderUsername,
  });
}
