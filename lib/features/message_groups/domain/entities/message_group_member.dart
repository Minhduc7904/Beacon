class MessageGroupMember {
  final String userId;
  final String? familyName;
  final String? givenName;
  final String? avatarUrl;
  final int role;
  final String? lastSeenMessageId;

  const MessageGroupMember({
    required this.userId,
    required this.familyName,
    required this.givenName,
    required this.avatarUrl,
    required this.role,
    required this.lastSeenMessageId,
  });

  String get fullName {
    return [
      familyName?.trim() ?? '',
      givenName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
