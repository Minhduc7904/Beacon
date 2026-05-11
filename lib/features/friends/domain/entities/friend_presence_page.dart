import 'friend_presence.dart';

class FriendPresencePage {
  final List<FriendPresence> items;
  final String? nextCursor;
  final int limit;
  final bool hasMore;

  const FriendPresencePage({
    required this.items,
    required this.nextCursor,
    required this.limit,
    required this.hasMore,
  });
}
