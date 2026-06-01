import 'package:beacon_app/core/database/app_database.dart';
import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/features/auth/data/datasources/user_profile_local_datasource_impl.dart';
import 'package:beacon_app/features/auth/data/local_models/user_profile_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

class FakeAppDatabase implements AppDatabase {
  int readCount = 0;
  int writeCount = 0;

  @override
  Future<T> read<T>(Future<T> Function(Isar isar) action) {
    readCount++;
    throw StateError('read should not be called');
  }

  @override
  Future<T> write<T>(Future<T> Function(Isar isar) action) {
    writeCount++;
    throw StateError('write should not be called');
  }

  @override
  Future<void> close() async {}
}

void main() {
  group('UserProfileLocalDatasourceImpl', () {
    test('không đọc database khi cacheScopeUserId rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = UserProfileLocalDatasourceImpl(database);

      await expectLater(
        datasource.getProfile(cacheScopeUserId: ' '),
        throwsA(isA<CacheException>()),
      );
      expect(database.readCount, 0);
    });

    test('không ghi database khi upsert cacheScopeUserId rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = UserProfileLocalDatasourceImpl(database);
      final cache = UserProfileCache()..cacheScopeUserId = '';

      await expectLater(
        datasource.upsertProfile(cache),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });

    test('không ghi database khi delete cacheScopeUserId rỗng', () async {
      final database = FakeAppDatabase();
      final datasource = UserProfileLocalDatasourceImpl(database);

      await expectLater(
        datasource.deleteProfile(cacheScopeUserId: ''),
        throwsA(isA<CacheException>()),
      );
      expect(database.writeCount, 0);
    });
  });
}
