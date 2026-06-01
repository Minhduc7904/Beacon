import 'package:isar/isar.dart';

part 'group_message_cache.g.dart';

@collection
class GroupMessageCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheKey;

  @Index(type: IndexType.value)
  late String cacheScopeUserId;

  @Index(type: IndexType.value)
  late String groupId;

  @Index(type: IndexType.value)
  late String messageId;

  DateTime? createdAtUtc;
  late String messageJson;
  late DateTime cachedAtUtc;
}
