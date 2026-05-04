import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/message_group.dart';

class MessageGroupTile extends StatelessWidget {
  const MessageGroupTile({
    super.key,
    required this.group,
    required this.onTap,
    this.displayName,
    this.avatarUrl,
    this.avatarGivenName,
  });

  final MessageGroup group;
  final VoidCallback onTap;
  final String? displayName;
  final String? avatarUrl;
  final String? avatarGivenName;

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
    final title =
        (displayName ?? group.lastMessageSenderFullName).trim().isEmpty
        ? 'Nguoi dung'
        : (displayName ?? group.lastMessageSenderFullName).trim();
    final updatedAt = group.lastMessageAtUtc ?? group.createdAtUtc;
    final subtitle = group.lastMessageContent?.trim();

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
                avatarUrl: avatarUrl,
                givenName: avatarGivenName ?? title,
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
                      weight: AppTextWeight.medium,
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
                        weight: AppTextWeight.regular,
                        color: colorScheme.onSurface.withValues(alpha: 0.55),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (updatedAt != null)
                AppText(
                  _formatTime(updatedAt),
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.regular,
                  color: colorScheme.onSurface.withValues(alpha: 0.45),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
