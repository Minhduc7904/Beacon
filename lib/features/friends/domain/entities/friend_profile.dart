import 'friend_type.dart';

class FriendProfile {
  final String userId;
  final String familyName;
  final String givenName;
  final String? avatarUrl;
  final FriendType type;
  final int friendshipStatus;
  final DateTime? createdAtUtc;
  final String messageGroupId;

  const FriendProfile({
    required this.userId,
    required this.familyName,
    required this.givenName,
    required this.avatarUrl,
    required this.type,
    this.friendshipStatus = 1,
    required this.createdAtUtc,
    required this.messageGroupId,
  });

  String get fullName {
    return [
      familyName.trim(),
      givenName.trim(),
    ].where((part) => part.isNotEmpty).join(' ');
  }
}
