import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/utils/time_utils.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/message_group_member.dart';

class GroupMessageSeenIndicator extends StatelessWidget {
  const GroupMessageSeenIndicator({
    super.key,
    required this.seenMembers,
    required this.isPrivateChat,
    required this.contentShift,
  });

  static const int _maxVisibleGroupAvatars = 3;
  static const double _avatarSize = 18;
  static const double _avatarOverlap = 6;

  final List<MessageGroupMember> seenMembers;
  final bool isPrivateChat;
  final double contentShift;

  @override
  Widget build(BuildContext context) {
    if (seenMembers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Transform.translate(
      offset: Offset(-contentShift, 0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(left: 48, right: 4, bottom: 8),
          child: isPrivateChat
              ? _PrivateSeenText(member: seenMembers.first)
              : _GroupSeenAvatars(
                  members: seenMembers,
                  maxVisibleAvatars: _maxVisibleGroupAvatars,
                  avatarSize: _avatarSize,
                  avatarOverlap: _avatarOverlap,
                ),
        ),
      ),
    );
  }
}

class _PrivateSeenText extends StatelessWidget {
  const _PrivateSeenText({required this.member});

  final MessageGroupMember member;

  String _label() {
    final seenAtUtc = member.lastSeenAtUtc;
    if (seenAtUtc == null) {
      return 'Đã xem';
    }

    final seenAt = TimeUtils.toVietnamTime(seenAtUtc);
    final time = TimeUtils.formatTime(seenAt);
    final now = TimeUtils.nowVietnam();
    if (TimeUtils.isSameDay(seenAt, now)) {
      return 'Đã xem lúc $time';
    }

    return 'Đã xem lúc $time ${TimeUtils.formatDate(seenAt)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppText(
      _label(),
      size: AppTextSize.tiny,
      spacing: AppTextSpacing.tight,
      weight: AppTextWeight.regular,
      color: colorScheme.onSurface.withValues(alpha: 0.55),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _GroupSeenAvatars extends StatelessWidget {
  const _GroupSeenAvatars({
    required this.members,
    required this.maxVisibleAvatars,
    required this.avatarSize,
    required this.avatarOverlap,
  });

  final List<MessageGroupMember> members;
  final int maxVisibleAvatars;
  final double avatarSize;
  final double avatarOverlap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleCount = math.min(members.length, maxVisibleAvatars);
    final extraCount = members.length - visibleCount;
    final stackWidth =
        avatarSize + math.max(0, visibleCount - 1) * (avatarSize - avatarOverlap);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: stackWidth,
          height: avatarSize,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < visibleCount; i++)
                Positioned(
                  left: i * (avatarSize - avatarOverlap),
                  child: _SeenAvatar(member: members[i], size: avatarSize),
                ),
            ],
          ),
        ),
        if (extraCount > 0) ...[
          const SizedBox(width: 4),
          AppText(
            '+$extraCount',
            size: AppTextSize.veryTiny,
            spacing: AppTextSpacing.tight,
            weight: AppTextWeight.medium,
            color: colorScheme.onSurface.withValues(alpha: 0.58),
          ),
        ],
      ],
    );
  }
}

class _SeenAvatar extends StatelessWidget {
  const _SeenAvatar({required this.member, required this.size});

  final MessageGroupMember member;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final givenName = (member.givenName?.trim().isNotEmpty ?? false)
        ? member.givenName!.trim()
        : member.familyName?.trim();

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surface,
      ),
      child: UserAvatar(
        avatarUrl: member.avatarUrl,
        givenName: givenName,
        size: size - 2,
        initialStyle: textTheme.ui(
          size: AppTextSize.veryTiny,
          spacing: AppTextSpacing.none,
          weight: AppTextWeight.medium,
        ),
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
      ),
    );
  }
}
