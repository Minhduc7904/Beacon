import 'package:isar/isar.dart';

part 'post_cache.g.dart';

@collection
class PostCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheKey;

  @Index(type: IndexType.value)
  late String listScopeKey;

  late String cacheScopeUserId;
  late String postId;
  late int sortOrder;
  late String postJson;
  String? localImagePath;
  String? localThumbnailPath;
  String? mediaCacheKey;
  DateTime? mediaCachedAtUtc;
  late DateTime cachedAtUtc;
}
