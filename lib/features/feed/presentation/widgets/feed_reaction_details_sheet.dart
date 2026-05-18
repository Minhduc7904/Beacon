import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/feed_post.dart';
import '../../domain/entities/feed_reaction.dart';

class FeedReactionDetailsSheet extends StatefulWidget {
  const FeedReactionDetailsSheet({super.key, required this.post});

  final FeedPost post;

  @override
  State<FeedReactionDetailsSheet> createState() =>
      _FeedReactionDetailsSheetState();
}

class _FeedReactionDetailsSheetState extends State<FeedReactionDetailsSheet> {
  late final Map<ReactionType, int> _reactionCounts;
  late final List<_MockReactionDetail> _items;
  ReactionType? _selectedType;

  @override
  void initState() {
    super.initState();
    _reactionCounts = _computeReactionCounts(widget.post);
    _items = _MockReactionDetails.build(widget.post, _reactionCounts);
  }

  Map<ReactionType, int> _computeReactionCounts(FeedPost post) {
    if (post.reactionCounts.isNotEmpty) {
      return post.reactionCounts;
    }

    final counts = <ReactionType, int>{};
    for (final reaction in post.reactions) {
      counts[reaction.type] = (counts[reaction.type] ?? 0) + 1;
    }
    return counts;
  }

  int get _totalCount =>
      _reactionCounts.values.fold<int>(0, (sum, count) => sum + count);

  List<_MockReactionDetail> get _visibleItems {
    final selectedType = _selectedType;
    if (selectedType == null) {
      return _items;
    }
    return _items.where((item) => item.type == selectedType).toList();
  }

  int get _selectedTotalCount {
    final selectedType = _selectedType;
    if (selectedType == null) {
      return _totalCount;
    }
    return _reactionCounts[selectedType] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final visibleItems = _visibleItems;
    final hiddenCount = _selectedTotalCount - visibleItems.length;

    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.72,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Người đã react',
                size: AppTextSize.regular,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.bold,
                color: colorScheme.onSurface,
              ),
              const SizedBox(height: 4),
              AppText(
                '$_totalCount lượt react',
                size: AppTextSize.veryTiny,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.regular,
                color: colorScheme.onSurface.withValues(alpha: 0.58),
              ),
              const SizedBox(height: 16),
              _ReactionFilterBar(
                totalCount: _totalCount,
                counts: _reactionCounts,
                selectedType: _selectedType,
                onSelected: (type) {
                  setState(() {
                    _selectedType = type;
                  });
                },
              ),
              const SizedBox(height: 14),
              Expanded(
                child: visibleItems.isEmpty
                    ? _ReactionDetailsEmptyState(totalCount: _totalCount)
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: visibleItems.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.42,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          return _ReactionUserTile(item: visibleItems[index]);
                        },
                      ),
              ),
              if (hiddenCount > 0) ...[
                const SizedBox(height: 12),
                AppText(
                  'Còn $hiddenCount lượt react khác',
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.regular,
                  color: colorScheme.onSurface.withValues(alpha: 0.58),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReactionFilterBar extends StatelessWidget {
  const _ReactionFilterBar({
    required this.totalCount,
    required this.counts,
    required this.selectedType,
    required this.onSelected,
  });

  final int totalCount;
  final Map<ReactionType, int> counts;
  final ReactionType? selectedType;
  final ValueChanged<ReactionType?> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _ReactionFilterChip(
        label: 'Tất cả',
        count: totalCount,
        isSelected: selectedType == null,
        onTap: () => onSelected(null),
      ),
    ];

    for (final type in ReactionType.values) {
      final count = counts[type] ?? 0;
      if (count <= 0) {
        continue;
      }

      chips.add(
        _ReactionFilterChip(
          emoji: _reactionEmoji(type),
          count: count,
          isSelected: selectedType == type,
          onTap: () => onSelected(type),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final chip in chips) ...[chip, const SizedBox(width: 8)],
        ],
      ),
    );
  }
}

class _ReactionFilterChip extends StatelessWidget {
  const _ReactionFilterChip({
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.label,
    this.emoji,
  });

  final String? label;
  final String? emoji;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface.withValues(alpha: 0.72);

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.52),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (emoji != null) ...[
                Text(emoji!, style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 5),
              ],
              if (label != null) ...[
                AppText(
                  label!,
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                  color: foreground,
                ),
                const SizedBox(width: 6),
              ],
              AppText(
                '$count',
                size: AppTextSize.veryTiny,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.bold,
                color: foreground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReactionUserTile extends StatelessWidget {
  const _ReactionUserTile({required this.item});

  final _MockReactionDetail item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          UserAvatar(
            avatarUrl: item.avatarUrl,
            givenName: item.displayName,
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.displayName,
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                  color: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                AppText(
                  _formatReactionTime(item.reactedAt),
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.regular,
                  color: colorScheme.onSurface.withValues(alpha: 0.54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.66,
              ),
              shape: BoxShape.circle,
            ),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Center(
                child: Text(
                  _reactionEmoji(item.type),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReactionDetailsEmptyState extends StatelessWidget {
  const _ReactionDetailsEmptyState({required this.totalCount});

  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final message = totalCount == 0
        ? 'Chưa có lượt react nào'
        : 'Chưa có dữ liệu cho bộ lọc này';

    return Center(
      child: AppText(
        message,
        size: AppTextSize.small,
        spacing: AppTextSpacing.normal,
        weight: AppTextWeight.regular,
        color: colorScheme.onSurface.withValues(alpha: 0.62),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MockReactionDetail {
  const _MockReactionDetail({
    required this.displayName,
    required this.type,
    required this.reactedAt,
    this.avatarUrl,
  });

  final String displayName;
  final String? avatarUrl;
  final ReactionType type;
  final DateTime reactedAt;
}

class _MockReactionDetails {
  static const int _maxItems = 30;
  static const List<String> _names = [
    'Minh Anh',
    'Hải Đăng',
    'Thu Hà',
    'Quốc Bảo',
    'Ngọc Trâm',
    'Đức Huy',
    'Bảo Ngọc',
    'Gia Hân',
    'Tuấn Kiệt',
    'Phương Linh',
    'Hoàng Nam',
    'Khánh Vy',
    'Anh Thư',
    'Nhật Minh',
    'Thanh Mai',
    'Quỳnh Chi',
  ];

  // TODO(posts): replace this UI mock with GET /posts/{postId}/reactions.
  static List<_MockReactionDetail> build(
    FeedPost post,
    Map<ReactionType, int> counts,
  ) {
    if (post.reactions.isNotEmpty) {
      return post.reactions.take(_maxItems).map((reaction) {
        return _MockReactionDetail(
          displayName: reaction.userName,
          type: reaction.type,
          reactedAt: reaction.createdAt,
        );
      }).toList();
    }

    final seed = post.id.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    final now = DateTime.now();
    final items = <_MockReactionDetail>[];

    for (final type in ReactionType.values) {
      final count = counts[type] ?? 0;
      for (var index = 0; index < count && items.length < _maxItems; index++) {
        final nameIndex = (seed + items.length + index * 3) % _names.length;
        final name = _names[nameIndex];
        final duplicateRound = index ~/ _names.length;
        final displayName = duplicateRound == 0
            ? name
            : '$name ${duplicateRound + 1}';

        items.add(
          _MockReactionDetail(
            displayName: displayName,
            type: type,
            reactedAt: now.subtract(Duration(minutes: 2 + items.length * 6)),
          ),
        );
      }
    }

    return items;
  }
}

String _reactionEmoji(ReactionType type) {
  return switch (type) {
    ReactionType.heart => '❤️',
    ReactionType.haha => '😂',
    ReactionType.like => '👍',
    ReactionType.sad => '😢',
    ReactionType.wow => '😮',
  };
}

String _formatReactionTime(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 1) {
    return 'Vừa react';
  }
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} phút trước';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} giờ trước';
  }
  return '${diff.inDays} ngày trước';
}
