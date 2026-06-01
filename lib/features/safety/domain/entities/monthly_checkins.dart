import 'monthly_checkin.dart';

class MonthlyCheckins {
  final int year;
  final int month;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalCount;
  final List<MonthlyCheckin> items;

  const MonthlyCheckins({
    required this.year,
    required this.month,
    required this.fromDate,
    required this.toDate,
    required this.totalCount,
    required this.items,
  });

  Map<String, MonthlyCheckin> get itemsByDateKey {
    return {for (final item in items) item.dateKey: item};
  }
}
