import '../../domain/entities/checkin_record.dart';
import '../../domain/entities/today_status.dart';
import '../../../safety/domain/entities/safety_settings.dart';

enum HomeCheckinPhase {
  pending,
  grace,
  emergency,
  checkedIn,
  monitoringOff,
  unknown,
}

class HomeCheckinState {
  final bool isLoading;
  final bool isCheckingIn;
  final TodayStatus? todayStatus;
  final SafetySettings? safetySettings;
  final int? remainingSeconds;
  final CheckinType? lastCheckinType;
  final String? errorMessage;

  const HomeCheckinState({
    required this.isLoading,
    required this.isCheckingIn,
    required this.todayStatus,
    required this.safetySettings,
    required this.remainingSeconds,
    required this.lastCheckinType,
    required this.errorMessage,
  });

  const HomeCheckinState.initial()
    : isLoading = false,
      isCheckingIn = false,
      todayStatus = null,
      safetySettings = null,
      remainingSeconds = null,
      lastCheckinType = null,
      errorMessage = null;

  bool get isMonitoringEnabled => todayStatus?.isMonitoringEnabled ?? true;

  bool get isAutoAlertEnabled => todayStatus?.isAutoAlertEnabled ?? true;

  TodayStatusType get status => todayStatus?.status ?? TodayStatusType.unknown;

  int get autoAlertDelayMinutes => safetySettings?.autoAlertDelayMinutes ?? 0;

  HomeCheckinPhase get phase {
    if (!isMonitoringEnabled) {
      return HomeCheckinPhase.monitoringOff;
    }

    switch (status) {
      case TodayStatusType.checkedIn:
        return HomeCheckinPhase.checkedIn;
      case TodayStatusType.pending:
        return HomeCheckinPhase.pending;
      case TodayStatusType.overdue:
        final delaySeconds = autoAlertDelayMinutes * 60;
        final seconds = remainingSeconds;
        if (seconds == null) {
          return HomeCheckinPhase.emergency;
        }

        final overdueSeconds = seconds.abs();
        if (delaySeconds > 0 && overdueSeconds <= delaySeconds) {
          return HomeCheckinPhase.grace;
        }
        return HomeCheckinPhase.emergency;
      case TodayStatusType.unknown:
        return HomeCheckinPhase.unknown;
    }
  }

  HomeCheckinState copyWith({
    bool? isLoading,
    bool? isCheckingIn,
    TodayStatus? todayStatus,
    bool clearTodayStatus = false,
    SafetySettings? safetySettings,
    bool clearSafetySettings = false,
    int? remainingSeconds,
    bool clearRemainingSeconds = false,
    CheckinType? lastCheckinType,
    bool clearLastCheckinType = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeCheckinState(
      isLoading: isLoading ?? this.isLoading,
      isCheckingIn: isCheckingIn ?? this.isCheckingIn,
      todayStatus: clearTodayStatus ? null : (todayStatus ?? this.todayStatus),
      safetySettings: clearSafetySettings
          ? null
          : (safetySettings ?? this.safetySettings),
      remainingSeconds: clearRemainingSeconds
          ? null
          : (remainingSeconds ?? this.remainingSeconds),
      lastCheckinType: clearLastCheckinType
          ? null
          : (lastCheckinType ?? this.lastCheckinType),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
