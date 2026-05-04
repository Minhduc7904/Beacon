import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../feed/presentation/controllers/feed_state.dart';
import '../../../feed/presentation/widgets/feed_post_card.dart';
import '../../controllers/home_checkin_state.dart';
import 'countdown_bubble.dart';
import 'home_action_row.dart';
import 'home_feed_indicator.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeCheckinNotifierProvider);
    final feedState = ref.watch(feedProvider);

    final canCheckin =
        state.phase == HomeCheckinPhase.pending ||
        state.phase == HomeCheckinPhase.grace;

    final homeContent = AppScreenLayout(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Center(child: CountdownBubble(state: state)),
          ),
          const SizedBox(height: 20),
          HomeActionRow(
            isCheckingIn: state.isCheckingIn,
            canCheckin: canCheckin,
            onCheckin: canCheckin
                ? () => ref
                      .read(homeCheckinNotifierProvider.notifier)
                      .checkin()
                : null,
            onMoodPressed: () {
              ref
                  .read(appMessageProvider.notifier)
                  .addInfo('Mood check-in sẽ sớm có');
            },
            onCameraPressed: () =>
                context.pushNamed(AppRoutes.cameraScreenName),
          ),
          const SizedBox(height: 20),
          HomeFeedIndicator(onTap: _scrollToFeed),
        ],
      ),
    );

    final feedPosts = feedState.status == FeedStatus.loaded
        ? feedState.posts
        : <dynamic>[];
    final pageCount = 1 + feedPosts.length;

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: pageCount,
      itemBuilder: (context, index) {
        if (index == 0) return homeContent;

        final post = feedPosts[index - 1];
        return FeedPostCard(
          post: post,
          onReact: (postId, type) {
            ref.read(feedProvider.notifier).toggleReaction(postId, type);
          },
        );
      },
    );
  }
}
