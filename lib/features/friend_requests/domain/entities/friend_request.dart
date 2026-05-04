class FriendRequest {
  final String id;
  final String senderId;
  final String senderUsername;
  final String? senderAvatarUrl;
  final DateTime? createdAtUtc;

  const FriendRequest({
    required this.id,
    required this.senderId,
    required this.senderUsername,
    required this.senderAvatarUrl,
    required this.createdAtUtc,
  });
}
