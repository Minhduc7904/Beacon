import '../../domain/entities/monthly_checkins.dart';
import 'monthly_checkin_model.dart';

class MonthlyCheckinsModel extends MonthlyCheckins {
  const MonthlyCheckinsModel({
    required super.year,
    required super.month,
    required super.fromDate,
    required super.toDate,
    required super.totalCount,
    required super.items,
  });

  factory MonthlyCheckinsModel.fromJson(Map<String, dynamic> json) {
    final year = _toInt(json['year']);
    final month = _toInt(json['month']);
    final itemsJson = json['items'];

    return MonthlyCheckinsModel(
      year: year,
      month: month,
      fromDate:
          _toDate(json['fromDate']) ?? DateTime(year, month < 1 ? 1 : month, 1),
      toDate:
          _toDate(json['toDate']) ?? DateTime(year, month < 1 ? 1 : month, 1),
      totalCount: _toInt(json['totalCount']),
      items: itemsJson is List
          ? itemsJson
                .whereType<Map<String, dynamic>>()
                .map(MonthlyCheckinModel.fromJson)
                .toList()
          : const <MonthlyCheckinModel>[],
    );
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

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }
}
