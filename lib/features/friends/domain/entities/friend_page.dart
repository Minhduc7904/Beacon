import 'friend_profile.dart';

class FriendPage {
  final List<FriendProfile> items;
  final String? nextCursor;
  final int limit;
  final bool hasMore;

  const FriendPage({
    required this.items,
    required this.nextCursor,
    required this.limit,
    required this.hasMore,
  });
}
