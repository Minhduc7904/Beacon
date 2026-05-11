import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/utils/time_utils.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/group_message.dart';
import '../../../domain/entities/message_group_member.dart';
import 'group_chat_bubble.dart';

class GroupMessageList extends StatelessWidget {
  const GroupMessageList({
    super.key,
    required this.messages,
    required this.members,
    required this.scrollController,
    required this.currentUserId,
  });

  final List<GroupMessage> messages;
  final List<MessageGroupMember> members;
  final ScrollController scrollController;
  final String? currentUserId;

  Map<String, List<GroupMessage>> _groupByDate() {
    final groups = <String, List<GroupMessage>>{};

    for (final msg in messages) {
      final dt = msg.createdAtUtc ?? DateTime.now().toUtc();
      final vietnamTime = TimeUtils.toVietnamTime(dt);
      final key = _dateLabel(vietnamTime);
      groups.putIfAbsent(key, () => []).add(msg);
    }

    return groups;
  }

  String _dateLabel(DateTime vietnamTime) {
    final now = TimeUtils.nowVietnam();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(vietnamTime.year, vietnamTime.month, vietnamTime.day);
    final diff = today.difference(date).inDays;

    if (diff == 0) return 'Hom nay';
    if (diff == 1) return 'Hom qua';
    return TimeUtils.formatDate(vietnamTime);
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
    final seenByMessageId = _buildSeenByMessageId();

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
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
          seenMembers: seenByMessageId[item.message!.id] ?? const [],
          currentUserId: currentUserId,
        );
      },
    );
  }

  Map<String, List<MessageGroupMember>> _buildSeenByMessageId() {
    final messageIndexById = <String, int>{};
    for (var i = 0; i < messages.length; i++) {
      messageIndexById[messages[i].id] = i;
    }

    final seenByMessageId = <String, List<MessageGroupMember>>{};
    for (final member in members) {
      if (member.userId == currentUserId) {
        continue;
      }
      final seenId = member.lastSeenMessageId;
      if (seenId == null || seenId.isEmpty) {
        continue;
      }
      final seenIndex = messageIndexById[seenId];
      if (seenIndex == null) {
        continue;
      }
      final seenMessageId = messages[seenIndex].id;
      seenByMessageId.putIfAbsent(seenMessageId, () => []).add(member);
    }
    return seenByMessageId;
  }
}

class _GroupListItem {
  final GroupMessage? message;
  final String? headerText;

  bool get isHeader => headerText != null;

  _GroupListItem.message(GroupMessage value)
    : message = value,
      headerText = null;

  _GroupListItem.header(String value) : message = null, headerText = value;
}
