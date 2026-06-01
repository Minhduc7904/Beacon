import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../../safety/domain/entities/safety_settings.dart';
import '../../../safety/domain/usecase/get_safety_settings_usecase.dart';
import '../../domain/entities/checkin_record.dart';
import '../../domain/entities/today_status.dart';
import '../../domain/usecase/checkin_usecase.dart';
import '../../domain/usecase/get_today_status_usecase.dart';
import 'home_checkin_state.dart';

class HomeCheckinNotifier extends StateNotifier<HomeCheckinState> {
  final GetTodayStatusUseCase _getTodayStatusUseCase;
  final CheckinUseCase _checkinUseCase;
  final GetSafetySettingsUseCase _getSafetySettingsUseCase;
  final AppMessageNotifier _messageNotifier;

  Timer? _ticker;
  bool _hasAlertedEmergency = false;

  HomeCheckinNotifier(
    this._getTodayStatusUseCase,
    this._checkinUseCase,
    this._getSafetySettingsUseCase,
    this._messageNotifier,
  ) : super(const HomeCheckinState.initial());

  Future<void> load({bool forceRefresh = false}) async {
    if (state.isLoading) {
      return;
    }

    if (!forceRefresh && state.todayStatus != null) {
      _startTickerIfNeeded();
      return;
    }

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    TodayStatus? todayStatus;
    final statusResult = await _getTodayStatusUseCase.call();
    statusResult.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(errorMessage: failure.message);
      },
      (status) {
        todayStatus = status;
      },
    );

    SafetySettings? safetySettings;
    final settingsResult = await _getSafetySettingsUseCase.call();
    settingsResult.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
      },
      (settings) {
        safetySettings = settings;
      },
    );

    state = state.copyWith(
      isLoading: false,
      todayStatus: todayStatus,
      safetySettings: safetySettings,
      remainingSeconds: _calculateRemainingSeconds(todayStatus),
    );

    _startTickerIfNeeded();
  }

  Future<bool> checkin({String? mood}) async {
    if (state.isCheckingIn) {
      return false;
    }

    if (state.phase == HomeCheckinPhase.checkedIn ||
        state.phase == HomeCheckinPhase.emergency) {
      return false;
    }

    state = state.copyWith(isCheckingIn: true, clearErrorMessage: true);

    final result = await _checkinUseCase.call(CheckinParams(mood: mood));
    var didCheckin = false;
    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isCheckingIn: false,
          errorMessage: failure.message,
        );
      },
      (record) {
        didCheckin = true;
        _messageNotifier.addSuccess('Check-in thành công');
        final updatedStatus = _buildStatusAfterCheckin(record);
        state = state.copyWith(
          isCheckingIn: false,
          todayStatus: updatedStatus,
          lastCheckinType: record.type,
          remainingSeconds: _calculateRemainingSeconds(updatedStatus),
          clearErrorMessage: true,
        );
        _startTickerIfNeeded();
      },
    );

    return didCheckin;
  }

  void _startTickerIfNeeded() {
    if (state.remainingSeconds == null) {
      _stopTicker();
      return;
    }

    _ticker ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleTick(),
    );
  }

  void _handleTick() {
    final status = state.todayStatus;
    if (status == null) {
      return;
    }

    final nextRemaining = _calculateRemainingSeconds(status);
    if (nextRemaining != state.remainingSeconds) {
      state = state.copyWith(remainingSeconds: nextRemaining);
    }

    final phase = state.phase;
    if (phase == HomeCheckinPhase.emergency && state.isAutoAlertEnabled) {
      if (!_hasAlertedEmergency) {
        _messageNotifier.addWarning(
          'Đã quá hạn check-in. Hệ thống sẽ cảnh báo người thân.',
        );
        _hasAlertedEmergency = true;
      }
    } else {
      _hasAlertedEmergency = false;
    }

    if (nextRemaining == null) {
      _stopTicker();
    }
  }

  int? _calculateRemainingSeconds(TodayStatus? status) {
    if (status == null) {
      return null;
    }

    if (!status.isMonitoringEnabled ||
        status.status == TodayStatusType.checkedIn) {
      return null;
    }

    final deadline = status.deadlineAtUtc;
    if (deadline == null) {
      return status.remainingSeconds;
    }

    return deadline.toUtc().difference(DateTime.now().toUtc()).inSeconds;
  }

  TodayStatus _buildStatusAfterCheckin(CheckinRecord record) {
    final previous = state.todayStatus;
    final isEmergency = record.type == CheckinType.emergency;
    final status = isEmergency
        ? TodayStatusType.overdue
        : TodayStatusType.checkedIn;
    final previousStreak = previous?.streak ?? 0;
    final nextStreak = isEmergency ? previousStreak : previousStreak + 1;

    return TodayStatus(
      hasCheckedIn: !isEmergency,
      status: status,
      streak: nextStreak,
      deadlineAtUtc: previous?.deadlineAtUtc,
      remainingSeconds: isEmergency ? state.remainingSeconds : null,
      checkedInAtUtc: record.checkedInAtUtc,
      isMonitoringEnabled: previous?.isMonitoringEnabled ?? true,
      isAutoAlertEnabled: previous?.isAutoAlertEnabled ?? true,
    );
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
