import 'package:isar/isar.dart';

part 'message_group_list_cache.g.dart';

@collection
class MessageGroupListCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheScopeUserId;

  String? nextCursor;
  bool hasMore = false;
  int limit = 0;
  late DateTime cachedAtUtc;
}
