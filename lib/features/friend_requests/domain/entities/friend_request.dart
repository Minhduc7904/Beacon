class FriendRequest {
  final String id;
  final String userId;
  final String familyName;
  final String givenName;
  final String? avatarUrl;
  final DateTime? createdAtUtc;

  const FriendRequest({
    required this.id,
    required this.userId,
    required this.familyName,
    required this.givenName,
    required this.avatarUrl,
    required this.createdAtUtc,
  });

  String get fullName {
    return [
      familyName.trim(),
      givenName.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
