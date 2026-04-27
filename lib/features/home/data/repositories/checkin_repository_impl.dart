import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/checkin_record.dart';
import '../../domain/entities/today_status.dart';
import '../../domain/repositories/checkin_repository.dart';
import '../datasources/checkin_remote_datasource.dart';

class CheckinRepositoryImpl implements CheckinRepository {
  final CheckinRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  CheckinRepositoryImpl({
    required CheckinRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, TodayStatus>> getTodayStatus() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final status = await _remoteDatasource.getTodayStatus();
      return Right(status);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, CheckinRecord>> checkin({
    String? note,
    String? mediaId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final record = await _remoteDatasource.checkin(
        note: note,
        mediaId: mediaId,
      );
      return Right(record);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
