import '../../domain/entities/today_status.dart';
import '../../../../core/utils/time_utils.dart';

class TodayStatusModel extends TodayStatus {
  const TodayStatusModel({
    required super.hasCheckedIn,
    required super.status,
    required super.streak,
    required super.deadlineAtUtc,
    required super.remainingSeconds,
    required super.checkedInAtUtc,
    required super.isMonitoringEnabled,
    required super.isAutoAlertEnabled,
  });

  factory TodayStatusModel.fromJson(Map<String, dynamic> json) {
    return TodayStatusModel(
      hasCheckedIn: json['hasCheckedIn'] == true,
      status: _parseStatus(json['status']),
      streak: _toInt(json['streak']) ?? 0,
      deadlineAtUtc: _toDate(json['deadlineAtUtc']),
      remainingSeconds: _toInt(json['remainingSeconds']),
      checkedInAtUtc: _toDate(json['checkedInAtUtc']),
      isMonitoringEnabled: json['isMonitoringEnabled'] == true,
      isAutoAlertEnabled: json['isAutoAlertEnabled'] == true,
    );
  }

  static TodayStatusType _parseStatus(dynamic value) {
    final raw = value?.toString().toLowerCase().trim();
    switch (raw) {
      case 'pending':
        return TodayStatusType.pending;
      case 'checkedin':
        return TodayStatusType.checkedIn;
      case 'overdue':
        return TodayStatusType.overdue;
      default:
        return TodayStatusType.unknown;
    }
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    return TimeUtils.tryParseUtc(raw);
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }
}
