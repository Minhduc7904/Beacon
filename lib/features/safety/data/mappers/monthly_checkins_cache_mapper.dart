import 'dart:convert';

import '../../domain/entities/monthly_checkin.dart';
import '../../domain/entities/monthly_checkins.dart';
import '../local_models/monthly_checkins_cache.dart';

String monthlyCheckinsCacheKey({
  required String cacheScopeUserId,
  required int year,
  required int month,
}) {
  return '${cacheScopeUserId.trim()}:$year:${month.toString().padLeft(2, '0')}';
}

extension MonthlyCheckinsToCacheMapper on MonthlyCheckins {
  MonthlyCheckinsCache toCache({
    required String cacheScopeUserId,
    required DateTime cachedAtUtc,
  }) {
    return MonthlyCheckinsCache()
      ..cacheScopeMonthKey = monthlyCheckinsCacheKey(
        cacheScopeUserId: cacheScopeUserId,
        year: year,
        month: month,
      )
      ..cacheScopeUserId = cacheScopeUserId.trim()
      ..year = year
      ..month = month
      ..fromDate = fromDate
      ..toDate = toDate
      ..totalCount = totalCount
      ..itemsJson = jsonEncode(_itemsToJson(items))
      ..cachedAtUtc = cachedAtUtc.toUtc();
  }
}

extension MonthlyCheckinsCacheToDomainMapper on MonthlyCheckinsCache {
  MonthlyCheckins toDomain() {
    final decoded = jsonDecode(itemsJson);
    final itemsJsonList = decoded is List ? decoded : const <dynamic>[];

    return MonthlyCheckins(
      year: year,
      month: month,
      fromDate: fromDate,
      toDate: toDate,
      totalCount: totalCount,
      items: itemsJsonList
          .whereType<Map<String, dynamic>>()
          .map(_itemFromJson)
          .toList(),
    );
  }
}

List<Map<String, dynamic>> _itemsToJson(List<MonthlyCheckin> items) {
  final sorted = [...items]..sort((a, b) {
    final dateComparison = a.dateKey.compareTo(b.dateKey);
    if (dateComparison != 0) {
      return dateComparison;
    }

    return a.id.compareTo(b.id);
  });

  return sorted
      .map(
        (item) => <String, dynamic>{
          'id': item.id,
          'dailySafetyRecordId': item.dailySafetyRecordId,
          'checkinDate': item.checkinDate.toIso8601String(),
          'checkedInAtUtc': item.checkedInAtUtc?.toUtc().toIso8601String(),
          'type': item.type,
          'note': item.note,
          'mood': item.mood,
          'latitude': item.latitude,
          'longitude': item.longitude,
        },
      )
      .toList();
}

MonthlyCheckin _itemFromJson(Map<String, dynamic> json) {
  return MonthlyCheckin(
    id: json['id']?.toString() ?? '',
    dailySafetyRecordId: json['dailySafetyRecordId']?.toString() ?? '',
    checkinDate:
        DateTime.tryParse(json['checkinDate']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    checkedInAtUtc: DateTime.tryParse(
      json['checkedInAtUtc']?.toString() ?? '',
    )?.toUtc(),
    type: json['type']?.toString() ?? '',
    note: json['note']?.toString(),
    mood: json['mood']?.toString(),
    latitude: _toDouble(json['latitude']),
    longitude: _toDouble(json['longitude']),
  );
}

double? _toDouble(dynamic value) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '');
}
