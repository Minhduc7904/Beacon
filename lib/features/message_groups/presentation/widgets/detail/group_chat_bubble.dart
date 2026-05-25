import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/utils/time_utils.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/group_message.dart';
import '../../../domain/entities/message_group_member.dart';

class GroupChatBubble extends StatelessWidget {
  const GroupChatBubble({
    super.key,
    required this.message,
    required this.sender,
    required this.showSenderAvatar,
    required this.currentUserId,
    required this.timeRevealProgress,
    required this.contentShift,
  });

  final GroupMessage message;
  final MessageGroupMember? sender;
  final bool showSenderAvatar;
  final String? currentUserId;
  final double timeRevealProgress;
  final double contentShift;

  bool get _isMe => currentUserId != null && currentUserId == message.senderId;

  String get _senderName {
    final memberName = sender?.fullName.trim();
    if (memberName != null && memberName.isNotEmpty) {
      return memberName;
    }

    final messageName = message.senderFullName.trim();
    if (messageName.isNotEmpty) {
      return messageName;
    }

    return 'Người dùng';
  }

  String _formatTime(DateTime dt) {
    return TimeUtils.formatTime(TimeUtils.toVietnamTime(dt));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMe = _isMe;
    final createdAt = message.createdAtUtc ?? DateTime.now();
    final revealProgress = timeRevealProgress.clamp(0.0, 1.0).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Align(
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: revealProgress,
                child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: AppText(
                    _formatTime(createdAt),
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(-contentShift, 0),
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isMe) ...[
                    showSenderAvatar
                        ? UserAvatar(
                            avatarUrl: sender?.avatarUrl,
                            givenName: _senderName,
                            size: 28,
                          )
                        : const SizedBox(width: 28, height: 28),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.66,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
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
                            _senderName,
                            size: AppTextSize.veryTiny,
                            spacing: AppTextSpacing.tight,
                            weight: AppTextWeight.medium,
                            color: colorScheme.primary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                        ],
                        AppText(
                          message.content,
                          size: AppTextSize.small,
                          spacing: AppTextSpacing.normal,
                          weight: AppTextWeight.regular,
                          color: isMe
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
