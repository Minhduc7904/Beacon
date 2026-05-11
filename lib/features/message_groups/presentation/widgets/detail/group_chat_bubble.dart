import 'package:flutter/material.dart';

import '../../../../../core/utils/time_utils.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/group_message.dart';
import '../../../domain/entities/message_group_member.dart';

class GroupChatBubble extends StatelessWidget {
  const GroupChatBubble({
    super.key,
    required this.message,
    required this.seenMembers,
    required this.currentUserId,
  });

  final GroupMessage message;
  final List<MessageGroupMember> seenMembers;
  final String? currentUserId;

  bool get _isMe => currentUserId != null && currentUserId == message.senderId;

  String _formatTime(DateTime dt) {
    return TimeUtils.formatTime(TimeUtils.toVietnamTime(dt));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMe = _isMe;
    final createdAt = message.createdAtUtc ?? DateTime.now();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        margin: EdgeInsets.only(
          left: isMe ? 48 : 0,
          right: isMe ? 0 : 48,
          bottom: 6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              AppText(
                message.senderFullName.isEmpty
                    ? 'Người dùng'
                    : message.senderFullName,
                size: AppTextSize.veryTiny,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.medium,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 4),
            ],
            AppText(
              message.content,
              size: AppTextSize.small,
              spacing: AppTextSpacing.normal,
              weight: AppTextWeight.regular,
              color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            AppText(
              _formatTime(createdAt),
              size: AppTextSize.veryTiny,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.regular,
              color: isMe
                  ? colorScheme.onPrimary.withValues(alpha: 0.7)
                  : colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            if (isMe && seenMembers.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < seenMembers.length && i < 3; i++)
                    Transform.translate(
                      offset: Offset(i == 0 ? 0 : -6.0 * i, 0),
                      child: _SeenAvatar(member: seenMembers[i]),
                    ),
                  if (seenMembers.length > 3)
                    AppText(
                      '+${seenMembers.length - 3}',
                      size: AppTextSize.veryTiny,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.medium,
                      color: colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SeenAvatar extends StatelessWidget {
  const _SeenAvatar({required this.member});

  final MessageGroupMember member;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final text = (member.givenName?.trim().isNotEmpty ?? false)
        ? member.givenName!.trim()
        : (member.familyName?.trim() ?? 'U');
    final initial = text.isEmpty ? 'U' : text[0].toUpperCase();

    final hasAvatarUrl =
        member.avatarUrl != null && member.avatarUrl!.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(right: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.surface, width: 1.5),
      ),
      child: CircleAvatar(
        radius: 8,
        backgroundColor: colorScheme.surfaceContainerHighest,
        backgroundImage: hasAvatarUrl ? NetworkImage(member.avatarUrl!) : null,
        child: hasAvatarUrl
            ? null
            : Text(
                initial,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
      ),
    );
  }
}
