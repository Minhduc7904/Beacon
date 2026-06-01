import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/monthly_checkins.dart';
import '../entities/safety_settings.dart';

abstract class SafetyRepository {
  Future<Either<Failure, SafetySettings>> getSafetySettings();

  Future<Either<Failure, MonthlyCheckins>> getMonthlyCheckins({
    required int year,
    required int month,
  });

  Future<Either<Failure, MonthlyCheckins>> getCachedMonthlyCheckins({
    required int year,
    required int month,
  });

  Future<Either<Failure, SafetySettings>> updateSafetySettings({
    String? dailyDeadlineLocalTime,
    int? gracePeriodMinutes,
    int? reminderBeforeMinutes,
    int? autoAlertDelayMinutes,
    bool? isMonitoringEnabled,
    bool? isAutoAlertEnabled,
  });
}
