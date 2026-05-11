import '../../domain/entities/friend_presence.dart';

enum FriendsPresenceStatus { initial, loading, loaded, error }

class FriendsPresenceState {
  final FriendsPresenceStatus status;
  final List<FriendPresence> friends;
  final String? nextCursor;
  final int limit;
  final bool hasMore;
  final String? errorMessage;

  const FriendsPresenceState({
    this.status = FriendsPresenceStatus.initial,
    this.friends = const [],
    this.nextCursor,
    this.limit = 20,
    this.hasMore = false,
    this.errorMessage,
  });

  FriendPresence? friendByUserId(String? userId) {
    final id = userId?.trim();
    if (id == null || id.isEmpty) {
      return null;
    }

    for (final friend in friends) {
      if (friend.userId == id) {
        return friend;
      }
    }
    return null;
  }

  FriendsPresenceState copyWith({
    FriendsPresenceStatus? status,
    List<FriendPresence>? friends,
    String? nextCursor,
    int? limit,
    bool? hasMore,
    String? errorMessage,
  }) {
    return FriendsPresenceState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      nextCursor: nextCursor ?? this.nextCursor,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}
