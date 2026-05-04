import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/feed_notifier.dart';
import '../controllers/feed_state.dart';

/// Provider for the feed notifier — declared here so it can be used
/// by both the HomePage (which hosts the outer PageView) and any
/// standalone feed screen in the future.
final feedProvider =
    StateNotifierProvider.autoDispose<FeedNotifier, FeedState>((ref) {
  return FeedNotifier();
});
