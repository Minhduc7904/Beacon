import 'friend_request.dart';

class FriendRequestPage {
  final List<FriendRequest> items;
  final String? nextCursor;
  final int limit;
  final bool hasMore;

  const FriendRequestPage({
    required this.items,
    required this.nextCursor,
    required this.limit,
    required this.hasMore,
  });
}
