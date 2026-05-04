import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/conversation.dart';

/// A single conversation row in the conversation list.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    if (diff.inDays < 7) return '${diff.inDays} ngày';
    return '${dateTime.day}/${dateTime.month}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUnread = conversation.unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // ── Avatar ──
              UserAvatar(
                avatarUrl: conversation.participantAvatarUrl,
                givenName: conversation.participantName,
                size: 52,
              ),
              const SizedBox(width: 14),

              // ── Name + last message ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      conversation.participantName,
                      size: AppTextSize.regular,
                      spacing: AppTextSpacing.tight,
                      weight: hasUnread
                          ? AppTextWeight.bold
                          : AppTextWeight.medium,
                      color: colorScheme.onSurface,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (conversation.lastMessage != null) ...[
                      const SizedBox(height: 4),
                      AppText(
                        conversation.lastMessage!.isMe
                            ? 'Bạn: ${conversation.lastMessage!.content}'
                            : conversation.lastMessage!.content,
                        size: AppTextSize.small,
                        spacing: AppTextSpacing.tight,
                        weight: hasUnread
                            ? AppTextWeight.medium
                            : AppTextWeight.regular,
                        color: hasUnread
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.55),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // ── Time + unread badge ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    _formatTime(conversation.updatedAt),
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: hasUnread
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                  if (hasUnread) ...[
                    const SizedBox(height: 6),
                    _UnreadBadge(count: conversation.unreadCount),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = count > 99 ? '99+' : '$count';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: AppText(
        label,
        size: AppTextSize.veryTiny,
        spacing: AppTextSpacing.tight,
        weight: AppTextWeight.bold,
        color: colorScheme.onPrimary,
      ),
    );
  }
}
