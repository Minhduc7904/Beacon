import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../../feed/domain/entities/feed_filter.dart';
import '../../../../feed/presentation/pages/feed_page.dart';
import '../../../../friends/domain/entities/friend_profile.dart';

final homeFeedFilterFriendsProvider = FutureProvider<List<FriendProfile>>((
  ref,
) async {
  final result = await ref.watch(getFriendsUseCaseProvider).call(limit: 100);
  return result.fold((failure) => throw failure, (page) => page.items);
});

class HomeFeedFilterDropdown extends ConsumerWidget {
  const HomeFeedFilterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(feedProvider.select((state) => state.filter));
    final friends = ref.watch(homeFeedFilterFriendsProvider);
    final items = _buildItems(filter, friends.valueOrNull ?? const []);
    final selectedLabel = filter.label;

    return PopupMenuButton<String>(
      tooltip: 'Lọc feed',
      onSelected: (key) {
        _FeedFilterItem? selected;
        for (final item in items) {
          if (item.key == key) {
            selected = item;
            break;
          }
        }
        if (selected == null) {
          return;
        }

        unawaited(
          ref.read(feedProvider.notifier).updateFilter(selected.filter),
        );
      },
      itemBuilder: (context) {
        final menuItems = <PopupMenuEntry<String>>[
          ...items.map(
            (item) => PopupMenuItem<String>(
              value: item.key,
              child: _FeedFilterMenuLabel(
                label: item.label,
                isSelected: item.key == filter.key,
              ),
            ),
          ),
        ];

        if (friends.isLoading) {
          menuItems.add(
            const PopupMenuItem<String>(
              enabled: false,
              child: _FeedFilterMenuLabel(label: 'Đang tải bạn bè'),
            ),
          );
        } else if (friends.hasError) {
          menuItems.add(
            const PopupMenuItem<String>(
              enabled: false,
              child: _FeedFilterMenuLabel(label: 'Không tải được bạn bè'),
            ),
          );
        }

        return menuItems;
      },
      child: Container(
        height: 48,
        constraints: const BoxConstraints(maxWidth: 152),
        padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
        decoration: BoxDecoration(
          color: AppColors.sky100,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.sky400, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
            const AppIcon(
              AppIcons.caretDown,
              color: AppColors.ink400,
              size: 16,
            ),
          ],
        ),
      ),
    );
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
      const _FeedFilterItem(key: 'me', label: 'Tôi', filter: FeedFilter.me()),
      ...friends.map((friend) {
        final name = friend.fullName.trim().isEmpty
            ? 'Bạn bè'
            : friend.fullName.trim();
        final filter = FeedFilter.friend(
          friendId: friend.userId,
          friendName: name,
        );
        return _FeedFilterItem(key: filter.key, label: name, filter: filter);
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

class _FeedFilterItem {
  final String key;
  final String label;
  final FeedFilter filter;

  const _FeedFilterItem({
    required this.key,
    required this.label,
    required this.filter,
  });
}

class _FeedFilterMenuLabel extends StatelessWidget {
  const _FeedFilterMenuLabel({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: AppText(
            label,
            size: AppTextSize.small,
            spacing: AppTextSpacing.tight,
            weight: isSelected ? AppTextWeight.bold : AppTextWeight.regular,
            color: colorScheme.onSurface,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isSelected) ...[
          const SizedBox(width: 12),
          AppIcon(AppIcons.check, size: 16, color: colorScheme.primary),
        ],
      ],
    );
  }
}
