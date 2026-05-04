enum CheckinType { manual, recovery, emergency, unknown }

class CheckinRecord {
  final String id;
  final String dailySafetyRecordId;
  final String checkinDate;
  final DateTime? checkedInAtUtc;
  final CheckinType type;
  final String? note;
  final double? latitude;
  final double? longitude;
  final String? mediaObjectId;

  const CheckinRecord({
    required this.id,
    required this.dailySafetyRecordId,
    required this.checkinDate,
    required this.checkedInAtUtc,
    required this.type,
    required this.note,
    required this.latitude,
    required this.longitude,
    required this.mediaObjectId,
  });
}
