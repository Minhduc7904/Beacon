import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icon_data.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../../core/widgets/button/icon_circle_button.dart';
import '../../../../core/widgets/emoji/app_emoji.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/monthly_checkin.dart';
import '../controllers/safety_mood_calendar_state.dart';

class SafetyMoodCalendarButton extends StatelessWidget {
  const SafetyMoodCalendarButton({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return IconCircleButton(
      icon: AppIcons.moodHappyPhosphor,
      size: 60,
      iconSize: 32,
      backgroundColor: AppColors.coral100,
      borderColor: AppColors.coral200,
      iconColor: AppColors.coral500,
      borderWidth: 4,
      onPressed: enabled
          ? () => showDialog<void>(
              context: context,
              builder: (_) => const SafetyMoodCalendarDialog(),
            )
          : null,
    );
  }
}

class SafetyMoodCalendarDialog extends ConsumerStatefulWidget {
  const SafetyMoodCalendarDialog({super.key});

  @override
  ConsumerState<SafetyMoodCalendarDialog> createState() =>
      _SafetyMoodCalendarDialogState();
}

class _SafetyMoodCalendarDialogState
    extends ConsumerState<SafetyMoodCalendarDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(safetyMoodCalendarNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(safetyMoodCalendarNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CalendarHeader(state: state),
                const SizedBox(height: 12),
                _WeekdayRow(color: colorScheme.onSurface),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: state.isLoading && state.monthlyCheckins == null
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          height: 294,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : _MoodCalendarGrid(
                          key: ValueKey(
                            '${state.visibleMonth.year}-${state.visibleMonth.month}',
                          ),
                          state: state,
                        ),
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 10),
                  AppText(
                    state.errorMessage!,
                    preset: AppTextPreset.bodySmall,
                    color: colorScheme.error,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarHeader extends ConsumerWidget {
  const _CalendarHeader({required this.state});

  final SafetyMoodCalendarState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 42,
      child: Row(
        children: [
          _HeaderIconButton(
            icon: AppIcons.back,
            onPressed: () => ref
                .read(safetyMoodCalendarNotifierProvider.notifier)
                .previousMonth(),
          ),
          Expanded(
            child: AppText(
              'Tháng ${state.visibleMonth.month}/${state.visibleMonth.year}',
              preset: AppTextPreset.titleMedium,
              color: colorScheme.onSurface,
              textAlign: TextAlign.center,
            ),
          ),
          _HeaderIconButton(
            icon: AppIcons.caretRight,
            onPressed: state.canGoNext
                ? () => ref
                      .read(safetyMoodCalendarNotifierProvider.notifier)
                      .nextMonth()
                : null,
          ),
          _HeaderIconButton(
            icon: AppIcons.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onPressed});

  final AppIconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(
            child: AppIcon(
              icon,
              size: 18,
              color: colorScheme.onSurface.withValues(
                alpha: enabled ? 0.72 : 0.25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Row(
      children: [
        for (final label in labels)
          Expanded(
            child: AppText(
              label,
              size: AppTextSize.veryTiny,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.medium,
              color: color.withValues(alpha: 0.54),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _MoodCalendarGrid extends StatelessWidget {
  const _MoodCalendarGrid({super.key, required this.state});

  final SafetyMoodCalendarState state;

  @override
  Widget build(BuildContext context) {
    final month = state.visibleMonth;
    final firstDay = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmptyCells = firstDay.weekday - DateTime.monday;
    final cellCount = leadingEmptyCells + daysInMonth;
    final rowCount = (cellCount / 7).ceil();
    final totalCells = rowCount * 7;
    final itemsByDateKey = state.monthlyCheckins?.itemsByDateKey ?? {};
    final today = TimeUtils.nowVietnam();

    return SizedBox(
      height: (rowCount * 58).toDouble(),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalCells,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: 58,
        ),
        itemBuilder: (context, index) {
          final dayNumber = index - leadingEmptyCells + 1;
          if (dayNumber < 1 || dayNumber > daysInMonth) {
            return const SizedBox.shrink();
          }

          final date = DateTime(month.year, month.month, dayNumber);
          final key = _dateKey(date);
          final checkin = itemsByDateKey[key];
          final dateOnly = DateTime(date.year, date.month, date.day);
          final todayOnly = DateTime(today.year, today.month, today.day);

          return _MoodCalendarDay(
            date: date,
            checkin: checkin,
            isPastMissing: checkin == null && dateOnly.isBefore(todayOnly),
            isToday: dateOnly == todayOnly,
          );
        },
      ),
    );
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

class _MoodCalendarDay extends StatelessWidget {
  const _MoodCalendarDay({
    required this.date,
    required this.checkin,
    required this.isPastMissing,
    required this.isToday,
  });

  final DateTime date;
  final MonthlyCheckin? checkin;
  final bool isPastMissing;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MoodCalendarDayMark(
            checkin: checkin,
            isPastMissing: isPastMissing,
            isToday: isToday,
          ),
          const SizedBox(height: 4),
          AppText(
            date.day.toString(),
            size: AppTextSize.veryTiny,
            spacing: AppTextSpacing.tight,
            weight: isToday ? AppTextWeight.bold : AppTextWeight.regular,
            color: isPastMissing
                ? colorScheme.onSurface.withValues(alpha: 0.46)
                : colorScheme.onSurface.withValues(alpha: 0.72),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MoodCalendarDayMark extends StatelessWidget {
  const _MoodCalendarDayMark({
    required this.checkin,
    required this.isPastMissing,
    required this.isToday,
  });

  final MonthlyCheckin? checkin;
  final bool isPastMissing;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final mood = checkin?.mood?.trim();
    final colorScheme = Theme.of(context).colorScheme;

    if (mood != null && mood.isNotEmpty) {
      return _CircleShell(
        backgroundColor: AppColors.teal100,
        borderColor: isToday ? AppColors.coral400 : AppColors.teal300,
        child: AppEmoji(emoji: mood, size: 22),
      );
    }

    if (checkin != null) {
      return _CircleShell(
        backgroundColor: AppColors.teal400,
        borderColor: isToday ? AppColors.coral400 : AppColors.teal400,
        child: const AppIcon(AppIcons.check, size: 18, color: AppColors.sky100),
      );
    }

    if (isPastMissing) {
      return _CircleShell(
        backgroundColor: AppColors.sky400,
        borderColor: AppColors.sky500,
        child: const SizedBox.shrink(),
      );
    }

    return _CircleShell(
      backgroundColor: Colors.transparent,
      borderColor: isToday
          ? AppColors.coral400
          : colorScheme.outline.withValues(alpha: 0.28),
      child: const SizedBox.shrink(),
    );
  }
}

class _CircleShell extends StatelessWidget {
  const _CircleShell({
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: Center(child: child),
    );
  }
}
