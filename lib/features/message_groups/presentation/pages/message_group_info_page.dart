import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icon_data.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/switch_button/switch_button.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import 'message_group_add_members_page.dart';
import 'message_group_members_page.dart';
import 'message_group_notification_page.dart';
import 'message_group_search_results_page.dart';
import '../widgets/message_group_name_dialog.dart';
import '../widgets/message_group_search_dialog.dart';

final messageGroupInfoProvider = FutureProvider.autoDispose
    .family<MessageGroupDetail, MessageGroup>((ref, group) async {
      final result = await ref
          .watch(getMessageGroupDetailUseCaseProvider)
          .call(groupId: group.groupId);

      return result.fold((failure) => throw failure, (detail) => detail);
    });

class MessageGroupInfoPage extends ConsumerStatefulWidget {
  const MessageGroupInfoPage({super.key, required this.group});

  final MessageGroup group;

  @override
  ConsumerState<MessageGroupInfoPage> createState() =>
      _MessageGroupInfoPageState();
}

class _MessageGroupInfoPageState extends ConsumerState<MessageGroupInfoPage> {
  bool _isUpdatingApproval = false;
  bool _isUpdatingAvatar = false;
  bool _isDeleting = false;
  bool _isLeaving = false;

  bool _isOwner(MessageGroupDetail detail, String? currentUserId) {
    if (currentUserId == null || currentUserId.trim().isEmpty) {
      return false;
    }

    for (final member in detail.members) {
      if (member.userId == currentUserId && member.role == 1) {
        return true;
      }
    }
    return false;
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
                style: TextStyle(color: colorScheme.error),
              ),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<void> _handleDeleteGroup() async {
    if (_isDeleting || _isLeaving) {
      return;
    }

    final confirmed = await _confirmAction(
      title: 'Xóa đoạn chat',
      message: 'Đoạn chat sẽ bị xóa cho tất cả thành viên.',
      confirmLabel: 'Xóa',
    );
    if (!confirmed) {
      return;
    }

    setState(() => _isDeleting = true);

    final result = await ref
        .read(deleteMessageGroupUseCaseProvider)
        .call(groupId: widget.group.groupId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        setState(() => _isDeleting = false);
      },
      (_) {
        ref
            .read(appMessageProvider.notifier)
            .addSuccess('Đã xóa đoạn chat');
        context.goNamed(AppRoutes.messageListName);
      },
    );
  }

  Future<void> _handleLeaveGroup() async {
    if (_isDeleting || _isLeaving) {
      return;
    }

    final confirmed = await _confirmAction(
      title: 'Rời khỏi đoạn chat',
      message: 'Bạn sẽ rời khỏi đoạn chat này.',
      confirmLabel: 'Rời khỏi',
    );
    if (!confirmed) {
      return;
    }

    setState(() => _isLeaving = true);

    final result = await ref
        .read(leaveMessageGroupUseCaseProvider)
        .call(groupId: widget.group.groupId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        setState(() => _isLeaving = false);
      },
      (_) {
        ref
            .read(appMessageProvider.notifier)
            .addSuccess('Đã rời khỏi đoạn chat');
        context.goNamed(AppRoutes.messageListName);
      },
    );
  }

  Future<void> _handleToggleRequireApproval(
    MessageGroupDetail detail,
    bool value,
  ) async {
    if (_isUpdatingApproval) {
      return;
    }

    setState(() => _isUpdatingApproval = true);

    final result = await ref
        .read(updateMessageGroupRequireApprovalUseCaseProvider)
        .call(
          groupId: detail.groupId,
          requireApprovalToAddMembers: value,
        );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
      },
      (_) {
        ref.read(appMessageProvider.notifier).addSuccess(
          value
              ? 'Đã bật yêu cầu duyệt thành viên'
              : 'Đã tắt yêu cầu duyệt thành viên',
        );
        ref.invalidate(messageGroupInfoProvider(widget.group));
      },
    );

    if (mounted) {
      setState(() => _isUpdatingApproval = false);
    }
  }

  Future<void> _handleChangeAvatar(MessageGroupDetail detail) async {
    if (_isUpdatingAvatar) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    final filePath = result.files.single.path?.trim() ?? '';
    if (filePath.isEmpty) {
      ref
          .read(appMessageProvider.notifier)
          .addError('Không đọc được đường dẫn ảnh đã chọn');
      return;
    }

    setState(() => _isUpdatingAvatar = true);

    final response = await ref
        .read(updateMessageGroupAvatarUseCaseProvider)
        .call(groupId: detail.groupId, filePath: filePath);

    if (!mounted) {
      return;
    }

    response.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        setState(() => _isUpdatingAvatar = false);
      },
      (_) {
        ref
            .read(appMessageProvider.notifier)
            .addSuccess('Đã cập nhật ảnh nhóm');
        ref.invalidate(messageGroupInfoProvider(widget.group));
        setState(() => _isUpdatingAvatar = false);
      },
    );
  }

  Future<void> _handleEditName(MessageGroupDetail detail) async {
    final currentName = detail.displayName?.trim();
    final initialName = (currentName != null && currentName.isNotEmpty)
        ? currentName
        : widget.group.resolvedDisplayName;

    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => MessageGroupNameDialog(
        groupId: detail.groupId,
        initialName: initialName,
        onUpdated: () {
          ref.invalidate(messageGroupInfoProvider(widget.group));
        },
      ),
    );

    if (updated == true) {
      ref.invalidate(messageGroupInfoProvider(widget.group));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final detailAsync = ref.watch(messageGroupInfoProvider(widget.group));
    final currentUserId = ref.watch(meProfileProvider).valueOrNull?.id;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          'Thông tin nhóm',
          size: AppTextSize.large,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AppScreenLayout(
          child: detailAsync.when(
            loading: () => Center(
              child: AppLoadingIndicator(color: colorScheme.primary, size: 24),
            ),
            error: (error, _) => Center(
              child: AppText(
                'Không thể tải thông tin nhóm',
                size: AppTextSize.small,
                spacing: AppTextSpacing.normal,
                weight: AppTextWeight.regular,
                color: colorScheme.error,
                textAlign: TextAlign.center,
              ),
            ),
            data: (detail) => _MessageGroupInfoBody(
              group: widget.group,
              detail: detail,
              isOwner: _isOwner(detail, currentUserId),
              isUpdatingApproval: _isUpdatingApproval,
              isUpdatingAvatar: _isUpdatingAvatar,
              onChangeAvatar: () => _handleChangeAvatar(detail),
              onEditName: () => _handleEditName(detail),
              onDeleteGroup:
                  _isDeleting || _isLeaving ? null : _handleDeleteGroup,
              onLeaveGroup:
                  _isDeleting || _isLeaving ? null : _handleLeaveGroup,
              onToggleRequireApproval: _isUpdatingApproval
                  ? null
                  : (value) => _handleToggleRequireApproval(detail, value),
              onAddMembers: () async {
                final added = await context.pushNamed<bool>(
                  AppRoutes.messageGroupAddMembersName,
                  extra: MessageGroupAddMembersPageArgs(
                    group: widget.group,
                    detail: detail,
                  ),
                );

                if (added == true) {
                  ref.invalidate(messageGroupInfoProvider(widget.group));
                }
              },
              onOpenNicknames: () async {
                final updated = await context.pushNamed<bool>(
                  AppRoutes.messageGroupNicknamesName,
                  extra: widget.group,
                );

                if (updated == true) {
                  ref.invalidate(messageGroupInfoProvider(widget.group));
                }
              },
              onOpenMembers: () async {
                final added = await context.pushNamed<bool>(
                  AppRoutes.messageGroupMembersName,
                  extra: MessageGroupMembersPageArgs(
                    group: widget.group,
                    detail: detail,
                  ),
                );

                if (added == true) {
                  ref.invalidate(messageGroupInfoProvider(widget.group));
                }
              },
              onOpenNotifications: () {
                context.pushNamed(
                  AppRoutes.messageGroupNotificationName,
                  extra: MessageGroupNotificationPageArgs(
                    groupId: detail.groupId,
                    isMuted: detail.isMuted,
                  ),
                );
              },
              onSearch: () async {
                final keyword = await MessageGroupSearchDialog.show(context);
                if (keyword == null || !context.mounted) {
                  return;
                }

                final displayName = detail.displayName?.trim();
                final groupName = (displayName != null && displayName.isNotEmpty)
                    ? displayName
                    : widget.group.resolvedDisplayName;

                context.pushNamed(
                  AppRoutes.messageGroupSearchResultsName,
                  extra: MessageGroupSearchResultsArgs(
                    groupId: widget.group.groupId,
                    groupName: groupName,
                    keyword: keyword,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageGroupInfoBody extends StatelessWidget {
  const _MessageGroupInfoBody({
    required this.group,
    required this.detail,
    required this.isOwner,
    required this.isUpdatingApproval,
    required this.isUpdatingAvatar,
    required this.onChangeAvatar,
    required this.onEditName,
    required this.onAddMembers,
    required this.onOpenNicknames,
    required this.onOpenMembers,
    required this.onOpenNotifications,
    required this.onSearch,
    required this.onLeaveGroup,
    required this.onDeleteGroup,
    required this.onToggleRequireApproval,
  });

  final MessageGroup group;
  final MessageGroupDetail detail;
  final bool isOwner;
  final bool isUpdatingApproval;
  final bool isUpdatingAvatar;
  final VoidCallback onChangeAvatar;
  final VoidCallback onEditName;
  final VoidCallback onAddMembers;
  final VoidCallback onOpenNicknames;
  final VoidCallback onOpenMembers;
  final VoidCallback onOpenNotifications;
  final VoidCallback onSearch;
  final VoidCallback? onLeaveGroup;
  final VoidCallback? onDeleteGroup;
  final ValueChanged<bool>? onToggleRequireApproval;

  String get _displayName {
    final detailName = detail.displayName?.trim();
    if (detailName != null && detailName.isNotEmpty) {
      return detailName;
    }

    return group.resolvedDisplayName;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final joinedCount = detail.members
        .where((member) => member.status.isJoined)
        .length;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        Center(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  UserAvatar(
                    avatarUrl: detail.displayAvatarUrl ?? group.displayAvatarUrl,
                    givenName: _displayName,
                    size: 82,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isUpdatingAvatar ? null : onChangeAvatar,
                        borderRadius: BorderRadius.circular(18),
                        child: Ink(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: isUpdatingAvatar
                              ? const Padding(
                                  padding: EdgeInsets.all(7),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.sky100,
                                  ),
                                )
                              : const AppIcon(
                                  AppIcons.camera,
                                  size: 16,
                                  color: AppColors.sky100,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onEditName,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width - 72,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: AppText(
                              _displayName,
                              size: AppTextSize.large,
                              spacing: AppTextSpacing.tight,
                              weight: AppTextWeight.bold,
                              color: colorScheme.onSurface,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          AppIcon(
                            AppIcons.pencil,
                            size: 18,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _GroupInfoActionRow(
                onAddMembers: onAddMembers,
                onOpenNicknames: onOpenNicknames,
                onSearch: onSearch,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        _SectionLabel(text: '$joinedCount thành viên'),
        const SizedBox(height: 8),
        _InfoActionTile(
          icon: AppIcons.users,
          label: 'Xem thành viên trong đoạn chat',
          onTap: onOpenMembers,
        ),
        const SizedBox(height: 22),
        if (isOwner) ...[
          const _SectionLabel(text: 'Cài đặt'),
          const SizedBox(height: 8),
          AppSwitchButton(
            label: 'Yêu cầu duyệt thêm thành viên',
            description: 'Chỉ chủ nhóm mới được thay đổi cài đặt này.',
            value: detail.requireApprovalToAddMembers,
            onChanged: onToggleRequireApproval,
            enabled: !isUpdatingApproval,
          ),
          const SizedBox(height: 22),
        ],
        const _SectionLabel(text: 'Thông báo'),
        const SizedBox(height: 8),
        _InfoActionTile(
          icon: AppIcons.notification,
          label: 'Thông báo và âm thanh',
          onTap: onOpenNotifications,
        ),
        const SizedBox(height: 28),
        if (isOwner) ...[
          _InfoActionTile(
            icon: AppIcons.trash,
            label: 'Xóa đoạn chat',
            isDestructive: true,
            onTap: onDeleteGroup,
          ),
          const SizedBox(height: 14),
        ],
        _InfoActionTile(
          icon: AppIcons.signOut,
          label: 'Rời khỏi đoạn chat',
          isDestructive: true,
          onTap: onLeaveGroup,
        ),
      ],
    );
  }
}

class _GroupInfoActionRow extends StatelessWidget {
  const _GroupInfoActionRow({
    required this.onAddMembers,
    required this.onOpenNicknames,
    required this.onSearch,
  });

  final VoidCallback onAddMembers;
  final VoidCallback onOpenNicknames;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundInfoAction(
          icon: AppIcons.plus,
          label: 'Thêm',
          onTap: onAddMembers,
        ),
        const SizedBox(width: 18),
        _RoundInfoAction(
          icon: AppIcons.pencil,
          label: 'Biệt danh',
          onTap: onOpenNicknames,
        ),
        const SizedBox(width: 18),
        _RoundInfoAction(
          icon: AppIcons.search,
          label: 'Tìm kiếm',
          onTap: onSearch,
        ),
      ],
    );
  }
}

class _RoundInfoAction extends StatelessWidget {
  const _RoundInfoAction({required this.icon, required this.label, this.onTap});

  final AppIconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Material(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 46,
                height: 46,
                child: Center(
                  child: AppIcon(icon, size: 22, color: colorScheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          AppText(
            label,
            size: AppTextSize.veryTiny,
            spacing: AppTextSpacing.tight,
            weight: AppTextWeight.medium,
            color: colorScheme.onSurface,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppText(
      text,
      size: AppTextSize.small,
      spacing: AppTextSpacing.tight,
      weight: AppTextWeight.bold,
      color: colorScheme.onSurface.withValues(alpha: 0.62),
    );
  }
}

class _InfoActionTile extends StatelessWidget {
  const _InfoActionTile({
    required this.icon,
    required this.label,
    this.isDestructive = false,
    this.onTap,
  });

  final AppIconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = isDestructive ? AppColors.red500 : colorScheme.onSurface;
    final iconBackground = isDestructive
        ? AppColors.red500.withValues(alpha: 0.12)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.72);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AppIcon(icon, size: 21, color: foreground),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  label,
                  size: AppTextSize.regular,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.medium,
                  color: foreground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
