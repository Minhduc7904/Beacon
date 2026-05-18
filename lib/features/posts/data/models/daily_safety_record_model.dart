import '../../domain/entities/daily_safety_record.dart';

class DailySafetyRecordModel extends DailySafetyRecord {
  const DailySafetyRecordModel({
    required super.id,
    required super.userId,
    required super.date,
    required super.status,
    required super.deadlineAtUtc,
    required super.checkedInAtUtc,
    required super.markedMissedAtUtc,
    required super.reminderSentAtUtc,
    required super.resolvedAtUtc,
    required super.lastEvaluatedAtUtc,
  });

  factory DailySafetyRecordModel.fromJson(Map<String, dynamic> json) {
    return DailySafetyRecordModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      deadlineAtUtc: _toDate(json['deadlineAtUtc']),
      checkedInAtUtc: _toDate(json['checkedInAtUtc']),
      markedMissedAtUtc: _toDate(json['markedMissedAtUtc']),
      reminderSentAtUtc: _toDate(json['reminderSentAtUtc']),
      resolvedAtUtc: _toDate(json['resolvedAtUtc']),
      lastEvaluatedAtUtc: _toDate(json['lastEvaluatedAtUtc']),
    );
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(raw);
  }
}
