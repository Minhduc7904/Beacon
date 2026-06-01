import '../../domain/entities/post_page.dart';
import '../../domain/entities/post.dart';

abstract class PostsLocalDatasource {
  Future<PostPage?> getCachedPosts({required String listScopeKey});

  Future<void> upsertPostPage({
    required String listScopeKey,
    required String cacheScopeUserId,
    required String feedType,
    String? friendId,
    required PostPage page,
    required bool isFirstPage,
    required DateTime cachedAtUtc,
  });

  Future<void> deletePost({
    required String listScopeKey,
    required String postId,
  });

  Future<void> updatePostInUserCaches({
    required String cacheScopeUserId,
    required Post post,
    required DateTime cachedAtUtc,
  });

  Future<void> deletePostFromUserCaches({
    required String cacheScopeUserId,
    required String postId,
  });
}
