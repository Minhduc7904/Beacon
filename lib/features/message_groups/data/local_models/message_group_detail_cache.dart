import 'package:isar/isar.dart';

part 'message_group_detail_cache.g.dart';

@collection
class MessageGroupDetailCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheKey;

  @Index(type: IndexType.value)
  late String cacheScopeUserId;

  @Index(type: IndexType.value)
  late String groupId;

  late String detailJson;
  late DateTime cachedAtUtc;
}
