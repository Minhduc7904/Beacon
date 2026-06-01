import 'package:beacon_app/features/auth/data/mappers/user_profile_cache_mapper.dart';
import 'package:beacon_app/features/auth/data/models/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

UserProfileModel _profile({
  String id = 'user-1',
  String? phoneNumber = '+84912345678',
  String? avatarMediaObjectId = 'avatar-media-1',
  String? avatarUrl = 'https://example.com/avatar.jpg',
}) {
  return UserProfileModel(
    id: id,
    username: 'mai',
    email: 'mai@example.com',
    familyName: 'Nguyen',
    givenName: 'Mai',
    phoneNumber: phoneNumber,
    timeZone: 'Asia/Ho_Chi_Minh',
    isActive: true,
    isEmailVerified: true,
    lastLoginAtUtc: DateTime.utc(2026, 5, 26, 10),
    createdAtUtc: DateTime.utc(2025, 1, 1),
    avatarMediaObjectId: avatarMediaObjectId,
    avatarUrl: avatarUrl,
  );
}

void main() {
  group('UserProfileCacheMapper', () {
    test('map profile model thành cache với scope user và metadata cache', () {
      final profile = _profile();
      final cachedAtUtc = DateTime.utc(2026, 6, 1, 8, 30);

      final cache = profile.toCache(
        cacheScopeUserId: 'user-1',
        cachedAtUtc: cachedAtUtc,
      );

      expect(cache.cacheScopeUserId, 'user-1');
      expect(cache.cachedAtUtc, cachedAtUtc);
      expect(cache.userId, profile.id);
      expect(cache.username, profile.username);
      expect(cache.email, profile.email);
      expect(cache.familyName, profile.familyName);
      expect(cache.givenName, profile.givenName);
      expect(cache.phoneNumber, profile.phoneNumber);
      expect(cache.timeZone, profile.timeZone);
      expect(cache.isActive, profile.isActive);
      expect(cache.isEmailVerified, profile.isEmailVerified);
      expect(cache.lastLoginAtUtc, profile.lastLoginAtUtc);
      expect(cache.createdAtUtc, profile.createdAtUtc);
      expect(cache.avatarMediaObjectId, profile.avatarMediaObjectId);
      expect(cache.avatarUrl, profile.avatarUrl);
    });

    test('map cache thành UserProfileModel và giữ nullable field', () {
      final profile = _profile(
        phoneNumber: null,
        avatarMediaObjectId: null,
        avatarUrl: null,
      );
      final cache = profile.toCache(
        cacheScopeUserId: 'user-1',
        cachedAtUtc: DateTime.utc(2026, 6, 1, 8, 30),
      );

      final domain = cache.toDomain();

      expect(domain, isA<UserProfileModel>());
      expect(domain.id, profile.id);
      expect(domain.phoneNumber, isNull);
      expect(domain.avatarMediaObjectId, isNull);
      expect(domain.avatarUrl, isNull);
      expect(domain.fullName, 'Nguyen Mai');
    });
  });
}
