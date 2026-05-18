import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../controllers/feed_notifier.dart';
import '../controllers/feed_state.dart';

/// Provider for the feed notifier — declared here so it can be used
/// by both the HomePage (which hosts the outer PageView) and any
/// standalone feed screen in the future.
final feedProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  return FeedNotifier(
    ref.watch(getFeedPostsUseCaseProvider),
    ref.watch(getMyPostsUseCaseProvider),
    ref.watch(getFriendPostsUseCaseProvider),
    ref.watch(setPostReactionUseCaseProvider),
    ref.watch(setPostReactionIconUseCaseProvider),
    ref.watch(deletePostReactionUseCaseProvider),
    ref.watch(getPostReactionsUseCaseProvider),
    ref.watch(updatePostUseCaseProvider),
    ref.watch(deletePostUseCaseProvider),
    ref.watch(appMessageProvider.notifier),
  );
});
