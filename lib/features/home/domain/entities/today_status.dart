enum TodayStatusType { pending, checkedIn, overdue, unknown }

class TodayStatus {
  final bool hasCheckedIn;
  final TodayStatusType status;
  final DateTime? deadlineAtUtc;
  final int? remainingSeconds;
  final DateTime? checkedInAtUtc;
  final bool isMonitoringEnabled;
  final bool isAutoAlertEnabled;

  const TodayStatus({
    required this.hasCheckedIn,
    required this.status,
    required this.deadlineAtUtc,
    required this.remainingSeconds,
    required this.checkedInAtUtc,
    required this.isMonitoringEnabled,
    required this.isAutoAlertEnabled,
  });

  TodayStatus copyWith({
    bool? hasCheckedIn,
    TodayStatusType? status,
    DateTime? deadlineAtUtc,
    bool clearDeadlineAtUtc = false,
    int? remainingSeconds,
    bool clearRemainingSeconds = false,
    DateTime? checkedInAtUtc,
    bool clearCheckedInAtUtc = false,
    bool? isMonitoringEnabled,
    bool? isAutoAlertEnabled,
  }) {
    return TodayStatus(
      hasCheckedIn: hasCheckedIn ?? this.hasCheckedIn,
      status: status ?? this.status,
      deadlineAtUtc: clearDeadlineAtUtc
          ? null
          : (deadlineAtUtc ?? this.deadlineAtUtc),
      remainingSeconds: clearRemainingSeconds
          ? null
          : (remainingSeconds ?? this.remainingSeconds),
      checkedInAtUtc: clearCheckedInAtUtc
          ? null
          : (checkedInAtUtc ?? this.checkedInAtUtc),
      isMonitoringEnabled: isMonitoringEnabled ?? this.isMonitoringEnabled,
      isAutoAlertEnabled: isAutoAlertEnabled ?? this.isAutoAlertEnabled,
    );
  }
}
