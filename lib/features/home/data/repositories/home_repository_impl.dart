import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/media_upload_result.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl({
    required HomeRemoteDatasource remoteDatasource,
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
