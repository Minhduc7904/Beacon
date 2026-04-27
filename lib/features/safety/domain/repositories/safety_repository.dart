import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/safety_settings.dart';

abstract class SafetyRepository {
  Future<Either<Failure, SafetySettings>> getSafetySettings();

  /// 🔥 PARTIAL UPDATE (nullable hết)
  Future<Either<Failure, SafetySettings>> updateSafetySettings({
    String? dailyDeadlineLocalTime,
    int? gracePeriodMinutes,
    int? reminderBeforeMinutes,
    int? autoAlertDelayMinutes,
    bool? isMonitoringEnabled,
    bool? isAutoAlertEnabled,
  });
}