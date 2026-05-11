class FriendPresenceEvent {
  final String userId;
  final bool isOnline;
  final DateTime? lastActiveAtUtc;

  const FriendPresenceEvent({
    required this.userId,
    required this.isOnline,
    required this.lastActiveAtUtc,
  });
}
