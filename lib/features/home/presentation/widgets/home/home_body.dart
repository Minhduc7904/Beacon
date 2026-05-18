import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icon_data.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/dropdown/dropdown.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/loading/loading.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../../feed/domain/entities/feed_post.dart';
import '../../../../feed/presentation/controllers/feed_state.dart';
import '../../../../feed/presentation/pages/feed_page.dart';
import '../../../../feed/presentation/widgets/feed_post_card.dart';
import '../../../../posts/domain/entities/post_reaction_detail.dart';
import '../../../../posts/domain/entities/post_reaction_page.dart';
import '../../../../posts/domain/entities/post_visibility.dart';
import '../../controllers/home_checkin_state.dart';
import 'countdown_bubble.dart';
import 'home_action_row.dart';
import 'home_feed_indicator.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({
    super.key,
    required this.onFeedVisibilityChanged,
    this.targetPostId,
  });

  final ValueChanged<bool> onFeedVisibilityChanged;
  final String? targetPostId;

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  late final PageController _pageController;
  String? _handledTargetPostId;
  bool _isHandlingTargetPost = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scheduleTargetPostScroll();
  }

  @override
  void didUpdateWidget(covariant HomeBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetPostId != widget.targetPostId) {
      _scheduleTargetPostScroll();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToFeed() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _scheduleTargetPostScroll() {
    final postId = widget.targetPostId?.trim();
    if (postId == null ||
        postId.isEmpty ||
        postId == _handledTargetPostId ||
        _isHandlingTargetPost) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(_openTargetPost(postId));
    });
  }

  Future<void> _openTargetPost(String postId) async {
    if (_isHandlingTargetPost) {
      return;
    }

    _isHandlingTargetPost = true;
    try {
      await _ensureFeedContainsPost(postId);
      if (!mounted) {
        return;
      }

      final feedState = ref.read(feedProvider);
      final postIndex = feedState.posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) {
        ref
            .read(appMessageProvider.notifier)
            .addWarning('Khong tim thay bai dang vua co tuong tac');
        return;
      }

      if (feedState.viewMode == FeedViewMode.grid) {
        ref.read(feedProvider.notifier).updateViewMode(FeedViewMode.single);
        await Future<void>.delayed(const Duration(milliseconds: 16));
      }

      if (!mounted) {
        return;
      }

      _handledTargetPostId = postId;
      widget.onFeedVisibilityChanged(true);
      final targetPage = postIndex + 1;
      if (_pageController.hasClients) {
        await _pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(targetPage);
          }
        });
      }

      final post = ref.read(feedProvider).posts[postIndex];
      _handleVisibleFeedPost(post);
    } finally {
      _isHandlingTargetPost = false;
    }
  }

  Future<void> _ensureFeedContainsPost(String postId) async {
    var feedState = ref.read(feedProvider);
    if (feedState.posts.any((post) => post.id == postId)) {
      return;
    }

    await ref.read(feedProvider.notifier).load(forceRefresh: true);
    if (!mounted) {
      return;
    }

    feedState = ref.read(feedProvider);
    var attempts = 0;
    while (!feedState.posts.any((post) => post.id == postId) &&
        feedState.hasMore &&
        attempts < 10) {
      await ref.read(feedProvider.notifier).loadMore();
      if (!mounted) {
        return;
      }
      feedState = ref.read(feedProvider);
      attempts += 1;
    }
  }

  void _handlePageChanged(int index) {
    widget.onFeedVisibilityChanged(index > 0);

    if (index == 0) {
      return;
    }

    final feedState = ref.read(feedProvider);
    if (feedState.posts.isEmpty) {
      return;
    }

    if (feedState.viewMode == FeedViewMode.grid) {
      return;
    }

    final feedIndex = index - 1;
    if (feedIndex >= 0 && feedIndex < feedState.posts.length) {
      _handleVisibleFeedPost(feedState.posts[feedIndex]);
    }

    if (feedIndex >= feedState.posts.length - 2) {
      ref.read(feedProvider.notifier).loadMore();
    }
  }

  void _handleVisibleFeedPost(FeedPost post) {
    final currentUserId = ref.read(meProfileProvider).valueOrNull?.id;
    if (currentUserId == null || post.ownerUserId != currentUserId) {
      return;
    }

    unawaited(ref.read(feedProvider.notifier).loadPostReactions(post.id));
  }

  void _switchToGrid() {
    if (_pageController.hasClients) {
      _pageController.jumpToPage(1);
    }
    ref.read(feedProvider.notifier).updateViewMode(FeedViewMode.grid);
  }

  void _switchToSingleAt(int postIndex) {
    ref.read(feedProvider.notifier).updateViewMode(FeedViewMode.single);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      _pageController.jumpToPage(postIndex + 1);
    });
  }

  Future<void> _showEditPostSheet(FeedPost post) async {
    final result = await showModalBottomSheet<_EditPostResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _EditPostSheet(post: post),
    );

    if (!mounted || result == null) {
      return;
    }

    unawaited(
      ref
          .read(feedProvider.notifier)
          .updatePost(
            postId: post.id,
            caption: result.caption,
            visibility: result.visibility,
          ),
    );
  }

  Future<void> _confirmDeletePost(FeedPost post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return AlertDialog(
          title: const AppText(
            'Xóa bài đăng',
            size: AppTextSize.regular,
            spacing: AppTextSpacing.tight,
            weight: AppTextWeight.bold,
          ),
          content: AppText(
            'Bài đăng sẽ bị xóa khỏi feed của bạn.',
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
              child: Text('Xóa', style: TextStyle(color: colorScheme.error)),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    unawaited(ref.read(feedProvider.notifier).deletePost(post.id));
  }

  void _showPostReactionsSheet(PostReactionPage page) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _PostReactionListSheet(page: page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(feedProvider.select((state) => state.filter), (previous, next) {
      if (previous == null || previous == next) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) {
          return;
        }

        _pageController.jumpToPage(1);
      });
    });

    final state = ref.watch(homeCheckinNotifierProvider);
    final feedState = ref.watch(feedProvider);
    final currentUserId = ref.watch(meProfileProvider).valueOrNull?.id;

    final canCheckin =
        state.phase == HomeCheckinPhase.pending ||
        state.phase == HomeCheckinPhase.grace;

    final homeContent = AppScreenLayout(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Center(child: CountdownBubble(state: state)),
          ),
          const SizedBox(height: 16),
          HomeActionRow(
            isCheckingIn: state.isCheckingIn,
            canCheckin: canCheckin,
            onCheckin: canCheckin
                ? () => ref.read(homeCheckinNotifierProvider.notifier).checkin()
                : null,
            onMoodPressed: () {
              ref
                  .read(appMessageProvider.notifier)
                  .addInfo('Mood check-in sẽ sớm có');
            },
            onCameraPressed: () =>
                context.pushNamed(AppRoutes.cameraScreenName),
          ),
          const SizedBox(height: 36),
          HomeFeedIndicator(onTap: _scrollToFeed),
        ],
      ),
    );

    final feedPosts = feedState.posts;
    final isGridMode = feedState.viewMode == FeedViewMode.grid;
    final feedPageCount = feedPosts.isEmpty
        ? 1
        : isGridMode
        ? 1
        : feedPosts.length;
    final pageCount = 1 + feedPageCount;

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: _handlePageChanged,
      itemCount: pageCount,
      itemBuilder: (context, index) {
        if (index == 0) return homeContent;

        if (feedPosts.isEmpty) {
          return _FeedStatusPage(
            state: feedState,
            onRetry: () =>
                ref.read(feedProvider.notifier).load(forceRefresh: true),
          );
        }

        if (isGridMode) {
          return _FeedGridPage(
            posts: feedPosts,
            isLoadingMore: feedState.isLoadingMore,
            onPostTap: _switchToSingleAt,
            onLoadMore: () => ref.read(feedProvider.notifier).loadMore(),
          );
        }

        final post = feedPosts[index - 1];
        final canManage =
            currentUserId != null && post.ownerUserId == currentUserId;
        final reactionPage =
            feedState.postReactionPages[post.id] ??
            const PostReactionPage.empty();
        return Stack(
          fit: StackFit.expand,
          children: [
            FeedPostCard(post: post),
            Positioned(
              left: 0,
              right: 0,
              bottom: 14,
              child: _FeedPostFooter(
                canManage: canManage,
                reactionPage: reactionPage,
                onGridPressed: _switchToGrid,
                onCameraPressed: () =>
                    context.pushNamed(AppRoutes.cameraScreenName),
                onActivityPressed: () => _showPostReactionsSheet(reactionPage),
                onReactIcon: (icon) => unawaited(
                  ref
                      .read(feedProvider.notifier)
                      .setReactionIcon(post.id, icon),
                ),
                onMenuPressed: canManage
                    ? () => _showOwnerActionSheet(post)
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOwnerActionSheet(FeedPost post) async {
    final action = await showModalBottomSheet<_OwnerPostAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const _OwnerPostActionSheet(),
    );

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case _OwnerPostAction.reactions:
        _showPostReactionsSheet(
          ref.read(feedProvider).postReactionPages[post.id] ??
              const PostReactionPage.empty(),
        );
      case _OwnerPostAction.edit:
        unawaited(_showEditPostSheet(post));
      case _OwnerPostAction.delete:
        unawaited(_confirmDeletePost(post));
    }
  }
}

class _EditPostResult {
  final String caption;
  final PostVisibility visibility;

  const _EditPostResult({required this.caption, required this.visibility});
}

class _EditPostSheet extends StatefulWidget {
  const _EditPostSheet({required this.post});

  final FeedPost post;

  @override
  State<_EditPostSheet> createState() => _EditPostSheetState();
}

class _EditPostSheetState extends State<_EditPostSheet> {
  static const int _maxCaptionLength = 2000;

  late final TextEditingController _captionController;
  late PostVisibility _visibility;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.post.caption ?? '');
    _captionController.addListener(_handleCaptionChanged);
    _visibility = widget.post.visibility;
  }

  @override
  void dispose() {
    _captionController.removeListener(_handleCaptionChanged);
    _captionController.dispose();
    super.dispose();
  }

  void _handleCaptionChanged() {
    setState(() {});
  }

  void _submit() {
    Navigator.of(context).pop(
      _EditPostResult(
        caption: _captionController.text,
        visibility: _visibility,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;
    final captionLength = _captionController.text.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Sửa bài đăng',
              size: AppTextSize.regular,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: 18),
            Input(
              height: 108,
              label: 'Caption',
              hintText: 'Nhập caption',
              rightCaption: '$captionLength/$_maxCaptionLength',
              controller: _captionController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              inputFormatters: [
                LengthLimitingTextInputFormatter(_maxCaptionLength),
              ],
            ),
            const SizedBox(height: 18),
            AppDropdown<PostVisibility>(
              labelText: 'Hiển thị',
              value: _visibility,
              items: const [
                AppDropdownItem(value: PostVisibility.friends, label: 'Bạn bè'),
                AppDropdownItem(
                  value: PostVisibility.private,
                  label: 'Riêng tư',
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _visibility = value;
                });
              },
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Button(
                    text: 'Hủy',
                    type: ButtonType.outline,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Button(text: 'Lưu', onPressed: _submit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedGridPage extends StatelessWidget {
  const _FeedGridPage({
    required this.posts,
    required this.isLoadingMore,
    required this.onPostTap,
    required this.onLoadMore,
  });

  final List<FeedPost> posts;
  final bool isLoadingMore;
  final ValueChanged<int> onPostTap;
  final VoidCallback onLoadMore;

  bool _handleScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.maxScrollExtent - metrics.pixels <= 420) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppScreenLayout(
      padding: const EdgeInsets.only(top: 72, bottom: 20),
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScroll,
        child: Stack(
          children: [
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _FeedGridTile(
                  post: posts[index],
                  onTap: () => onPostTap(index),
                );
              },
            ),
            if (isLoadingMore)
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: AppLoadingIndicator(
                        color: colorScheme.primary,
                        size: 18,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeedGridTile extends StatelessWidget {
  const _FeedGridTile({required this.post, required this.onTap});

  final FeedPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Image.network(
          post.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }

            return Center(
              child: AppLoadingIndicator(
                color: AppColors.sky100.withValues(alpha: 0.8),
                size: 18,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: AppIcon(
                AppIcons.warning,
                color: AppColors.sky100.withValues(alpha: 0.72),
                size: 24,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore: unused_element
class _FeedViewModeButton extends StatelessWidget {
  const _FeedViewModeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Xem dạng lưới',
      child: Material(
        color: AppColors.ink500.withValues(alpha: 0.86),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: AppIcon(AppIcons.grid, color: AppColors.sky100, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedPostFooter extends StatelessWidget {
  const _FeedPostFooter({
    required this.canManage,
    required this.reactionPage,
    required this.onGridPressed,
    required this.onCameraPressed,
    required this.onActivityPressed,
    required this.onReactIcon,
    required this.onMenuPressed,
  });

  final bool canManage;
  final PostReactionPage reactionPage;
  final VoidCallback onGridPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onActivityPressed;
  final ValueChanged<String> onReactIcon;
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
                : _FeedMessageReactionBar(onReactIcon: onReactIcon),
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
                      tooltip: 'Xem dang luoi',
                      onPressed: onGridPressed,
                    ),
                  ),
                  _FeedCameraLaunchButton(onPressed: onCameraPressed),
                  Align(
                    alignment: Alignment.centerRight,
                    child: canManage
                        ? _FeedFooterIconButton(
                            icon: AppIcons.moreVertical,
                            tooltip: 'Quan ly bai dang',
                            onPressed: onMenuPressed,
                          )
                        : const SizedBox(width: 48, height: 48),
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
                  'Hoat dong',
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                  color: AppColors.sky100,
                ),
                const Spacer(),
                if (items.isEmpty)
                  AppText(
                    'Chua co react',
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: colorScheme.onInverseSurface.withValues(alpha: 0.72),
                  )
                else
                  SizedBox(
                    width: 24.0 + ((items.length - 1) * 18),
                    height: 28,
                    child: Stack(
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
  const _FeedMessageReactionBar({required this.onReactIcon});

  final ValueChanged<String> onReactIcon;

  static const List<String> _icons = ['❤️', '🔥', '🥰'];

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
              const Expanded(
                child: AppText(
                  'Gui tin nhan...',
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.regular,
                  color: AppColors.sky100,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              for (final icon in _icons)
                _EmojiReactionButton(
                  icon: icon,
                  onPressed: () => onReactIcon(icon),
                ),
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
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 22)),
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
      message: 'Mo camera',
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

enum _OwnerPostAction { reactions, edit, delete }

class _OwnerPostActionSheet extends StatelessWidget {
  const _OwnerPostActionSheet();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Material(
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                _OwnerPostActionTile(
                  icon: AppIcons.users,
                  label: 'Nguoi da react',
                  color: colorScheme.onSurface,
                  onTap: () =>
                      Navigator.of(context).pop(_OwnerPostAction.reactions),
                ),
                _OwnerPostActionTile(
                  icon: AppIcons.pencil,
                  label: 'Sua',
                  color: colorScheme.onSurface,
                  onTap: () => Navigator.of(context).pop(_OwnerPostAction.edit),
                ),
                _OwnerPostActionTile(
                  icon: AppIcons.trash,
                  label: 'Xoa',
                  color: colorScheme.error,
                  onTap: () =>
                      Navigator.of(context).pop(_OwnerPostAction.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OwnerPostActionTile extends StatelessWidget {
  const _OwnerPostActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final AppIconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            AppIcon(icon, size: 22, color: color),
            const SizedBox(width: 14),
            AppText(
              label,
              size: AppTextSize.small,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.medium,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class _PostReactionListSheet extends StatelessWidget {
  const _PostReactionListSheet({required this.page});

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
                        color: colorScheme.outline.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppText(
                    'Hoat dong',
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
                              'Chua co hoat dong',
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
    final icons = item.icons.join(', ');
    final displayName = item.user.displayName.trim().isEmpty
        ? 'Nguoi dung'
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
          AppText(
            icons,
            size: AppTextSize.small,
            spacing: AppTextSpacing.tight,
            weight: AppTextWeight.bold,
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}

class _FeedStatusPage extends StatelessWidget {
  const _FeedStatusPage({required this.state, required this.onRetry});

  final FeedState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading =
        state.status == FeedStatus.initial ||
        state.status == FeedStatus.loading;
    final title = switch (state.status) {
      FeedStatus.error => 'Không thể tải feed',
      FeedStatus.loaded => 'Chưa có bài đăng',
      FeedStatus.initial || FeedStatus.loading => 'Đang tải feed',
    };
    final message = switch (state.status) {
      FeedStatus.error => state.errorMessage ?? 'Vui lòng thử lại sau ít phút',
      FeedStatus.loaded => 'Bài đăng của bạn và bạn bè sẽ xuất hiện ở đây',
      FeedStatus.initial || FeedStatus.loading => 'Đang lấy bài mới nhất',
    };

    return AppScreenLayout(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              AppLoadingIndicator(
                color: colorScheme.primary,
                size: 28,
                strokeWidth: 2.4,
              ),
              const SizedBox(height: 18),
            ],
            AppText(
              title,
              size: AppTextSize.regular,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              message,
              size: AppTextSize.small,
              spacing: AppTextSpacing.normal,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.64),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (state.status == FeedStatus.error) ...[
              const SizedBox(height: 20),
              Button(
                text: 'Thử lại',
                type: ButtonType.outline,
                size: ButtonSize.large,
                w: 160,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
