import 'post.dart';

class PostPage {
  final List<Post> items;
  final String? nextCursor;

  const PostPage({required this.items, required this.nextCursor});

  bool get hasMore => nextCursor != null && nextCursor!.trim().isNotEmpty;
}
