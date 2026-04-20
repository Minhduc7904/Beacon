import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/media_upload_result.dart';
import '../../domain/repositories/post_preview_repository.dart';
import '../datasources/post_preview_remote_datasource.dart';

class PostPreviewRepositoryImpl implements PostPreviewRepository {
  final PostPreviewRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  PostPreviewRepositoryImpl({
    required PostPreviewRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, MediaUploadResult>> uploadPostMedia({
    required String filePath,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final uploadResult = await _remoteDatasource.uploadPostMedia(
        filePath: filePath,
      );
      return Right(uploadResult);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
