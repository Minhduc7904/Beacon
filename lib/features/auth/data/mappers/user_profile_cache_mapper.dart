import '../../domain/entities/user_profile.dart';
import '../local_models/user_profile_cache.dart';
import '../models/user_profile_model.dart';

extension UserProfileToCacheMapper on UserProfile {
  UserProfileCache toCache({
    required String cacheScopeUserId,
    required DateTime cachedAtUtc,
  }) {
    return UserProfileCache()
      ..cacheScopeUserId = cacheScopeUserId
      ..cachedAtUtc = cachedAtUtc.toUtc()
      ..userId = id
      ..username = username
      ..email = email
      ..familyName = familyName
      ..givenName = givenName
      ..phoneNumber = phoneNumber
      ..timeZone = timeZone
      ..isActive = isActive
      ..isEmailVerified = isEmailVerified
      ..lastLoginAtUtc = lastLoginAtUtc?.toUtc()
      ..createdAtUtc = createdAtUtc.toUtc()
      ..avatarMediaObjectId = avatarMediaObjectId
      ..avatarUrl = avatarUrl;
  }
}

extension UserProfileCacheToDomainMapper on UserProfileCache {
  UserProfileModel toDomain() {
    return UserProfileModel(
      id: userId,
      username: username,
      email: email,
      familyName: familyName,
      givenName: givenName,
      phoneNumber: phoneNumber,
      timeZone: timeZone,
      isActive: isActive,
      isEmailVerified: isEmailVerified,
      lastLoginAtUtc: lastLoginAtUtc,
      createdAtUtc: createdAtUtc,
      avatarMediaObjectId: avatarMediaObjectId,
      avatarUrl: avatarUrl,
    );
  }
}
