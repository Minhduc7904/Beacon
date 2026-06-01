import '../../../../core/utils/time_utils.dart';
import '../../domain/entities/monthly_checkin.dart';

class MonthlyCheckinModel extends MonthlyCheckin {
  const MonthlyCheckinModel({
    required super.id,
    required super.dailySafetyRecordId,
    required super.checkinDate,
    required super.checkedInAtUtc,
    required super.type,
    required super.note,
    required super.mood,
    required super.latitude,
    required super.longitude,
  });

  factory MonthlyCheckinModel.fromJson(Map<String, dynamic> json) {
    return MonthlyCheckinModel(
      id: json['id']?.toString() ?? '',
      dailySafetyRecordId: json['dailySafetyRecordId']?.toString() ?? '',
      checkinDate:
          _toDate(json['checkinDate']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      checkedInAtUtc: TimeUtils.tryParseUtc(json['checkedInAtUtc']),
      type: json['type']?.toString() ?? '',
      note: json['note']?.toString(),
      mood: json['mood']?.toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
    );
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString().trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  static double? _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }
}
