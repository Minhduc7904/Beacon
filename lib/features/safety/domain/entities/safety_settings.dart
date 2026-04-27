class SafetySettings {
  final String dailyDeadlineLocalTime;
  final int gracePeriodMinutes;
  final int reminderBeforeMinutes;
  final int autoAlertDelayMinutes;
  final bool isMonitoringEnabled;
  final bool isAutoAlertEnabled;
  final bool isDefault;

  const SafetySettings({
    required this.dailyDeadlineLocalTime,
    required this.gracePeriodMinutes,
    required this.reminderBeforeMinutes,
    required this.autoAlertDelayMinutes,
    required this.isMonitoringEnabled,
    required this.isAutoAlertEnabled,
    required this.isDefault,
  });
}
