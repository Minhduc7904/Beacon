class FriendPresence {
  final String userId;
  final String familyName;
  final String givenName;
  final String? avatarUrl;
  final bool isOnline;
  final DateTime? lastActiveAtUtc;

  const FriendPresence({
    required this.userId,
    required this.familyName,
    required this.givenName,
    required this.avatarUrl,
    required this.isOnline,
    required this.lastActiveAtUtc,
  });

  String get fullName {
    return [
      familyName.trim(),
      givenName.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
  }

  FriendPresence copyWith({
    String? userId,
    String? familyName,
    String? givenName,
    String? avatarUrl,
    bool? isOnline,
    DateTime? lastActiveAtUtc,
  }) {
    return FriendPresence(
      userId: userId ?? this.userId,
      familyName: familyName ?? this.familyName,
      givenName: givenName ?? this.givenName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      lastActiveAtUtc: lastActiveAtUtc ?? this.lastActiveAtUtc,
    );
  }
}
