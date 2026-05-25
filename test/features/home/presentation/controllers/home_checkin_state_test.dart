import 'package:beacon_app/features/home/domain/entities/today_status.dart';
import 'package:beacon_app/features/home/presentation/controllers/home_checkin_state.dart';
import 'package:beacon_app/features/safety/domain/entities/safety_settings.dart';
import 'package:flutter_test/flutter_test.dart';

TodayStatus _todayStatus({
  TodayStatusType status = TodayStatusType.pending,
  bool isMonitoringEnabled = true,
  bool isAutoAlertEnabled = true,
}) {
  return TodayStatus(
    hasCheckedIn: status == TodayStatusType.checkedIn,
    status: status,
    streak: 3,
    deadlineAtUtc: DateTime.utc(2026, 5, 26, 12),
    remainingSeconds: null,
    checkedInAtUtc: status == TodayStatusType.checkedIn
        ? DateTime.utc(2026, 5, 26, 11)
        : null,
    isMonitoringEnabled: isMonitoringEnabled,
    isAutoAlertEnabled: isAutoAlertEnabled,
  );
}

SafetySettings _safetySettings({int autoAlertDelayMinutes = 0}) {
  return SafetySettings(
    dailyDeadlineLocalTime: '15:00',
    gracePeriodMinutes: 30,
    reminderBeforeMinutes: 60,
    autoAlertDelayMinutes: autoAlertDelayMinutes,
    isMonitoringEnabled: true,
    isAutoAlertEnabled: true,
    isDefault: false,
  );
}

HomeCheckinState _state({
  TodayStatus? todayStatus,
  SafetySettings? safetySettings,
  int? remainingSeconds,
}) {
  return HomeCheckinState(
    isLoading: false,
    isCheckingIn: false,
    todayStatus: todayStatus,
    safetySettings: safetySettings,
    remainingSeconds: remainingSeconds,
    lastCheckinType: null,
    errorMessage: null,
  );
}

void main() {
  group('HomeCheckinState.phase', () {
    test('trả về monitoringOff khi monitoring bị tắt', () {
      final state = _state(
        todayStatus: _todayStatus(isMonitoringEnabled: false),
      );

      expect(state.phase, HomeCheckinPhase.monitoringOff);
    });

    test('trả về checkedIn khi trạng thái hôm nay đã check-in', () {
      final state = _state(
        todayStatus: _todayStatus(status: TodayStatusType.checkedIn),
      );

      expect(state.phase, HomeCheckinPhase.checkedIn);
    });

    test('trả về pending khi chưa quá deadline', () {
      final state = _state(
        todayStatus: _todayStatus(status: TodayStatusType.pending),
      );

      expect(state.phase, HomeCheckinPhase.pending);
    });

    test('trả về emergency khi overdue và remainingSeconds là null', () {
      final state = _state(
        todayStatus: _todayStatus(status: TodayStatusType.overdue),
        safetySettings: _safetySettings(autoAlertDelayMinutes: 10),
      );

      expect(state.phase, HomeCheckinPhase.emergency);
    });

    test('trả về grace khi overdue nhưng vẫn trong auto alert delay', () {
      final state = _state(
        todayStatus: _todayStatus(status: TodayStatusType.overdue),
        safetySettings: _safetySettings(autoAlertDelayMinutes: 10),
        remainingSeconds: -600,
      );

      expect(state.phase, HomeCheckinPhase.grace);
    });

    test('trả về emergency khi overdue và đã hết auto alert delay', () {
      final state = _state(
        todayStatus: _todayStatus(status: TodayStatusType.overdue),
        safetySettings: _safetySettings(autoAlertDelayMinutes: 10),
        remainingSeconds: -601,
      );

      expect(state.phase, HomeCheckinPhase.emergency);
    });

    test('trả về unknown khi chưa có todayStatus', () {
      const state = HomeCheckinState.initial();

      expect(state.phase, HomeCheckinPhase.unknown);
    });
  });
}
