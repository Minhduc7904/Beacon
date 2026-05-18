import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/post.dart';
import '../entities/post_page.dart';
import '../entities/post_reaction_icon.dart';
import '../entities/post_reaction_page.dart';
import '../entities/post_reaction_result.dart';
import '../entities/post_visibility.dart';

abstract class PostsRepository {
  Future<Either<Failure, Post>> createPost({
    required String mediaId,
    String? caption,
    required PostVisibility visibility,
    double? latitude,
    double? longitude,
  });

  Future<Either<Failure, PostPage>> getFeedPosts({String? cursor, int? limit});

  Future<Either<Failure, PostPage>> getFriendPosts({
    required String friendId,
    String? cursor,
    int? limit,
  });

  Future<Either<Failure, PostPage>> getMyPosts({String? cursor, int? limit});

  Future<Either<Failure, Post>> updatePost({
    required String postId,
    String? caption,
    PostVisibility? visibility,
  });

  Future<Either<Failure, bool>> deletePost({required String postId});

  Future<Either<Failure, PostReactionResult>> setReaction({
    required String postId,
    required PostReactionIcon icon,
  });

  Future<Either<Failure, PostReactionResult>> setReactionIcon({
    required String postId,
    required String icon,
  });

  Future<Either<Failure, PostReactionResult>> deleteReaction({
    required String postId,
  });

  Future<Either<Failure, PostReactionPage>> getReactions({
    required String postId,
    String? cursor,
    int? limit,
  });
}
