import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/emoji/app_emoji.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../posts/domain/entities/post_reaction_detail.dart';
import '../../../posts/domain/entities/post_reaction_icon.dart';
import '../../../posts/domain/entities/post_reaction_page.dart';

class PostReactionListSheet extends StatelessWidget {
  const PostReactionListSheet({super.key, required this.page});

  final PostReactionPage page;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Material(
          color: colorScheme.surface,
          child: FractionallySizedBox(
            heightFactor: 0.68,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.42,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppText(
                    'Hoạt động',
                    size: AppTextSize.regular,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: page.items.isEmpty
                        ? Center(
                            child: AppText(
                              'Chưa có hoạt động',
                              size: AppTextSize.small,
                              spacing: AppTextSpacing.tight,
                              weight: AppTextWeight.regular,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.58,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: page.items.length,
                            separatorBuilder: (_, _) => Divider(
                              height: 1,
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.42,
                              ),
                            ),
                            itemBuilder: (context, index) {
                              return _PostReactionUserTile(
                                item: page.items[index],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PostReactionUserTile extends StatelessWidget {
  const _PostReactionUserTile({required this.item});

  final PostReactionDetail item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icons = reactionDisplayIconsFromDetail(item).join(' ');
    final displayName = item.user.displayName.trim().isEmpty
        ? 'Người dùng'
        : item.user.displayName.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          UserAvatar(
            avatarUrl: item.user.avatarUrl,
            givenName: displayName,
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              displayName,
              size: AppTextSize.small,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          AppEmojiText(
            text: icons,
            style: Theme.of(context).textTheme
                .ui(
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                )
                .copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

List<String> reactionEffectIconsFromPage(PostReactionPage page) {
  return page.items
      .expand(reactionDisplayIconsFromDetail)
      .toList(growable: false);
}

List<String> reactionDisplayIconsFromDetail(PostReactionDetail item) {
  return item.icons
      .expand((icon) => icon.split(RegExp(r'\s*-\s*')))
      .map(_displayReactionIcon)
      .where((icon) => icon.trim().isNotEmpty && icon.trim() != '-')
      .toList(growable: false);
}

String _displayReactionIcon(String icon) {
  final knownIcon = postReactionIconFromValue(icon);
  return knownIcon?.emoji ?? icon;
}
