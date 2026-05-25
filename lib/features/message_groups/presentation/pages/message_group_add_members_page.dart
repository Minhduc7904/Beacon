import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../friends/domain/entities/friend_profile.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import '../controllers/add_group_members_state.dart';

class MessageGroupAddMembersPageArgs {
  const MessageGroupAddMembersPageArgs({required this.group, this.detail});

  final MessageGroup group;
  final MessageGroupDetail? detail;
}

class MessageGroupAddMembersPage extends ConsumerStatefulWidget {
  const MessageGroupAddMembersPage({
    super.key,
    required this.group,
    this.detail,
  });

  final MessageGroup group;
  final MessageGroupDetail? detail;

  @override
  ConsumerState<MessageGroupAddMembersPage> createState() =>
      _MessageGroupAddMembersPageState();
}

class _MessageGroupAddMembersPageState
    extends ConsumerState<MessageGroupAddMembersPage> {
  final TextEditingController _searchController = TextEditingController();

  Set<String> get _existingMemberIds {
    final members = widget.detail?.members;
    if (members == null) {
      return const <String>{};
    }

    return members
        .map((member) => member.userId.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addGroupMembersProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent - metrics.pixels <= 260) {
      ref.read(addGroupMembersProvider.notifier).loadMore();
    }
    return false;
  }

  Future<void> _submit() async {
    final success = await ref
        .read(addGroupMembersProvider.notifier)
        .submit(groupId: widget.group.groupId);

    if (success && mounted) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addGroupMembersProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final selectedCount = state.selectedCount;
    final canSubmit = selectedCount > 0 && !state.isSubmitting;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(false),
        ),
        title: AppText(
          'Thêm người',
          size: AppTextSize.large,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 72,
            child: selectedCount == 0
                ? const SizedBox.shrink()
                : Center(
                    child: TextButton(
                      onPressed: canSubmit ? _submit : null,
                      child: state.isSubmitting
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: AppLoadingIndicator(
                                color: colorScheme.primary,
                                size: 18,
                                strokeWidth: 2,
                              ),
                            )
                          : AppText(
                              'Thêm',
                              size: AppTextSize.small,
                              spacing: AppTextSpacing.tight,
                              weight: AppTextWeight.bold,
                              color: colorScheme.primary,
                            ),
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: AppScreenLayout(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
                child: Input(
                  controller: _searchController,
                  hintText: 'Tìm bạn bè',
                  type: InputType.leftIcon,
                  leftIcon: AppIcon(
                    AppIcons.search,
                    size: 20,
                    color: colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                  onChanged: ref
                      .read(addGroupMembersProvider.notifier)
                      .updateSearch,
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: _handleScroll,
                  child: _AddMembersFriendList(
                    state: state,
                    existingMemberIds: _existingMemberIds,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddMembersFriendList extends ConsumerWidget {
  const _AddMembersFriendList({
    required this.state,
    required this.existingMemberIds,
  });

  final AddGroupMembersState state;
  final Set<String> existingMemberIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleFriends = state.friends
        .where((friend) => !existingMemberIds.contains(friend.userId))
        .toList(growable: false);

    switch (state.status) {
      case AddGroupMembersStatus.initial:
      case AddGroupMembersStatus.loading:
        return Center(
          child: AppLoadingIndicator(color: colorScheme.primary, size: 24),
        );
      case AddGroupMembersStatus.error:
        return _PageMessage(
          message: state.errorMessage ?? 'Không thể tải danh sách bạn bè',
          color: colorScheme.error,
        );
      case AddGroupMembersStatus.loaded:
        if (visibleFriends.isEmpty) {
          return _PageMessage(
            message: state.search.isEmpty
                ? 'Chưa có bạn bè để thêm'
                : 'Không tìm thấy bạn bè phù hợp',
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: visibleFriends.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => Divider(
            height: 1,
            indent: 64,
            color: colorScheme.outline.withValues(alpha: 0.16),
          ),
          itemBuilder: (context, index) {
            if (index >= visibleFriends.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: AppLoadingIndicator(
                    color: colorScheme.primary,
                    size: 18,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final friend = visibleFriends[index];
            return _AddMemberFriendTile(
              friend: friend,
              isSelected: state.isSelected(friend.userId),
              onTap: () => ref
                  .read(addGroupMembersProvider.notifier)
                  .toggleFriend(friend.userId),
            );
          },
        );
    }
  }
}

class _AddMemberFriendTile extends StatelessWidget {
  const _AddMemberFriendTile({
    required this.friend,
    required this.isSelected,
    required this.onTap,
  });

  final FriendProfile friend;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fullName = friend.fullName.trim().isEmpty
        ? 'Người dùng'
        : friend.fullName.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              UserAvatar(
                avatarUrl: friend.avatarUrl,
                givenName: friend.givenName.trim().isEmpty
                    ? fullName
                    : friend.givenName,
                size: 48,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AppText(
                  fullName,
                  size: AppTextSize.regular,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.medium,
                  color: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              _SelectionIconButton(isSelected: isSelected),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionIconButton extends StatelessWidget {
  const _SelectionIconButton({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Center(
        child: AppIcon(
          isSelected ? AppIcons.check : AppIcons.plus,
          size: 18,
          color: isSelected ? colorScheme.onPrimary : AppColors.ink500,
        ),
      ),
    );
  }
}

class _PageMessage extends StatelessWidget {
  const _PageMessage({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: AppText(
          message,
          size: AppTextSize.small,
          spacing: AppTextSpacing.normal,
          weight: AppTextWeight.regular,
          color: color,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
