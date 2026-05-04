import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/chat_message.dart';
import 'chat_bubble.dart';

/// Builds a grouped, scrollable list of chat messages with date separators.
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;

  /// Groups messages by calendar date.
  Map<String, List<ChatMessage>> _groupByDate() {
    final groups = <String, List<ChatMessage>>{};

    for (final msg in messages) {
      final key = _dateLabel(msg.createdAt);
      groups.putIfAbsent(key, () => []).add(msg);
    }

    return groups;
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(date).inDays;

    if (diff == 0) return 'Hôm nay';
    if (diff == 1) return 'Hôm qua';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (messages.isEmpty) {
      return Center(
        child: AppText(
          'Chưa có tin nhắn nào.\nHãy bắt đầu cuộc trò chuyện! 💬',
          size: AppTextSize.small,
          spacing: AppTextSpacing.normal,
          weight: AppTextWeight.regular,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          textAlign: TextAlign.center,
        ),
      );
    }

    final groups = _groupByDate();
    final entries = groups.entries.toList();

    // Flatten into a single list with date headers
    final items = <_ChatListItem>[];
    for (final entry in entries) {
      items.add(_ChatListItem.header(entry.key));
      for (final msg in entry.value) {
        items.add(_ChatListItem.message(msg));
      }
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item.isHeader) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  item.headerText!,
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.medium,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ),
          );
        }

        return ChatBubble(message: item.chatMessage!);
      },
    );
  }
}

/// Internal tagged union for list items.
class _ChatListItem {
  final ChatMessage? chatMessage;
  final String? headerText;

  bool get isHeader => headerText != null;

  _ChatListItem.message(ChatMessage msg)
      : chatMessage = msg,
        headerText = null;

  _ChatListItem.header(String text)
      : chatMessage = null,
        headerText = text;
}
