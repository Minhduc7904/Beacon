import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_member.dart';
import 'message_group_add_members_page.dart';

class MessageGroupMembersPageArgs {
  const MessageGroupMembersPageArgs({
    required this.group,
    required this.detail,
  });

  final MessageGroup group;
  final MessageGroupDetail detail;
}

class MessageGroupMembersPage extends ConsumerStatefulWidget {
  const MessageGroupMembersPage({
    super.key,
    required this.group,
    required this.detail,
  });

  final MessageGroup group;
  final MessageGroupDetail detail;

  @override
  ConsumerState<MessageGroupMembersPage> createState() =>
      _MessageGroupMembersPageState();
}

class _MessageGroupMembersPageState
    extends ConsumerState<MessageGroupMembersPage> {
  late List<MessageGroupMember> _members;
  bool _isUpdatingRole = false;
  bool _isRemovingMember = false;
  bool _hasUpdates = false;

  @override
  void initState() {
    super.initState();
    _members = widget.detail.members
        .where((member) => member.status.isJoined)
        .toList(growable: false);
  }

  int? _currentUserRole(String? currentUserId) {
    if (currentUserId == null || currentUserId.trim().isEmpty) {
      return null;
    }

    for (final member in _members) {
      if (member.userId == currentUserId) {
        return member.role;
      }
    }

    return null;
  }

  Future<bool> _confirmAction({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: AppText(
            title,
            size: AppTextSize.regular,
            spacing: AppTextSpacing.tight,
            weight: AppTextWeight.bold,
          ),
          content: AppText(
            message,
            size: AppTextSize.small,
            spacing: AppTextSpacing.normal,
            weight: AppTextWeight.regular,
            color: colorScheme.onSurface.withValues(alpha: 0.72),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                confirmLabel,
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  MessageGroupMember _copyWithRole(
    MessageGroupMember member,
    int role,
  ) {
    return MessageGroupMember(
      userId: member.userId,
      familyName: member.familyName,
      givenName: member.givenName,
      customName: member.customName,
      avatarUrl: member.avatarUrl,
      role: role,
      status: member.status,
      lastSeenMessageId: member.lastSeenMessageId,
      lastSeenAtUtc: member.lastSeenAtUtc,
    );
  }

  void _applyRoleChange({
    required String targetUserId,
    required int role,
  }) {
    final updatedMembers = _members.map((member) {
      if (member.userId == targetUserId) {
        return _copyWithRole(member, role);
      }

      return member;
    }).toList(growable: false);

    setState(() {
      _members = updatedMembers;
    });
  }

  void _removeMemberFromList(String userId) {
    setState(() {
      _members = _members
          .where((member) => member.userId != userId)
          .toList(growable: false);
    });
  }

  void _applyOwnerTransfer({required String targetUserId}) {
    final updatedMembers = _members.map((member) {
      if (member.userId == targetUserId) {
        return _copyWithRole(member, 1);
      }

      if (member.role == 1) {
        return _copyWithRole(member, 2);
      }

      return member;
    }).toList(growable: false);

    setState(() {
      _members = updatedMembers;
    });
  }

  Future<void> _updateMemberRole({
    required MessageGroupMember member,
    required int role,
    required String confirmTitle,
    required String confirmMessage,
    required String confirmLabel,
    required String successMessage,
  }) async {
    if (_isUpdatingRole) {
      return;
    }

    final confirmed = await _confirmAction(
      title: confirmTitle,
      message: confirmMessage,
      confirmLabel: confirmLabel,
    );

    if (!confirmed) {
      return;
    }

    setState(() => _isUpdatingRole = true);

    final result = await ref
        .read(updateMessageGroupMemberRoleUseCaseProvider)
        .call(
          groupId: widget.group.groupId,
          targetUserId: member.userId,
          role: role,
        );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        setState(() => _isUpdatingRole = false);
      },
      (_) {
        ref.read(appMessageProvider.notifier).addSuccess(successMessage);
        if (role == 1) {
          _applyOwnerTransfer(targetUserId: member.userId);
        } else {
          _applyRoleChange(targetUserId: member.userId, role: role);
        }
        setState(() {
          _hasUpdates = true;
          _isUpdatingRole = false;
        });
      },
    );
  }

  Future<void> _handleRemoveMember(MessageGroupMember member) async {
    if (_isRemovingMember || _isUpdatingRole) {
      return;
    }

    final confirmed = await _confirmAction(
      title: 'Xóa thành viên',
      message: 'Thành viên này sẽ bị xóa khỏi nhóm chat.',
      confirmLabel: 'Xóa',
    );

    if (!confirmed) {
      return;
    }

    setState(() => _isRemovingMember = true);

    final result = await ref
        .read(removeMessageGroupMemberUseCaseProvider)
        .call(groupId: widget.group.groupId, userId: member.userId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        setState(() => _isRemovingMember = false);
      },
      (_) {
        ref
            .read(appMessageProvider.notifier)
            .addSuccess('Đã xóa thành viên khỏi nhóm');
        _removeMemberFromList(member.userId);
        setState(() {
          _hasUpdates = true;
          _isRemovingMember = false;
        });
      },
    );
  }

  Future<void> _handlePromoteToManager(MessageGroupMember member) async {
    await _updateMemberRole(
      member: member,
      role: 2,
      confirmTitle: 'Chuyển lên quản lý',
      confirmMessage: 'Thành viên này sẽ trở thành quản lý của nhóm.',
      confirmLabel: 'Xác nhận',
      successMessage: 'Đã chuyển thành quản lý',
    );
  }

  Future<void> _handleTransferOwner(MessageGroupMember member) async {
    await _updateMemberRole(
      member: member,
      role: 1,
      confirmTitle: 'Chuyển chủ sở hữu',
      confirmMessage:
          'Bạn sẽ chuyển quyền chủ sở hữu cho thành viên này. Bạn sẽ trở thành quản lý.',
      confirmLabel: 'Chuyển chủ sở hữu',
      successMessage: 'Đã chuyển quyền chủ sở hữu',
    );
  }

  Widget? _buildPromoteAction(
    BuildContext context,
    MessageGroupMember member,
    bool isOwner,
  ) {
    if (!isOwner || member.role != 0) {
      return null;
    }

    return _MemberActionButton(
      label: 'Lên làm quản lý',
      onPressed: _isUpdatingRole || _isRemovingMember
          ? null
          : () => _handlePromoteToManager(member),
    );
  }

  Widget? _buildTransferOwnerAction(
    BuildContext context,
    MessageGroupMember member,
    bool isOwner,
  ) {
    if (!isOwner || member.role != 2) {
      return null;
    }

    return _MemberActionButton(
      label: 'Chuyển chủ sở hữu',
      onPressed: _isUpdatingRole || _isRemovingMember
          ? null
          : () => _handleTransferOwner(member),
    );
  }

  Widget? _buildRemoveAction(
    BuildContext context,
    MessageGroupMember member,
    String? currentUserId,
    int? currentRole,
  ) {
    if (currentUserId == null || currentRole == null) {
      return null;
    }

    if (member.userId == currentUserId) {
      return null;
    }

    final canRemove = currentRole == 1
        ? member.role == 0 || member.role == 2
        : currentRole == 2 && member.role == 0;

    if (!canRemove) {
      return null;
    }

    return _MemberActionButton(
      label: 'Xóa',
      color: AppColors.red500,
      disabledColor: AppColors.red500.withValues(alpha: 0.4),
      onPressed: _isUpdatingRole || _isRemovingMember
          ? null
          : () => _handleRemoveMember(member),
    );
  }

  Widget? _buildAllTabActions(
    BuildContext context,
    MessageGroupMember member,
    String? currentUserId,
    int? currentRole,
    bool isOwner,
  ) {
    final promoteAction = _buildPromoteAction(context, member, isOwner);
    final removeAction =
        _buildRemoveAction(context, member, currentUserId, currentRole);

    if (promoteAction == null && removeAction == null) {
      return null;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (promoteAction != null) promoteAction,
        if (promoteAction != null && removeAction != null)
          const SizedBox(width: 8),
        if (removeAction != null) removeAction,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final members = _members;
    final admins = members
        .where((member) => member.isAdminRole)
        .toList(growable: false);
    final currentUserId = ref.watch(meProfileProvider).valueOrNull?.id;
    final currentRole = _currentUserRole(currentUserId);
    final isOwner = currentRole == 1;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => context.pop(_hasUpdates),
          ),
          title: _MembersHeaderTitle(count: members.length),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                final added = await context.pushNamed<bool>(
                  AppRoutes.messageGroupAddMembersName,
                  extra: MessageGroupAddMembersPageArgs(
                    group: widget.group,
                    detail: widget.detail,
                  ),
                );

                if (added == true && context.mounted) {
                  context.pop(true);
                }
              },
              child: const AppText(
                'Thêm',
                size: AppTextSize.small,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.bold,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Quản trị viên'),
            ],
          ),
        ),
        body: SafeArea(
          child: AppScreenLayout(
            child: TabBarView(
              children: [
                _MembersList(
                  members: members,
                  actionBuilder: (context, member) => _buildAllTabActions(
                    context,
                    member,
                    currentUserId,
                    currentRole,
                    isOwner,
                  ),
                ),
                _MembersList(
                  members: admins,
                  emptyText: 'Chưa có quản trị viên',
                  actionBuilder: (context, member) =>
                      _buildTransferOwnerAction(context, member, isOwner),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MembersHeaderTitle extends StatelessWidget {
  const _MembersHeaderTitle({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          'Thành viên',
          size: AppTextSize.regular,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        const SizedBox(height: 2),
        AppText(
          '$count thành viên',
          size: AppTextSize.veryTiny,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.regular,
          color: colorScheme.onSurface.withValues(alpha: 0.56),
        ),
      ],
    );
  }
}

class _MembersList extends StatelessWidget {
  const _MembersList({
    required this.members,
    this.emptyText = 'Chưa có thành viên',
    this.actionBuilder,
  });

  final List<MessageGroupMember> members;
  final String emptyText;
  final Widget? Function(BuildContext context, MessageGroupMember member)?
      actionBuilder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (members.isEmpty) {
      return Center(
        child: AppText(
          emptyText,
          size: AppTextSize.small,
          spacing: AppTextSpacing.normal,
          weight: AppTextWeight.regular,
          color: colorScheme.onSurface.withValues(alpha: 0.58),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: members.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        indent: 58,
        color: colorScheme.outline.withValues(alpha: 0.16),
      ),
      itemBuilder: (context, index) {
        final member = members[index];
        final action = actionBuilder?.call(context, member);
        return _MemberTile(member: member, action: action);
      },
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, this.action});

  final MessageGroupMember member;
  final Widget? action;

  String get _name {
    final fullName = member.fullName.trim();
    return fullName.isEmpty ? 'Người dùng' : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          UserAvatar(avatarUrl: member.avatarUrl, givenName: _name, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  _name,
                  size: AppTextSize.regular,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.medium,
                  color: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                AppText(
                  member.roleLabelVi,
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.regular,
                  color: member.isAdminRole
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.56),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 12),
            action!,
          ],
        ],
      ),
    );
  }
}

class _MemberActionButton extends StatelessWidget {
  const _MemberActionButton({
    required this.label,
    required this.onPressed,
    this.color,
    this.disabledColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? disabledColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveColor = onPressed == null
        ? (disabledColor ?? colorScheme.onSurface.withValues(alpha: 0.4))
        : (color ?? colorScheme.primary);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: AppText(
        label,
        size: AppTextSize.veryTiny,
        spacing: AppTextSpacing.tight,
        weight: AppTextWeight.bold,
        color: effectiveColor,
      ),
    );
  }
}
