import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/safety_settings.dart';
import '../../domain/repositories/safety_repository.dart';
import '../datasources/safety_remote_datasource.dart';

class SafetyRepositoryImpl implements SafetyRepository {
  final SafetyRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  SafetyRepositoryImpl({
    required SafetyRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, SafetySettings>> getSafetySettings() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final settings = await _remoteDatasource.getSafetySettings();
      return Right(settings);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, SafetySettings>> updateSafetySettings({
    String? dailyDeadlineLocalTime,
    int? gracePeriodMinutes,
    int? reminderBeforeMinutes,
    int? autoAlertDelayMinutes,
    bool? isMonitoringEnabled,
    bool? isAutoAlertEnabled,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    /// 🔥 build payload chỉ field thay đổi
    final body = <String, dynamic>{};

    if (dailyDeadlineLocalTime != null) {
      body['dailyDeadlineLocalTime'] = dailyDeadlineLocalTime;
    }
    if (gracePeriodMinutes != null) {
      body['gracePeriodMinutes'] = gracePeriodMinutes;
    }
    if (reminderBeforeMinutes != null) {
      body['reminderBeforeMinutes'] = reminderBeforeMinutes;
    }
    if (autoAlertDelayMinutes != null) {
      body['autoAlertDelayMinutes'] = autoAlertDelayMinutes;
    }
    if (isMonitoringEnabled != null) {
      body['isMonitoringEnabled'] = isMonitoringEnabled;
    }
    if (isAutoAlertEnabled != null) {
      body['isAutoAlertEnabled'] = isAutoAlertEnabled;
    }

    /// ❌ không có gì để update
    if (body.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Không có thay đổi nào để cập nhật'),
      );
    }

    try {
      final settings = await _remoteDatasource.updateSafetySettings(
        body: body, // 🔥 truyền map xuống datasource
      );
      return Right(settings);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
