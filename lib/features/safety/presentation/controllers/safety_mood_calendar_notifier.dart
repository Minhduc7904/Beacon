import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/monthly_checkin.dart';
import '../../domain/entities/monthly_checkins.dart';
import '../../domain/usecase/get_monthly_checkins_usecase.dart';
import 'safety_mood_calendar_state.dart';

class SafetyMoodCalendarNotifier
    extends StateNotifier<SafetyMoodCalendarState> {
  final GetMonthlyCheckinsUseCase _getMonthlyCheckinsUseCase;
  final AppMessageNotifier _messageNotifier;

  SafetyMoodCalendarNotifier(
    this._getMonthlyCheckinsUseCase,
    this._messageNotifier,
  ) : super(SafetyMoodCalendarState.initial());

  Future<void> load({DateTime? month}) async {
    if (state.isLoading || state.isRefreshing) {
      return;
    }

    final target = month == null
        ? state.visibleMonth
        : DateTime(month.year, month.month);
    final monthChanged =
        target.year != state.visibleMonth.year ||
        target.month != state.visibleMonth.month;
    final hadVisibleData = !monthChanged && state.monthlyCheckins != null;
    final params = GetMonthlyCheckinsParams(
      year: target.year,
      month: target.month,
    );

    state = state.copyWith(
      visibleMonth: target,
      isLoading: false,
      isRefreshing: false,
      clearErrorMessage: true,
      clearMonthlyCheckins: monthChanged,
    );

    final cachedResult = await _getMonthlyCheckinsUseCase.cached(params);
    var hasCache = false;
    cachedResult.fold((_) {}, (cached) {
      hasCache = true;
      state = state.copyWith(
        visibleMonth: target,
        monthlyCheckins: cached,
        isLoading: false,
        isRefreshing: true,
        clearErrorMessage: true,
      );
    });

    if (!hasCache && !hadVisibleData) {
      state = state.copyWith(isLoading: true);
    }

    final result = await _getMonthlyCheckinsUseCase.call(params);

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: failure.message,
          clearMonthlyCheckins: !hasCache && !hadVisibleData,
        );
      },
      (monthlyCheckins) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          monthlyCheckins: _sameMonthlyCheckins(
            state.monthlyCheckins,
            monthlyCheckins,
          )
              ? state.monthlyCheckins
              : monthlyCheckins,
          clearErrorMessage: true,
        );
      },
    );
  }

  bool _sameMonthlyCheckins(MonthlyCheckins? current, MonthlyCheckins next) {
    if (current == null) {
      return false;
    }

    if (current.year != next.year ||
        current.month != next.month ||
        current.fromDate != next.fromDate ||
        current.toDate != next.toDate ||
        current.totalCount != next.totalCount ||
        current.items.length != next.items.length) {
      return false;
    }

    final currentItems = [...current.items]..sort(_compareMonthlyCheckin);
    final nextItems = [...next.items]..sort(_compareMonthlyCheckin);
    for (var index = 0; index < currentItems.length; index += 1) {
      final currentItem = currentItems[index];
      final nextItem = nextItems[index];
      if (currentItem.id != nextItem.id ||
          currentItem.dailySafetyRecordId != nextItem.dailySafetyRecordId ||
          currentItem.checkinDate != nextItem.checkinDate ||
          currentItem.checkedInAtUtc != nextItem.checkedInAtUtc ||
          currentItem.type != nextItem.type ||
          currentItem.note != nextItem.note ||
          currentItem.mood != nextItem.mood ||
          currentItem.latitude != nextItem.latitude ||
          currentItem.longitude != nextItem.longitude) {
        return false;
      }
    }

    return true;
  }

  int _compareMonthlyCheckin(MonthlyCheckin left, MonthlyCheckin right) {
    final dateComparison = left.dateKey.compareTo(right.dateKey);
    if (dateComparison != 0) {
      return dateComparison;
    }

    return left.id.compareTo(right.id);
  }

  Future<void> previousMonth() {
    final current = state.visibleMonth;
    return load(month: DateTime(current.year, current.month - 1));
  }

  Future<void> nextMonth() {
    if (!state.canGoNext) {
      return Future.value();
    }

    final current = state.visibleMonth;
    return load(month: DateTime(current.year, current.month + 1));
  }
}
