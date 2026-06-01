import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/emoji/app_emoji_picker_sheet.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../../feed/domain/entities/feed_post.dart';
import '../../../../feed/presentation/controllers/feed_state.dart';
import '../../../../feed/presentation/pages/feed_page.dart';
import '../../../../feed/presentation/widgets/feed_edit_post_sheet.dart';
import '../../../../feed/presentation/widgets/feed_grid_page.dart';
import '../../../../feed/presentation/widgets/feed_post_action_sheets.dart';
import '../../../../feed/presentation/widgets/feed_post_card.dart';
import '../../../../feed/presentation/widgets/feed_post_footer.dart';
import '../../../../feed/presentation/widgets/feed_post_message_input_sheet.dart';
import '../../../../feed/presentation/widgets/feed_reaction_list_sheet.dart';
import '../../../../feed/presentation/widgets/feed_status_page.dart';
import '../../../../feed/presentation/widgets/reaction_fly_overlay.dart';
import '../../../../message_groups/presentation/pages/message_group_list_page.dart';
import '../../../../post_reports/presentation/widgets/report_post_sheet.dart';
import '../../../../posts/domain/entities/post_reaction_page.dart';
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
  int _currentPageIndex = 0;
  String? _activeReactionEffectPostId;
  String? _activeSentReactionEffectPostId;
  String? _activeSentReactionEffectIcon;
  String? _activeMessageEffectPostId;
  String? _sendingPostMessagePostId;
  final Set<String> _playedReactionEffectPostIds = <String>{};
  final Set<String> _pendingReactionEffectPostIds = <String>{};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(ref.read(feedProvider.notifier).load());
    });
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

  void _setCurrentPageIndex(int index) {
    if (_currentPageIndex == index) {
      return;
    }

    setState(() {
      _currentPageIndex = index;
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
            .addWarning('Không tìm thấy bài đăng vừa có tương tác');
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
        if (mounted) {
          _setCurrentPageIndex(targetPage);
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(targetPage);
            _setCurrentPageIndex(targetPage);
          }
        });
      }

      final posts = ref.read(feedProvider).posts;
      final visiblePostIndex = posts.indexWhere((post) => post.id == postId);
      if (visiblePostIndex != -1) {
        _handleVisibleFeedPost(posts[visiblePostIndex]);
      }
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
    _setCurrentPageIndex(index);
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

  void _scheduleReactionEffectIfReady({
    required FeedPost post,
    required PostReactionPage page,
    required String? currentUserId,
  }) {
    if (currentUserId == null ||
        post.ownerUserId != currentUserId ||
        page.items.isEmpty ||
        _playedReactionEffectPostIds.contains(post.id) ||
        _pendingReactionEffectPostIds.contains(post.id) ||
        _activeReactionEffectPostId == post.id) {
      return;
    }

    _pendingReactionEffectPostIds.add(post.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingReactionEffectPostIds.remove(post.id);
      if (!mounted) {
        return;
      }

      final feedState = ref.read(feedProvider);
      final feedIndex = _currentPageIndex - 1;
      if (feedState.viewMode != FeedViewMode.single ||
          feedIndex < 0 ||
          feedIndex >= feedState.posts.length) {
        return;
      }

      final visiblePost = feedState.posts[feedIndex];
      final latestCurrentUserId = ref.read(meProfileProvider).valueOrNull?.id;
      final latestReactionPage = feedState.postReactionPages[post.id];
      if (visiblePost.id != post.id ||
          latestCurrentUserId == null ||
          visiblePost.ownerUserId != latestCurrentUserId ||
          latestReactionPage == null ||
          latestReactionPage.items.isEmpty) {
        return;
      }

      setState(() {
        _playedReactionEffectPostIds.add(post.id);
        _activeReactionEffectPostId = post.id;
      });
    });
  }

  void _handleReactionEffectCompleted(String postId) {
    if (!mounted || _activeReactionEffectPostId != postId) {
      return;
    }

    setState(() {
      _activeReactionEffectPostId = null;
    });
  }

  void _handleSentReactionEffectCompleted(String postId) {
    if (!mounted || _activeSentReactionEffectPostId != postId) {
      return;
    }

    setState(() {
      _activeSentReactionEffectPostId = null;
      _activeSentReactionEffectIcon = null;
    });
  }

  void _handleMessageEffectCompleted(String postId) {
    if (!mounted || _activeMessageEffectPostId != postId) {
      return;
    }

    setState(() {
      _activeMessageEffectPostId = null;
    });
  }

  Future<void> _handleReactIcon(FeedPost post, String icon) async {
    final didReact = await ref
        .read(feedProvider.notifier)
        .setReactionIcon(post.id, icon);
    if (!mounted || !didReact) {
      return;
    }

    final feedState = ref.read(feedProvider);
    final feedIndex = _currentPageIndex - 1;
    if (feedState.viewMode != FeedViewMode.single ||
        feedIndex < 0 ||
        feedIndex >= feedState.posts.length ||
        feedState.posts[feedIndex].id != post.id) {
      return;
    }

    setState(() {
      _activeSentReactionEffectPostId = post.id;
      _activeSentReactionEffectIcon = icon;
    });
  }

  void _switchToGrid() {
    if (_pageController.hasClients) {
      _pageController.jumpToPage(1);
    }
    _setCurrentPageIndex(1);
    ref.read(feedProvider.notifier).updateViewMode(FeedViewMode.grid);
  }

  void _switchToSingleAt(int postIndex) {
    ref.read(feedProvider.notifier).updateViewMode(FeedViewMode.single);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      final targetPage = postIndex + 1;
      _pageController.jumpToPage(targetPage);
      _setCurrentPageIndex(targetPage);

      final posts = ref.read(feedProvider).posts;
      if (postIndex >= 0 && postIndex < posts.length) {
        _handleVisibleFeedPost(posts[postIndex]);
      }
    });
  }

  Future<void> _showEditPostSheet(FeedPost post) async {
    final result = await showModalBottomSheet<EditPostResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => FeedEditPostSheet(post: post),
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
        builder: (context) => PostReactionListSheet(page: page),
      ),
    );
  }

  Future<void> _showEmojiReactionPicker(FeedPost post) async {
    final emoji = await showAppEmojiPickerSheet(context);
    if (!mounted || emoji == null || emoji.trim().isEmpty) {
      return;
    }

    await _handleReactIcon(post, emoji);
  }

  Future<void> _showPostMessageInput(FeedPost post) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PostMessageInputSheet(
          clientMessageId: ref
              .read(sendPostMessageUseCaseProvider)
              .createClientMessageId(),
          onSend: (content, clientMessageId) =>
              _sendPostMessage(post.id, content, clientMessageId),
        );
      },
    );
  }

  Future<bool> _sendPostMessage(
    String postId,
    String content,
    String clientMessageId,
  ) async {
    if (_sendingPostMessagePostId != null) {
      return false;
    }

    setState(() {
      _sendingPostMessagePostId = postId;
    });

    final result = await ref
        .read(sendPostMessageUseCaseProvider)
        .call(
          postId: postId,
          content: content,
          clientMessageId: clientMessageId,
        );

    if (!mounted) {
      return false;
    }

    var didSend = false;
    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
      },
      (sentMessage) {
        didSend = true;
        ref
            .read(messageGroupListProvider.notifier)
            .applyIncomingMessage(sentMessage, isFromCurrentUser: true);
        setState(() {
          _activeMessageEffectPostId = postId;
        });
      },
    );

    setState(() {
      _sendingPostMessagePostId = null;
    });

    return didSend;
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
        _setCurrentPageIndex(1);
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
                ? (mood) => ref
                      .read(homeCheckinNotifierProvider.notifier)
                      .checkin(mood: mood)
                : null,
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
    final footerPostIndex = _currentPageIndex - 1;
    final footerPost =
        !isGridMode &&
            footerPostIndex >= 0 &&
            footerPostIndex < feedPosts.length
        ? feedPosts[footerPostIndex]
        : null;
    final footerReactionPage = footerPost == null
        ? null
        : feedState.postReactionPages[footerPost.id] ??
              const PostReactionPage.empty();
    if (footerPost != null && footerReactionPage != null) {
      _scheduleReactionEffectIfReady(
        post: footerPost,
        page: footerReactionPage,
        currentUserId: currentUserId,
      );
    }
    final activeReactionEffectPostId = _activeReactionEffectPostId;
    final activeSentReactionEffectPostId = _activeSentReactionEffectPostId;
    final activeSentReactionEffectIcon = _activeSentReactionEffectIcon;
    final activeMessageEffectPostId = _activeMessageEffectPostId;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: _handlePageChanged,
          itemCount: pageCount,
          itemBuilder: (context, index) {
            if (index == 0) return homeContent;

            if (feedPosts.isEmpty) {
              return FeedStatusPage(
                state: feedState,
                onRetry: () =>
                    ref.read(feedProvider.notifier).load(forceRefresh: true),
              );
            }

            if (isGridMode) {
              return FeedGridPage(
                posts: feedPosts,
                isLoadingMore: feedState.isLoadingMore,
                onPostTap: _switchToSingleAt,
                onLoadMore: () => ref.read(feedProvider.notifier).loadMore(),
              );
            }

            final post = feedPosts[index - 1];
            return FeedPostCard(
              key: ValueKey<String>('${post.id}:${post.imageUrl}'),
              post: post,
            );
          },
        ),
        if (activeReactionEffectPostId != null)
          Positioned.fill(
            child: ReactionFlyOverlay(
              key: ValueKey<String>(activeReactionEffectPostId),
              reactions: reactionEffectIconsFromPage(
                feedState.postReactionPages[activeReactionEffectPostId] ??
                    const PostReactionPage.empty(),
              ),
              onCompleted: () =>
                  _handleReactionEffectCompleted(activeReactionEffectPostId),
            ),
          ),
        if (activeSentReactionEffectPostId != null &&
            activeSentReactionEffectIcon != null)
          Positioned.fill(
            child: ReactionFlyOverlay(
              key: ValueKey<String>(
                'sent-$activeSentReactionEffectPostId-$activeSentReactionEffectIcon',
              ),
              reactions: [activeSentReactionEffectIcon],
              minCopiesPerReaction: 5,
              maxCopiesPerReaction: 6,
              onCompleted: () => _handleSentReactionEffectCompleted(
                activeSentReactionEffectPostId,
              ),
            ),
          ),
        if (activeMessageEffectPostId != null)
          Positioned.fill(
            child: ReactionFlyOverlay(
              key: ValueKey<String>('message-$activeMessageEffectPostId'),
              reactions: const ['\u{1F4AC}'],
              minCopiesPerReaction: 4,
              maxCopiesPerReaction: 5,
              onCompleted: () =>
                  _handleMessageEffectCompleted(activeMessageEffectPostId),
            ),
          ),
        if (footerPost != null && footerReactionPage != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 14,
            child: Builder(
              builder: (context) {
                final canManage =
                    currentUserId != null &&
                    footerPost.ownerUserId == currentUserId;

                return FeedPostFooter(
                  canManage: canManage,
                  reactionPage: footerReactionPage,
                  onGridPressed: _switchToGrid,
                  onCameraPressed: () =>
                      context.pushNamed(AppRoutes.cameraScreenName),
                  onActivityPressed: () =>
                      _showPostReactionsSheet(footerReactionPage),
                  onMessagePressed: canManage
                      ? null
                      : () => unawaited(_showPostMessageInput(footerPost)),
                  onReactIcon: (icon) =>
                      unawaited(_handleReactIcon(footerPost, icon)),
                  onMoreEmojiPressed: canManage
                      ? null
                      : () => unawaited(_showEmojiReactionPicker(footerPost)),
                  onMenuPressed: canManage
                      ? () => _showOwnerActionSheet(footerPost)
                      : () => _showViewerActionSheet(footerPost),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _showOwnerActionSheet(FeedPost post) async {
    final action = await showModalBottomSheet<OwnerPostAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const OwnerPostActionSheet(),
    );

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case OwnerPostAction.reactions:
        _showPostReactionsSheet(
          ref.read(feedProvider).postReactionPages[post.id] ??
              const PostReactionPage.empty(),
        );
      case OwnerPostAction.edit:
        unawaited(_showEditPostSheet(post));
      case OwnerPostAction.delete:
        unawaited(_confirmDeletePost(post));
    }
  }

  Future<void> _showViewerActionSheet(FeedPost post) async {
    final action = await showModalBottomSheet<ViewerPostAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ViewerPostActionSheet(),
    );

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case ViewerPostAction.report:
        unawaited(_showReportPostSheet(post));
    }
  }

  Future<void> _showReportPostSheet(FeedPost post) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ReportPostSheet(postId: post.id, authorName: post.authorName),
    );
  }
}
