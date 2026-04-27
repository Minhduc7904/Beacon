import '../../domain/entities/safety_settings.dart';

class SafetySettingsModel extends SafetySettings {
  const SafetySettingsModel({
    required super.dailyDeadlineLocalTime,
    required super.gracePeriodMinutes,
    required super.reminderBeforeMinutes,
    required super.autoAlertDelayMinutes,
    required super.isMonitoringEnabled,
    required super.isAutoAlertEnabled,
    required super.isDefault,
  });

  factory SafetySettingsModel.fromJson(Map<String, dynamic> json) {
    return SafetySettingsModel(
      dailyDeadlineLocalTime: json['dailyDeadlineLocalTime']?.toString() ?? '',
      gracePeriodMinutes: _toInt(json['gracePeriodMinutes']),
      reminderBeforeMinutes: _toInt(json['reminderBeforeMinutes']),
      autoAlertDelayMinutes: _toInt(json['autoAlertDelayMinutes']),
      isMonitoringEnabled: json['isMonitoringEnabled'] == true,
      isAutoAlertEnabled: json['isAutoAlertEnabled'] == true,
      isDefault: json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toPatchJson() {
    return {
      'dailyDeadlineLocalTime': dailyDeadlineLocalTime,
      'gracePeriodMinutes': gracePeriodMinutes,
      'reminderBeforeMinutes': reminderBeforeMinutes,
      'autoAlertDelayMinutes': autoAlertDelayMinutes,
      'isMonitoringEnabled': isMonitoringEnabled,
      'isAutoAlertEnabled': isAutoAlertEnabled,
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
