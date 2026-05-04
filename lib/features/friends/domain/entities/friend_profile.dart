import 'friend_type.dart';

class FriendProfile {
  final String userId;
  final String username;
  final String? avatarUrl;
  final FriendType type;
  final int friendshipStatus;
  final DateTime? createdAtUtc;
  final String messageGroupId;

  const FriendProfile({
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.type,
    this.friendshipStatus = 1,
    required this.createdAtUtc,
    required this.messageGroupId,
  });
}
