import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/feed_mock_data.dart';
import '../../domain/entities/feed_post.dart';
import '../../domain/entities/feed_reaction.dart';
import 'feed_state.dart';

int _reactionId = 9000;

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier() : super(const FeedState());

  /// Loads mock feed posts.
  Future<void> load() async {
    state = state.copyWith(status: FeedStatus.loading);

    await Future.delayed(const Duration(milliseconds: 400));

    state = state.copyWith(
      status: FeedStatus.loaded,
      posts: List<FeedPost>.from(FeedMockData.posts),
    );
  }

  /// Toggle a reaction on a post. If the same reaction is tapped again,
  /// it gets removed. If a different reaction is tapped, it replaces the old one.
  void toggleReaction(String postId, ReactionType type) {
    final posts = List<FeedPost>.from(state.posts);
    final idx = posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = posts[idx];

    if (post.myReaction == type) {
      // Remove reaction
      posts[idx] = post.copyWith(clearMyReaction: true);
    } else {
      // Add/replace reaction
      final newReaction = FeedReaction(
        id: 'my_reaction_${_reactionId++}',
        userName: 'Tôi',
        type: type,
        createdAt: DateTime.now(),
      );

      final updatedReactions = [
        ...post.reactions.where((r) => r.userName != 'Tôi'),
        newReaction,
      ];

      posts[idx] = post.copyWith(
        myReaction: type,
        reactions: updatedReactions,
      );
    }

    state = state.copyWith(posts: posts);
  }
}
