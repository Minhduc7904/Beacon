import '../../domain/entities/checkin_record.dart';

class CheckinRecordModel extends CheckinRecord {
  const CheckinRecordModel({
    required super.id,
    required super.dailySafetyRecordId,
    required super.checkinDate,
    required super.checkedInAtUtc,
    required super.type,
    required super.note,
    required super.latitude,
    required super.longitude,
    required super.mediaObjectId,
  });

  factory CheckinRecordModel.fromJson(Map<String, dynamic> json) {
    return CheckinRecordModel(
      id: json['id']?.toString() ?? '',
      dailySafetyRecordId: json['dailySafetyRecordId']?.toString() ?? '',
      checkinDate: json['checkinDate']?.toString() ?? '',
      checkedInAtUtc: _toDate(json['checkedInAtUtc']),
      type: _parseType(json['type']),
      note: json['note']?.toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      mediaObjectId: json['mediaObjectId']?.toString(),
    );
  }

  static DateTime? _toDate(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  static CheckinType _parseType(dynamic value) {
    final raw = value?.toString().toLowerCase().trim();
    switch (raw) {
      case 'manual':
        return CheckinType.manual;
      case 'recovery':
        return CheckinType.recovery;
      case 'emergency':
        return CheckinType.emergency;
      default:
        return CheckinType.unknown;
    }
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
