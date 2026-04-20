class UserProfile {
  final String id;
  final String username;
  final String email;
  final String familyName;
  final String givenName;
  final String? phoneNumber;
  final String timeZone;
  final bool isActive;
  final bool isEmailVerified;
  final DateTime? lastLoginAtUtc;
  final DateTime createdAtUtc;
  final String? avatarMediaObjectId;
  final String? avatarUrl;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.familyName,
    required this.givenName,
    required this.phoneNumber,
    required this.timeZone,
    required this.isActive,
    required this.isEmailVerified,
    required this.lastLoginAtUtc,
    required this.createdAtUtc,
    required this.avatarMediaObjectId,
    required this.avatarUrl,
  });

  String get fullName {
    final parts = [familyName.trim(), givenName.trim()]
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.join(' ').trim();
  }
}
