class MessageGroupMember {
  final String userId;
  final String username;
  final String? familyName;
  final String? givenName;
  final String? avatarUrl;

  const MessageGroupMember({
    required this.userId,
    required this.username,
    required this.familyName,
    required this.givenName,
    required this.avatarUrl,
  });
}
