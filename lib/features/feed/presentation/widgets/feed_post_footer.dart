import 'package:flutter/material.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icon_data.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/emoji/app_emoji.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../posts/domain/entities/post_reaction_page.dart';

class FeedPostFooter extends StatelessWidget {
  const FeedPostFooter({
    super.key,
    required this.canManage,
    required this.reactionPage,
    required this.onGridPressed,
    required this.onCameraPressed,
    required this.onActivityPressed,
    required this.onMessagePressed,
    required this.onReactIcon,
    required this.onMoreEmojiPressed,
    required this.onMenuPressed,
  });

  final bool canManage;
  final PostReactionPage reactionPage;
  final VoidCallback onGridPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onActivityPressed;
  final VoidCallback? onMessagePressed;
  final ValueChanged<String> onReactIcon;
  final VoidCallback? onMoreEmojiPressed;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.symmetric(horizontal: 28),
      child: SizedBox(
        height: 138,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            canManage
                ? _FeedActivityBar(
                    page: reactionPage,
                    onPressed: onActivityPressed,
                  )
                : _FeedMessageReactionBar(
                    onMessagePressed: onMessagePressed,
                    onReactIcon: onReactIcon,
                    onMoreEmojiPressed: onMoreEmojiPressed,
                  ),
            const SizedBox(height: 10),
            SizedBox(
              height: 84,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _FeedFooterIconButton(
                      icon: AppIcons.grid,
                      tooltip: 'Xem dạng lưới',
                      onPressed: onGridPressed,
                    ),
                  ),
                  _FeedCameraLaunchButton(onPressed: onCameraPressed),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _FeedFooterIconButton(
                      icon: AppIcons.moreVertical,
                      tooltip: canManage
                          ? 'Quản lý bài đăng'
                          : 'Tùy chọn bài đăng',
                      onPressed: onMenuPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedActivityBar extends StatelessWidget {
  const _FeedActivityBar({required this.page, required this.onPressed});

  final PostReactionPage page;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final items = page.items.take(3).toList(growable: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: AppColors.ink500.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                const AppText(
                  'Hoạt động',
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                  color: AppColors.sky100,
                ),
                const Spacer(),
                if (items.isEmpty)
                  AppText(
                    'Chưa có react',
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: colorScheme.onInverseSurface.withValues(alpha: 0.72),
                  )
                else
                  SizedBox(
                    width: 28.0 + ((items.length - 1) * 18),
                    height: 28,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (var index = 0; index < items.length; index++)
                          Positioned(
                            left: index * 18,
                            child: UserAvatar(
                              avatarUrl: items[index].user.avatarUrl,
                              givenName: items[index].user.displayName,
                              size: 28,
                            ),
                          ),
                      ],
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

class _FeedMessageReactionBar extends StatelessWidget {
  const _FeedMessageReactionBar({
    required this.onMessagePressed,
    required this.onReactIcon,
    required this.onMoreEmojiPressed,
  });

  final VoidCallback? onMessagePressed;
  final ValueChanged<String> onReactIcon;
  final VoidCallback? onMoreEmojiPressed;

  static const List<String> _icons = [
    '\u{2764}\u{FE0F}',
    '\u{1F525}',
    '\u{1F970}',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink500.withValues(alpha: 0.86),
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onMessagePressed,
                  borderRadius: BorderRadius.circular(999),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: AppText(
                      'Gửi tin nhắn...',
                      size: AppTextSize.small,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.regular,
                      color: AppColors.sky100,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              for (final icon in _icons)
                _EmojiReactionButton(
                  icon: icon,
                  onPressed: () => onReactIcon(icon),
                ),
              _MoreEmojiReactionButton(onPressed: onMoreEmojiPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmojiReactionButton extends StatelessWidget {
  const _EmojiReactionButton({required this.icon, required this.onPressed});

  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(child: AppEmoji(emoji: icon, size: 22)),
        ),
      ),
    );
  }
}

class _MoreEmojiReactionButton extends StatelessWidget {
  const _MoreEmojiReactionButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: 'Thêm emoji',
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(
              child: AppIcon(
                AppIcons.plus,
                size: 20,
                color: colorScheme.onInverseSurface.withValues(alpha: 0.86),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedFooterIconButton extends StatelessWidget {
  const _FeedFooterIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final AppIconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.ink500.withValues(alpha: 0.86),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: AppIcon(icon, color: AppColors.sky100, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedCameraLaunchButton extends StatelessWidget {
  const _FeedCameraLaunchButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Mở camera',
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          width: 82,
          height: 82,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.teal300, width: 4),
                ),
              ),
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
              Container(
                width: 66,
                height: 66,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.teal400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
