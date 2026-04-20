class User {
  final String userId;
  final String username;
  final String email;
  final String familyName;
  final String givenName;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.familyName,
    required this.givenName,
  });

  String get fullName {
    final parts = [familyName.trim(), givenName.trim()]
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.join(' ').trim();
  }
}
