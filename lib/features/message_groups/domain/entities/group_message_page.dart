import 'group_message.dart';

class GroupMessagePage {
  final List<GroupMessage> items;
  final String? nextCursor;
  final int limit;
  final bool hasMore;

  const GroupMessagePage({
    required this.items,
    required this.nextCursor,
    required this.limit,
    required this.hasMore,
  });
}
