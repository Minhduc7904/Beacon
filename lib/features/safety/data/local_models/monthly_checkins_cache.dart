import 'package:isar/isar.dart';

part 'monthly_checkins_cache.g.dart';

@collection
class MonthlyCheckinsCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheScopeMonthKey;

  @Index(type: IndexType.value)
  late String cacheScopeUserId;

  late int year;
  late int month;
  late DateTime fromDate;
  late DateTime toDate;
  late int totalCount;
  late String itemsJson;
  late DateTime cachedAtUtc;
}
