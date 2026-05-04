class MessageGroup {
  final String groupId;
  final bool isPrivate;
  final DateTime? createdAtUtc;
  final String? lastMessageContent;
  final DateTime? lastMessageAtUtc;
  final String? lastMessageSenderFamilyName;
  final String? lastMessageSenderGivenName;

  const MessageGroup({
    required this.groupId,
    required this.isPrivate,
    required this.createdAtUtc,
    required this.lastMessageContent,
    required this.lastMessageAtUtc,
    required this.lastMessageSenderFamilyName,
    required this.lastMessageSenderGivenName,
  });

  String get lastMessageSenderFullName {
    return [
      lastMessageSenderFamilyName?.trim() ?? '',
      lastMessageSenderGivenName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
