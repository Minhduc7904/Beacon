import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/post_page.dart';
import '../../domain/entities/post_reaction_icon.dart';
import '../../domain/entities/post_reaction_page.dart';
import '../../domain/entities/post_reaction_result.dart';
import '../../domain/entities/post_visibility.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  PostsRepositoryImpl({
    required PostsRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, Post>> createPost({
    required String mediaId,
    String? caption,
    required PostVisibility visibility,
    double? latitude,
    double? longitude,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final post = await _remoteDatasource.createPost(
        mediaId: mediaId,
        caption: caption,
        visibility: visibility.value,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(post);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, PostPage>> getFeedPosts({String? cursor, int? limit}) {
    return _getPostPage(
      () => _remoteDatasource.getFeedPosts(cursor: cursor, limit: limit),
    );
  }

  @override
  Future<Either<Failure, PostPage>> getFriendPosts({
    required String friendId,
    String? cursor,
    int? limit,
  }) {
    return _getPostPage(
      () => _remoteDatasource.getFriendPosts(
        friendId: friendId,
        cursor: cursor,
        limit: limit,
      ),
    );
  }

  @override
  Future<Either<Failure, PostPage>> getMyPosts({String? cursor, int? limit}) {
    return _getPostPage(
      () => _remoteDatasource.getMyPosts(cursor: cursor, limit: limit),
    );
  }

  @override
  Future<Either<Failure, Post>> updatePost({
    required String postId,
    String? caption,
    PostVisibility? visibility,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final post = await _remoteDatasource.updatePost(
        postId: postId,
        caption: caption,
        visibility: visibility?.value,
      );
      return Right(post);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDatasource.deletePost(postId: postId);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, PostReactionResult>> setReaction({
    required String postId,
    required PostReactionIcon icon,
  }) {
    return _changeReaction(
      () => _remoteDatasource.setReactionIcon(postId: postId, icon: icon.value),
    );
  }

  @override
  Future<Either<Failure, PostReactionResult>> setReactionIcon({
    required String postId,
    required String icon,
  }) {
    return _changeReaction(
      () => _remoteDatasource.setReactionIcon(postId: postId, icon: icon),
    );
  }

  @override
  Future<Either<Failure, PostReactionResult>> deleteReaction({
    required String postId,
  }) {
    return _changeReaction(
      () => _remoteDatasource.deleteReaction(postId: postId),
    );
  }

  @override
  Future<Either<Failure, PostReactionPage>> getReactions({
    required String postId,
    String? cursor,
    int? limit,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final page = await _remoteDatasource.getReactions(
        postId: postId,
        cursor: cursor,
        limit: limit,
      );
      return Right(page);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<Either<Failure, PostReactionResult>> _changeReaction(
    Future<PostReactionResult> Function() change,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await change();
      return Right(result);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<Either<Failure, PostPage>> _getPostPage(
    Future<PostPage> Function() load,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final page = await load();
      return Right(page);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
