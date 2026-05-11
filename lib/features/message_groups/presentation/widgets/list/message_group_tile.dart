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
    this.isOnline,
  });

  final MessageGroup group;
  final VoidCallback onTap;
  final bool? isOnline;

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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _PresenceAvatar(
                avatarUrl: group.displayAvatarUrl,
                givenName: title,
                isOnline: isOnline,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    if (isOnline != null) ...[
                      const SizedBox(height: 3),
                      _PresenceStatusText(isOnline: isOnline!),
                    ],
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _MessagePreviewText(text: subtitle, hasUnread: hasUnread),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 58, maxWidth: 72),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (updatedAt != null)
                      _MessageTimeText(
                        text: _formatTime(updatedAt),
                        hasUnread: hasUnread,
                      ),
                    if (hasUnread) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: AppText(
                          group.unreadCount > 99
                              ? '99+'
                              : group.unreadCount.toString(),
                          size: AppTextSize.veryTiny,
                          spacing: AppTextSpacing.tight,
                          weight: AppTextWeight.bold,
                          color: colorScheme.onSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresenceAvatar extends StatelessWidget {
  const _PresenceAvatar({
    required this.avatarUrl,
    required this.givenName,
    required this.isOnline,
  });

  final String? avatarUrl;
  final String givenName;
  final bool? isOnline;

  @override
  Widget build(BuildContext context) {
    final online = isOnline;
    if (online == null) {
      return UserAvatar(avatarUrl: avatarUrl, givenName: givenName, size: 52);
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        UserAvatar(avatarUrl: avatarUrl, givenName: givenName, size: 52),
        Positioned(
          right: 1,
          bottom: 1,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: online ? colorScheme.primary : colorScheme.outline,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PresenceStatusText extends StatelessWidget {
  const _PresenceStatusText({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppText(
      isOnline ? 'Đang hoạt động' : 'Không hoạt động',
      size: AppTextSize.veryTiny,
      spacing: AppTextSpacing.tight,
      weight: AppTextWeight.regular,
      color: isOnline
          ? colorScheme.primary
          : colorScheme.onSurface.withValues(alpha: 0.5),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MessageTimeText extends StatelessWidget {
  const _MessageTimeText({required this.text, required this.hasUnread});

  final String text;
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme
        .ui(
          size: AppTextSize.veryTiny,
          spacing: AppTextSpacing.tight,
          weight: hasUnread ? AppTextWeight.medium : AppTextWeight.regular,
        )
        .copyWith(color: colorScheme.onSurface.withValues(alpha: 0.48));

    return SizedBox(
      width: 72,
      child: Align(
        alignment: Alignment.centerRight,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            text,
            style: style,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}

class _MessagePreviewText extends StatelessWidget {
  const _MessagePreviewText({required this.text, required this.hasUnread});

  final String text;
  final bool hasUnread;

  static const _ellipsis = '...';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textDirection = Directionality.of(context);
    final style = Theme.of(context).textTheme
        .ui(
          size: AppTextSize.small,
          spacing: AppTextSpacing.none,
          weight: hasUnread ? AppTextWeight.bold : AppTextWeight.regular,
        )
        .copyWith(
          color: hasUnread
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.55),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final displayText = _truncateToWidth(
          text: text,
          style: style,
          maxWidth: constraints.maxWidth,
          textDirection: textDirection,
        );

        return Text(
          displayText,
          style: style,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.clip,
        );
      },
    );
  }

  String _truncateToWidth({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required TextDirection textDirection,
  }) {
    if (!maxWidth.isFinite || maxWidth <= 0) {
      return text;
    }

    final painter = TextPainter(textDirection: textDirection, maxLines: 1);

    bool fits(String value) {
      painter.text = TextSpan(text: value, style: style);
      painter.layout(maxWidth: maxWidth);
      return !painter.didExceedMaxLines && painter.width <= maxWidth;
    }

    if (fits(text)) {
      return text;
    }

    var low = 0;
    var high = text.length;
    while (low < high) {
      final mid = (low + high + 1) >> 1;
      final candidate = '${text.substring(0, mid).trimRight()}$_ellipsis';
      if (fits(candidate)) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }

    return '${text.substring(0, low).trimRight()}$_ellipsis';
  }
}
