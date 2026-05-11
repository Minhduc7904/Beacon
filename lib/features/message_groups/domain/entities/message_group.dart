class MessageGroup {
  final String groupId;
  final bool isPrivate;
  final DateTime? createdAtUtc;
  final String? lastMessageId;
  final String? lastMessageContent;
  final DateTime? lastMessageAtUtc;
  final String? lastMessageSenderFamilyName;
  final String? lastMessageSenderGivenName;
  final String? lastSeenMessageId;
  final bool isSeenLatest;
  final int unreadCount;
  final String? displayName;
  final String? displayAvatarUrl;

  const MessageGroup({
    required this.groupId,
    required this.isPrivate,
    required this.createdAtUtc,
    required this.lastMessageId,
    required this.lastMessageContent,
    required this.lastMessageAtUtc,
    required this.lastMessageSenderFamilyName,
    required this.lastMessageSenderGivenName,
    required this.lastSeenMessageId,
    required this.isSeenLatest,
    required this.unreadCount,
    required this.displayName,
    required this.displayAvatarUrl,
  });

  String get lastMessageSenderFullName {
    return [
      lastMessageSenderFamilyName?.trim() ?? '',
      lastMessageSenderGivenName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }

  String get resolvedDisplayName {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }

    final senderName = lastMessageSenderFullName.trim();
    if (senderName.isNotEmpty) {
      return senderName;
    }

    final shortId = groupId.length > 8 ? groupId.substring(0, 8) : groupId;
    return 'Nhom $shortId';
  }
}
