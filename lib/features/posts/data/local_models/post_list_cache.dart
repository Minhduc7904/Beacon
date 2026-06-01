import 'package:isar/isar.dart';

part 'post_list_cache.g.dart';

@collection
class PostListCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String listScopeKey;

  late String cacheScopeUserId;
  late String feedType;
  String? friendId;
  String? nextCursor;
  late DateTime cachedAtUtc;
}
