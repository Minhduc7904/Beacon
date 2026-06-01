import 'package:isar/isar.dart';

part 'group_message_list_cache.g.dart';

@collection
class GroupMessageListCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheKey;

  @Index(type: IndexType.value)
  late String cacheScopeUserId;

  @Index(type: IndexType.value)
  late String groupId;

  String? nextCursor;
  bool hasMore = false;
  int limit = 0;
  late DateTime cachedAtUtc;
}
