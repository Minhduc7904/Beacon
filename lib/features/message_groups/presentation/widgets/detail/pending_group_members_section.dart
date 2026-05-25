import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icon_data.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../domain/entities/message_group_member.dart';

class PendingGroupMembersSection extends ConsumerStatefulWidget {
  const PendingGroupMembersSection({
    super.key,
    required this.groupId,
    required this.members,
    required this.canManage,
    this.onMemberApproved,
    this.onMemberDenied,
  });

  final String groupId;
  final List<MessageGroupMember> members;
  final bool canManage;
  final ValueChanged<String>? onMemberApproved;
  final ValueChanged<String>? onMemberDenied;

  @override
  ConsumerState<PendingGroupMembersSection> createState() =>
      _PendingGroupMembersSectionState();
}

class _PendingGroupMembersSectionState
    extends ConsumerState<PendingGroupMembersSection> {
  final Set<String> _busyMemberIds = <String>{};

  Future<void> _handleApprove(MessageGroupMember member) async {
    if (_busyMemberIds.contains(member.userId)) {
      return;
    }

    setState(() => _busyMemberIds.add(member.userId));

    final result = await ref
        .read(approveMessageGroupMemberUseCaseProvider)
        .call(groupId: widget.groupId, userId: member.userId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) => ref
          .read(appMessageProvider.notifier)
          .addError(failure.message.isEmpty
              ? 'Không thể duyệt thành viên'
              : failure.message),
      (_) {
        ref.read(appMessageProvider.notifier).addSuccess('Đã duyệt thành viên');
        widget.onMemberApproved?.call(member.userId);
      },
    );

    if (!mounted) {
      return;
    }
    setState(() => _busyMemberIds.remove(member.userId));
  }

  Future<void> _handleDeny(MessageGroupMember member) async {
    if (_busyMemberIds.contains(member.userId)) {
      return;
    }

    setState(() => _busyMemberIds.add(member.userId));

    final result = await ref
        .read(denyMessageGroupMemberUseCaseProvider)
        .call(groupId: widget.groupId, userId: member.userId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) => ref
          .read(appMessageProvider.notifier)
          .addError(failure.message.isEmpty
              ? 'Không thể từ chối thành viên'
              : failure.message),
      (_) {
        ref.read(appMessageProvider.notifier).addInfo('Đã từ chối thành viên');
        widget.onMemberDenied?.call(member.userId);
      },
    );

    if (!mounted) {
      return;
    }
    setState(() => _busyMemberIds.remove(member.userId));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canManage || widget.members.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenLayout(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    'Đang chờ duyệt',
                    size: AppTextSize.small,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(width: 6),
                  AppText(
                    '(${widget.members.length})',
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...widget.members.map((member) {
                final isBusy = _busyMemberIds.contains(member.userId);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _PendingMemberTile(
                    member: member,
                    isBusy: isBusy,
                    onApprove: () => _handleApprove(member),
                    onDeny: () => _handleDeny(member),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingMemberTile extends StatelessWidget {
  const _PendingMemberTile({
    required this.member,
    required this.isBusy,
    required this.onApprove,
    required this.onDeny,
  });

  final MessageGroupMember member;
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  String get _displayName {
    final fullName = member.fullName.trim();
    return fullName.isEmpty ? 'Người dùng' : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        UserAvatar(avatarUrl: member.avatarUrl, givenName: _displayName),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                _displayName,
                size: AppTextSize.small,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.medium,
                color: colorScheme.onSurface,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              AppText(
                'Chờ duyệt',
                size: AppTextSize.veryTiny,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.regular,
                color: colorScheme.onSurface.withValues(alpha: 0.56),
              ),
            ],
          ),
        ),
        _PendingActionButton(
          tooltip: 'Duyệt',
          isBusy: isBusy,
          icon: AppIcons.check,
          color: colorScheme.primary,
          onPressed: onApprove,
        ),
        const SizedBox(width: 4),
        _PendingActionButton(
          tooltip: 'Từ chối',
          isBusy: isBusy,
          icon: AppIcons.close,
          color: AppColors.red500,
          onPressed: onDeny,
        ),
      ],
    );
  }
}

class _PendingActionButton extends StatelessWidget {
  const _PendingActionButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.isBusy,
  });

  final String tooltip;
  final AppIconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: isBusy ? null : onPressed,
      icon: isBusy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : AppIcon(icon, size: 20, color: color),
    );
  }
}
