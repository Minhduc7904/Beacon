import 'message_group.dart';

class MessageGroupPage {
  final List<MessageGroup> items;
  final String? nextCursor;
  final int limit;
  final bool hasMore;

  const MessageGroupPage({
    required this.items,
    required this.nextCursor,
    required this.limit,
    required this.hasMore,
  });
}
