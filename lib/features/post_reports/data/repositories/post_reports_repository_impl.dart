import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/post_report.dart';
import '../../domain/repositories/post_reports_repository.dart';
import '../datasources/post_reports_remote_datasource.dart';

class PostReportsRepositoryImpl implements PostReportsRepository {
  final PostReportsRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  PostReportsRepositoryImpl({
    required PostReportsRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, PostReport>> reportPost({
    required String postId,
    required String reason,
    String? description,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final report = await _remoteDatasource.reportPost(
        postId: postId,
        reason: reason,
        description: description,
      );
      return Right(report);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
