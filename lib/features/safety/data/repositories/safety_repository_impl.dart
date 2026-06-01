import 'package:dartz/dartz.dart';

import '../../../../core/cache/current_user_cache_scope.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/monthly_checkin.dart';
import '../../domain/entities/monthly_checkins.dart';
import '../../domain/entities/safety_settings.dart';
import '../../domain/repositories/safety_repository.dart';
import '../datasources/safety_local_datasource.dart';
import '../datasources/safety_remote_datasource.dart';
import '../mappers/monthly_checkins_cache_mapper.dart';
import '../mappers/safety_settings_cache_mapper.dart';

class SafetyRepositoryImpl implements SafetyRepository {
  final SafetyRemoteDatasource _remoteDatasource;
  final SafetyLocalDatasource _localDatasource;
  final CurrentUserCacheScope _currentUserCacheScope;
  final NetworkInfo _networkInfo;
  final DateTime Function() _nowUtc;

  SafetyRepositoryImpl({
    required SafetyRemoteDatasource remoteDatasource,
    required SafetyLocalDatasource localDatasource,
    required CurrentUserCacheScope currentUserCacheScope,
    required NetworkInfo networkInfo,
    DateTime Function()? nowUtc,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _currentUserCacheScope = currentUserCacheScope,
       _networkInfo = networkInfo,
       _nowUtc = nowUtc ?? (() => DateTime.now().toUtc());

  @override
  Future<Either<Failure, SafetySettings>> getSafetySettings() async {
    if (!await _networkInfo.isConnected) {
      return _getCachedSafetySettings();
    }

    try {
      final settings = await _remoteDatasource.getSafetySettings();
      await _upsertCacheIfScoped(settings);
      return Right(settings);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, MonthlyCheckins>> getMonthlyCheckins({
    required int year,
    required int month,
  }) async {
    if (!await _networkInfo.isConnected) {
      return getCachedMonthlyCheckins(year: year, month: month);
    }

    try {
      final checkins = await _remoteDatasource.getMonthlyCheckins(
        year: year,
        month: month,
      );
      await _upsertMonthlyCheckinsCacheIfChanged(checkins);
      return Right(checkins);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, MonthlyCheckins>> getCachedMonthlyCheckins({
    required int year,
    required int month,
  }) async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return const Left(NetworkFailure());
      }

      final cache = await _localDatasource.getMonthlyCheckins(
        cacheScopeMonthKey: monthlyCheckinsCacheKey(
          cacheScopeUserId: cacheScopeUserId,
          year: year,
          month: month,
        ),
      );
      if (cache == null) {
        return const Left(NetworkFailure());
      }

      return Right(cache.toDomain());
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
      await _upsertCacheIfScoped(settings);
      return Right(settings);
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<Either<Failure, SafetySettings>> _getCachedSafetySettings() async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return const Left(NetworkFailure());
      }

      final cache = await _localDatasource.getSettings(
        cacheScopeUserId: cacheScopeUserId,
      );
      if (cache == null) {
        return const Left(NetworkFailure());
      }

      return Right(cache.toDomain());
    } on Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  Future<void> _upsertCacheIfScoped(SafetySettings settings) async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return;
      }

      await _localDatasource.upsertSettings(
        settings.toCache(
          cacheScopeUserId: cacheScopeUserId,
          cachedAtUtc: _nowUtc(),
        ),
      );
    } on Exception {
      // Cache write is best-effort; remote success remains the source of truth.
    }
  }

  Future<void> _upsertMonthlyCheckinsCacheIfChanged(
    MonthlyCheckins checkins,
  ) async {
    try {
      final cacheScopeUserId = await _currentUserCacheScope.getCurrentUserId();
      if (cacheScopeUserId == null || cacheScopeUserId.trim().isEmpty) {
        return;
      }

      final cacheKey = monthlyCheckinsCacheKey(
        cacheScopeUserId: cacheScopeUserId,
        year: checkins.year,
        month: checkins.month,
      );
      final currentCache = await _localDatasource.getMonthlyCheckins(
        cacheScopeMonthKey: cacheKey,
      );
      final current = currentCache?.toDomain();
      if (current != null && _monthlyCheckinsEqual(current, checkins)) {
        return;
      }

      await _localDatasource.upsertMonthlyCheckins(
        checkins.toCache(
          cacheScopeUserId: cacheScopeUserId,
          cachedAtUtc: _nowUtc(),
        ),
      );
    } on Exception {
      // Cache write is best-effort; remote success remains the source of truth.
    }
  }

  bool _monthlyCheckinsEqual(MonthlyCheckins left, MonthlyCheckins right) {
    if (left.year != right.year ||
        left.month != right.month ||
        left.fromDate != right.fromDate ||
        left.toDate != right.toDate ||
        left.totalCount != right.totalCount ||
        left.items.length != right.items.length) {
      return false;
    }

    final leftItems = [...left.items]..sort(_compareMonthlyCheckin);
    final rightItems = [...right.items]..sort(_compareMonthlyCheckin);
    for (var index = 0; index < leftItems.length; index += 1) {
      if (!_monthlyCheckinEqual(leftItems[index], rightItems[index])) {
        return false;
      }
    }

    return true;
  }

  int _compareMonthlyCheckin(MonthlyCheckin left, MonthlyCheckin right) {
    final dateComparison = left.dateKey.compareTo(right.dateKey);
    if (dateComparison != 0) {
      return dateComparison;
    }

    return left.id.compareTo(right.id);
  }

  bool _monthlyCheckinEqual(MonthlyCheckin left, MonthlyCheckin right) {
    return left.id == right.id &&
        left.dailySafetyRecordId == right.dailySafetyRecordId &&
        left.checkinDate == right.checkinDate &&
        left.checkedInAtUtc == right.checkedInAtUtc &&
        left.type == right.type &&
        left.note == right.note &&
        left.mood == right.mood &&
        left.latitude == right.latitude &&
        left.longitude == right.longitude;
  }
}
