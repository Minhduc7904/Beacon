import 'package:flutter/material.dart';

import '../../domain/entities/feed_post.dart';
import 'feed_image_box.dart';
import 'feed_post_header.dart';

class FeedPostCard extends StatelessWidget {
  const FeedPostCard({super.key, required this.post});

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(),
          FeedImageBox(post: post),
          const SizedBox(height: 16),
          FeedPostHeader(post: post),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
