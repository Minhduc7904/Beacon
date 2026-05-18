import '../models/post_model.dart';
import '../models/post_page_model.dart';
import '../models/post_reaction_result_model.dart';

abstract class PostsRemoteDatasource {
  Future<PostModel> createPost({
    required String mediaId,
    String? caption,
    required String visibility,
  });

  Future<PostPageModel> getFeedPosts({String? cursor, int? limit});

  Future<PostPageModel> getFriendPosts({
    required String friendId,
    String? cursor,
    int? limit,
  });

  Future<PostPageModel> getMyPosts({String? cursor, int? limit});

  Future<PostModel> updatePost({
    required String postId,
    String? caption,
    String? visibility,
  });

  Future<void> deletePost({required String postId});

  Future<PostReactionResultModel> setReaction({
    required String postId,
    required String icon,
  });

  Future<PostReactionResultModel> deleteReaction({required String postId});
}
