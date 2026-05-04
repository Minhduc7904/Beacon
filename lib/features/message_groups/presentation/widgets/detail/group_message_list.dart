import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/group_message.dart';
import 'group_chat_bubble.dart';

class GroupMessageList extends StatelessWidget {
  const GroupMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.currentUserId,
  });

  final List<GroupMessage> messages;
  final ScrollController scrollController;
  final String? currentUserId;

  Map<String, List<GroupMessage>> _groupByDate() {
    final groups = <String, List<GroupMessage>>{};

    for (final msg in messages) {
      final dt = msg.createdAtUtc ?? DateTime.now();
      final key = _dateLabel(dt);
      groups.putIfAbsent(key, () => []).add(msg);
    }

    return groups;
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(date).inDays;

    if (diff == 0) return 'Hom nay';
    if (diff == 1) return 'Hom qua';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (messages.isEmpty) {
      return Center(
        child: AppText(
          'Chua co tin nhan nao.\nHay bat dau cuoc tro chuyen!',
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

    final items = <_GroupListItem>[];
    for (final entry in entries) {
      items.add(_GroupListItem.header(entry.key));
      for (final msg in entry.value) {
        items.add(_GroupListItem.message(msg));
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

        return GroupChatBubble(
          message: item.message!,
          currentUserId: currentUserId,
        );
      },
    );
  }
}

class _GroupListItem {
  final GroupMessage? message;
  final String? headerText;

  bool get isHeader => headerText != null;

  _GroupListItem.message(GroupMessage value)
      : message = value,
        headerText = null;

  _GroupListItem.header(String value)
      : message = null,
        headerText = value;
}
