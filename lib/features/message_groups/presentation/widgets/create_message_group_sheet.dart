import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../friends/domain/entities/friend_profile.dart';
import '../../domain/entities/message_group_detail.dart';
import '../controllers/create_message_group_sheet_state.dart';
import 'create_message_group_submit_button.dart';

class CreateMessageGroupSheet extends ConsumerStatefulWidget {
  const CreateMessageGroupSheet({super.key, this.onCreated});

  final Future<void> Function(MessageGroupDetail group)? onCreated;

  @override
  ConsumerState<CreateMessageGroupSheet> createState() =>
      _CreateMessageGroupSheetState();
}

class _CreateMessageGroupSheetState
    extends ConsumerState<CreateMessageGroupSheet> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createMessageGroupSheetProvider.notifier).load();
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
      ref.read(createMessageGroupSheetProvider.notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createMessageGroupSheetProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.78,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              'Tạo nhóm chat',
                              size: AppTextSize.large,
                              spacing: AppTextSpacing.tight,
                              weight: AppTextWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          AppText(
                            'Đã chọn ${state.selectedCount}',
                            size: AppTextSize.small,
                            spacing: AppTextSpacing.tight,
                            weight: AppTextWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Input(
                        controller: _searchController,
                        hintText: 'Tìm bạn bè',
                        type: InputType.leftIcon,
                        leftIcon: AppIcon(
                          AppIcons.search,
                          size: 20,
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                        onChanged: ref
                            .read(createMessageGroupSheetProvider.notifier)
                            .updateSearch,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleScroll,
                    child: _FriendSelectionList(state: state),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: CreateMessageGroupSubmitButton(
                    memberUserIds: state.selectedUserIds,
                    onCreated: widget.onCreated,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FriendSelectionList extends ConsumerWidget {
  const _FriendSelectionList({required this.state});

  final CreateMessageGroupSheetState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (state.status) {
      case CreateMessageGroupSheetStatus.initial:
      case CreateMessageGroupSheetStatus.loading:
        return Center(
          child: AppLoadingIndicator(color: colorScheme.primary, size: 24),
        );
      case CreateMessageGroupSheetStatus.error:
        return _SheetMessage(
          message: state.errorMessage ?? 'Không thể tải danh sách bạn bè',
          color: colorScheme.error,
        );
      case CreateMessageGroupSheetStatus.loaded:
        if (state.friends.isEmpty) {
          return _SheetMessage(
            message: state.search.isEmpty
                ? 'Chưa có bạn bè để chọn'
                : 'Không tìm thấy bạn bè phù hợp',
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
          itemCount: state.friends.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, _) => Divider(
            height: 1,
            indent: 64,
            color: colorScheme.outline.withValues(alpha: 0.16),
          ),
          itemBuilder: (context, index) {
            if (index >= state.friends.length) {
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

            final friend = state.friends[index];
            return _FriendSelectionTile(
              friend: friend,
              isSelected: state.isSelected(friend.userId),
              onTap: () => ref
                  .read(createMessageGroupSheetProvider.notifier)
                  .toggleFriend(friend.userId),
            );
          },
        );
    }
  }
}

class _FriendSelectionTile extends StatelessWidget {
  const _FriendSelectionTile({
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

class _SheetMessage extends StatelessWidget {
  const _SheetMessage({required this.message, required this.color});

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
