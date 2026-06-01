import '../../../../core/utils/time_utils.dart';
import '../../domain/entities/monthly_checkins.dart';

class SafetyMoodCalendarState {
  final DateTime visibleMonth;
  final MonthlyCheckins? monthlyCheckins;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const SafetyMoodCalendarState({
    required this.visibleMonth,
    required this.monthlyCheckins,
    required this.isLoading,
    required this.isRefreshing,
    required this.errorMessage,
  });

  factory SafetyMoodCalendarState.initial() {
    final now = TimeUtils.nowVietnam();
    return SafetyMoodCalendarState(
      visibleMonth: DateTime(now.year, now.month),
      monthlyCheckins: null,
      isLoading: false,
      isRefreshing: false,
      errorMessage: null,
    );
  }

  bool get canGoNext {
    final now = TimeUtils.nowVietnam();
    final currentMonth = DateTime(now.year, now.month);
    return visibleMonth.isBefore(currentMonth);
  }

  SafetyMoodCalendarState copyWith({
    DateTime? visibleMonth,
    MonthlyCheckins? monthlyCheckins,
    bool clearMonthlyCheckins = false,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SafetyMoodCalendarState(
      visibleMonth: visibleMonth ?? this.visibleMonth,
      monthlyCheckins: clearMonthlyCheckins
          ? null
          : (monthlyCheckins ?? this.monthlyCheckins),
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
