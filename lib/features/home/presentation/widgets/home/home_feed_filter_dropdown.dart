import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/popup/app_popup_overlay.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../../feed/domain/entities/feed_filter.dart';
import '../../../../feed/presentation/pages/feed_page.dart';
import '../../../../friends/domain/entities/friend_profile.dart';
import 'home_feed_filter_menu_item.dart';

class HomeFeedFilterDropdown extends ConsumerWidget {
  const HomeFeedFilterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(feedProvider.select((state) => state.filter));
    final friends = ref.watch(homeFeedFilterFriendsProvider);
    final items = _buildItems(filter, friends.valueOrNull ?? const []);
    final selectedLabel = _buttonLabel(filter);

    return AppPopupOverlay(
      gap: 12,
      popupBuilder: (popupContext, closePopup) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280, maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PopupAction(
                onTap: () => _select(ref, items, 'all', closePopup),
                child: const HomeFeedFilterAllFriendsItem(),
              ),
              _PopupAction(
                onTap: () => _select(ref, items, 'me', closePopup),
                child: const HomeFeedFilterMyPostsItem(),
              ),
              ...items
                  .where((item) => item.friend != null)
                  .map(
                    (item) => _PopupAction(
                      onTap: () => _select(ref, items, item.key, closePopup),
                      child: HomeFeedFilterFriendItem(friend: item.friend!),
                    ),
                  ),
              if (friends.isLoading)
                const HomeFeedFilterStatusItem(label: 'Đang tải bạn bè'),
              if (friends.hasError)
                const HomeFeedFilterStatusItem(
                  label: 'Không tải được bạn bè',
                ),
            ],
          ),
        );
      },
      triggerBuilder: (context, isOpen, toggle) {
        return GestureDetector(
          onTap: toggle,
          child: Container(
            height: 48,
            padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
            decoration: BoxDecoration(
              color: AppColors.sky100,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.sky400, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AppText(
                    selectedLabel,
                    size: AppTextSize.small,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: AppColors.ink500,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                AppIcon(
                  isOpen ? AppIcons.caretUp : AppIcons.caretDown,
                  color: AppColors.ink400,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _select(
    WidgetRef ref,
    List<_FeedFilterItem> items,
    String key,
    VoidCallback closePopup,
  ) {
    final selected = items.where((item) => item.key == key).firstOrNull;
    if (selected == null) {
      return;
    }

    unawaited(ref.read(feedProvider.notifier).updateFilter(selected.filter));
    closePopup();
  }

  String _buttonLabel(FeedFilter filter) {
    if (filter.type != FeedFilterType.friend) {
      return filter.label;
    }

    final parts = filter.label.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) {
      return filter.label;
    }

    return parts.sublist(0, parts.length - 1).join(' ');
  }

  List<_FeedFilterItem> _buildItems(
    FeedFilter currentFilter,
    List<FriendProfile> friends,
  ) {
    final items = <_FeedFilterItem>[
      const _FeedFilterItem(
        key: 'all',
        label: 'Tất cả',
        filter: FeedFilter.all(),
      ),
      const _FeedFilterItem(
        key: 'me',
        label: 'Bài đăng của tôi',
        filter: FeedFilter.me(),
      ),
      ...friends.map((friend) {
        final name = friend.fullName.trim().isEmpty
            ? 'Bạn bè'
            : friend.fullName.trim();
        final filter = FeedFilter.friend(
          friendId: friend.userId,
          friendName: name,
        );
        return _FeedFilterItem(
          key: filter.key,
          label: name,
          filter: filter,
          friend: friend,
        );
      }),
    ];

    final selectedFriendId = currentFilter.friendId;
    if (currentFilter.type == FeedFilterType.friend &&
        selectedFriendId != null &&
        items.every((item) => item.key != currentFilter.key)) {
      items.add(
        _FeedFilterItem(
          key: currentFilter.key,
          label: currentFilter.label,
          filter: currentFilter,
        ),
      );
    }

    return items;
  }
}

class _PopupAction extends StatelessWidget {
  const _PopupAction({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}

class _FeedFilterItem {
  final String key;
  final String label;
  final FeedFilter filter;
  final FriendProfile? friend;

  const _FeedFilterItem({
    required this.key,
    required this.label,
    required this.filter,
    this.friend,
  });
}
