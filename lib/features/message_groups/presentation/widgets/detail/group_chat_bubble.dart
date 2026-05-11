import 'package:flutter/material.dart';

import '../../../../../core/utils/time_utils.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/group_message.dart';

class GroupChatBubble extends StatelessWidget {
  const GroupChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  final GroupMessage message;
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
          ],
        ),
      ),
    );
  }
}
