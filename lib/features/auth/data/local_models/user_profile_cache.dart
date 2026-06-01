import 'package:isar/isar.dart';

part 'user_profile_cache.g.dart';

@collection
class UserProfileCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, type: IndexType.value)
  late String cacheScopeUserId;

  late DateTime cachedAtUtc;

  late String userId;
  late String username;
  late String email;
  late String familyName;
  late String givenName;
  String? phoneNumber;
  late String timeZone;
  late bool isActive;
  late bool isEmailVerified;
  DateTime? lastLoginAtUtc;
  late DateTime createdAtUtc;
  String? avatarMediaObjectId;
  String? avatarUrl;
}
