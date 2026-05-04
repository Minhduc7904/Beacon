class MessageGroupMember {
  final String userId;
  final String? familyName;
  final String? givenName;
  final String? avatarUrl;

  const MessageGroupMember({
    required this.userId,
    required this.familyName,
    required this.givenName,
    required this.avatarUrl,
  });

  String get fullName {
    return [
      familyName?.trim() ?? '',
      givenName?.trim() ?? '',
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
