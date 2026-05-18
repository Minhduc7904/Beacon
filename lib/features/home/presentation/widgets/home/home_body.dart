import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/dropdown/dropdown.dart';
import '../../../../../core/widgets/input/input.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/loading/loading.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../../feed/domain/entities/feed_post.dart';
import '../../../../feed/presentation/controllers/feed_state.dart';
import '../../../../feed/presentation/pages/feed_page.dart';
import '../../../../feed/presentation/widgets/feed_post_card.dart';
import '../../../../feed/presentation/widgets/feed_reaction_details_sheet.dart';
import '../../../../posts/domain/entities/post_visibility.dart';
import '../../controllers/home_checkin_state.dart';
import 'countdown_bubble.dart';
import 'home_action_row.dart';
import 'home_feed_indicator.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key, required this.onFeedVisibilityChanged});

  final ValueChanged<bool> onFeedVisibilityChanged;

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    if (feedIndex >= feedState.posts.length - 2) {
      ref.read(feedProvider.notifier).loadMore();
    }
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

  void _showReactionDetailsSheet(FeedPost post) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => FeedReactionDetailsSheet(post: post),
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
        return Stack(
          fit: StackFit.expand,
          children: [
            FeedPostCard(
              post: post,
              canReact:
                  currentUserId != null && post.ownerUserId != currentUserId,
              canManage: canManage,
              onViewReactions: _showReactionDetailsSheet,
              onEdit: (post) => unawaited(_showEditPostSheet(post)),
              onDelete: (post) => unawaited(_confirmDeletePost(post)),
              onReact: (postId, type) {
                unawaited(
                  ref.read(feedProvider.notifier).toggleReaction(postId, type),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 22,
              child: Center(
                child: _FeedViewModeButton(onPressed: _switchToGrid),
              ),
            ),
          ],
        );
      },
    );
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
