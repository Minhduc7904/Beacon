import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/safety_settings.dart';
import '../repositories/safety_repository.dart';

class UpdateSafetySettingsParams {
  /// 🔥 Time in UTC format (HH:MM) - will be sent to backend as-is
  /// 
  /// UI converts Vietnam time → UTC time before creating this param
  /// Example: "15:00" UTC (which displays as "22:00" Vietnam time)
  final String? dailyDeadlineLocalTime;
  final int? gracePeriodMinutes;
  final int? reminderBeforeMinutes;
  final int? autoAlertDelayMinutes;
  final bool? isMonitoringEnabled;
  final bool? isAutoAlertEnabled;

  const UpdateSafetySettingsParams({
    this.dailyDeadlineLocalTime,
    this.gracePeriodMinutes,
    this.reminderBeforeMinutes,
    this.autoAlertDelayMinutes,
    this.isMonitoringEnabled,
    this.isAutoAlertEnabled,
  });

  /// 🔥 helper check có field nào không
  bool get hasAnyField =>
      dailyDeadlineLocalTime != null ||
      gracePeriodMinutes != null ||
      reminderBeforeMinutes != null ||
      autoAlertDelayMinutes != null ||
      isMonitoringEnabled != null ||
      isAutoAlertEnabled != null;
}

class UpdateSafetySettingsUseCase {
  static final RegExp _timeRegex = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

  final SafetyRepository _repository;

  UpdateSafetySettingsUseCase(this._repository);

  Future<Either<Failure, SafetySettings>> call(
    UpdateSafetySettingsParams params,
  ) async {
    /// ❌ không có gì để update
    if (!params.hasAnyField) {
      return const Left(
        ValidationFailure(message: 'Không có thay đổi nào để cập nhật'),
      );
    }

    /// 🔥 normalize business rule
    final normalized = _normalize(params);

    /// 🔥 validate
    final validationError = _validate(normalized);
    if (validationError != null) {
      return Left(validationError);
    }

    debugPrint('Update params: $normalized');

    /// 🔥 gọi repository (nullable OK)
    return _repository.updateSafetySettings(
      dailyDeadlineLocalTime: normalized.dailyDeadlineLocalTime?.trim(),
      gracePeriodMinutes: normalized.gracePeriodMinutes,
      reminderBeforeMinutes: normalized.reminderBeforeMinutes,
      autoAlertDelayMinutes: normalized.autoAlertDelayMinutes,
      isMonitoringEnabled: normalized.isMonitoringEnabled,
      isAutoAlertEnabled: normalized.isAutoAlertEnabled,
    );
  }

  /// 🔥 enforce business rule
  UpdateSafetySettingsParams _normalize(UpdateSafetySettingsParams params) {
    if (params.isMonitoringEnabled == false) {
      return UpdateSafetySettingsParams(
        dailyDeadlineLocalTime: params.dailyDeadlineLocalTime,
        gracePeriodMinutes: params.gracePeriodMinutes,
        reminderBeforeMinutes: params.reminderBeforeMinutes,
        autoAlertDelayMinutes: params.autoAlertDelayMinutes,
        isMonitoringEnabled: false,
        isAutoAlertEnabled: false,
      );
    }
    return params;
  }

  ValidationFailure? _validate(UpdateSafetySettingsParams params) {
    final deadline = params.dailyDeadlineLocalTime?.trim();

    if (deadline != null && !_timeRegex.hasMatch(deadline)) {
      return const ValidationFailure(
        message: ErrorMessages.safetyDeadlineInvalidFormat,
      );
    }

    if (params.gracePeriodMinutes != null &&
        !_isValidMinuteValue(params.gracePeriodMinutes!)) {
      return const ValidationFailure(
        message: ErrorMessages.safetyGracePeriodOutOfRange,
      );
    }

    if (params.reminderBeforeMinutes != null &&
        !_isValidMinuteValue(params.reminderBeforeMinutes!)) {
      return const ValidationFailure(
        message: ErrorMessages.safetyReminderBeforeOutOfRange,
      );
    }

    if (params.autoAlertDelayMinutes != null &&
        !_isValidMinuteValue(params.autoAlertDelayMinutes!)) {
      return const ValidationFailure(
        message: ErrorMessages.safetyAutoAlertDelayOutOfRange,
      );
    }

    return null;
  }

  bool _isValidMinuteValue(int value) {
    return value >= 0 && value <= 1440;
  }
}
