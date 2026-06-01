class MonthlyCheckin {
  final String id;
  final String dailySafetyRecordId;
  final DateTime checkinDate;
  final DateTime? checkedInAtUtc;
  final String type;
  final String? note;
  final String? mood;
  final double? latitude;
  final double? longitude;

  const MonthlyCheckin({
    required this.id,
    required this.dailySafetyRecordId,
    required this.checkinDate,
    required this.checkedInAtUtc,
    required this.type,
    required this.note,
    required this.mood,
    required this.latitude,
    required this.longitude,
  });

  String get dateKey =>
      '${checkinDate.year.toString().padLeft(4, '0')}-'
      '${checkinDate.month.toString().padLeft(2, '0')}-'
      '${checkinDate.day.toString().padLeft(2, '0')}';
}
