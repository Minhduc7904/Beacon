import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/message_group.dart';

class MessageGroupTile extends StatelessWidget {
  const MessageGroupTile({super.key, required this.group, required this.onTap});

  final MessageGroup group;
  final VoidCallback onTap;

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Vua xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phut';
    if (diff.inHours < 24) return '${diff.inHours} gio';
    if (diff.inDays < 7) return '${diff.inDays} ngay';
    return '${dateTime.day}/${dateTime.month}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = group.resolvedDisplayName;
    final updatedAt = group.lastMessageAtUtc ?? group.createdAtUtc;
    final subtitle = group.lastMessageContent?.trim();
    final hasUnread = !group.isSeenLatest && group.unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              UserAvatar(
                avatarUrl: group.displayAvatarUrl,
                givenName: title,
                size: 52,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      title,
                      size: AppTextSize.regular,
                      spacing: AppTextSpacing.tight,
                      weight: hasUnread
                          ? AppTextWeight.bold
                          : AppTextWeight.medium,
                      color: colorScheme.onSurface,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      AppText(
                        subtitle,
                        size: AppTextSize.small,
                        spacing: AppTextSpacing.tight,
                        weight: hasUnread
                            ? AppTextWeight.medium
                            : AppTextWeight.regular,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (updatedAt != null)
                    AppText(
                      _formatTime(updatedAt),
                      size: AppTextSize.veryTiny,
                      spacing: AppTextSpacing.tight,
                      weight: hasUnread
                          ? AppTextWeight.medium
                          : AppTextWeight.regular,
                      color: hasUnread
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  if (hasUnread) ...[
                    const SizedBox(height: 6),
                    Container(
                      constraints: const BoxConstraints(minWidth: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppText(
                        group.unreadCount > 99
                            ? '99+'
                            : group.unreadCount.toString(),
                        size: AppTextSize.veryTiny,
                        spacing: AppTextSpacing.tight,
                        weight: AppTextWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
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
