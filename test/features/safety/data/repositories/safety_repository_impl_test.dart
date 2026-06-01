import 'package:beacon_app/core/cache/current_user_cache_scope.dart';
import 'package:beacon_app/core/errors/exceptions.dart';
import 'package:beacon_app/core/errors/failures.dart';
import 'package:beacon_app/core/network/network_info.dart';
import 'package:beacon_app/features/safety/data/datasources/safety_local_datasource.dart';
import 'package:beacon_app/features/safety/data/datasources/safety_remote_datasource.dart';
import 'package:beacon_app/features/safety/data/local_models/safety_settings_cache.dart';
import 'package:beacon_app/features/safety/data/models/safety_settings_model.dart';
import 'package:beacon_app/features/safety/data/repositories/safety_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSafetyRemoteDatasource extends Mock
    implements SafetyRemoteDatasource {}

class MockSafetyLocalDatasource extends Mock implements SafetyLocalDatasource {}

class MockCurrentUserCacheScope extends Mock implements CurrentUserCacheScope {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

final _cachedAtUtc = DateTime.utc(2026, 6, 1, 8, 30);

SafetySettingsModel _settings({
  String dailyDeadlineLocalTime = '22:00',
  int gracePeriodMinutes = 15,
  int reminderBeforeMinutes = 45,
  int autoAlertDelayMinutes = 10,
  bool isMonitoringEnabled = true,
  bool isAutoAlertEnabled = true,
  bool isDefault = false,
}) {
  return SafetySettingsModel(
    dailyDeadlineLocalTime: dailyDeadlineLocalTime,
    gracePeriodMinutes: gracePeriodMinutes,
    reminderBeforeMinutes: reminderBeforeMinutes,
    autoAlertDelayMinutes: autoAlertDelayMinutes,
    isMonitoringEnabled: isMonitoringEnabled,
    isAutoAlertEnabled: isAutoAlertEnabled,
    isDefault: isDefault,
  );
}

SafetySettingsCache _cache({
  String cacheScopeUserId = 'user-1',
  String dailyDeadlineLocalTime = '21:30',
}) {
  return SafetySettingsCache()
    ..cacheScopeUserId = cacheScopeUserId
    ..cachedAtUtc = _cachedAtUtc
    ..dailyDeadlineLocalTime = dailyDeadlineLocalTime
    ..gracePeriodMinutes = 20
    ..reminderBeforeMinutes = 30
    ..autoAlertDelayMinutes = 5
    ..isMonitoringEnabled = false
    ..isAutoAlertEnabled = false
    ..isDefault = true;
}

void _stubNetwork(MockNetworkInfo networkInfo, bool isConnected) {
  when(() => networkInfo.isConnected).thenAnswer((_) async => isConnected);
}

void _expectLeft<T>(Either<Failure, T> result, Matcher matcher) {
  result.fold(
    (failure) => expect(failure, matcher),
    (_) => fail('Expected Left'),
  );
}

void _expectRightSame<T>(Either<Failure, T> result, T expected) {
  result.fold(
    (_) => fail('Expected Right'),
    (actual) => expect(actual, same(expected)),
  );
}

void main() {
  late MockSafetyRemoteDatasource remoteDatasource;
  late MockSafetyLocalDatasource localDatasource;
  late MockCurrentUserCacheScope currentUserCacheScope;
  late MockNetworkInfo networkInfo;
  late SafetyRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(_cache());
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    remoteDatasource = MockSafetyRemoteDatasource();
    localDatasource = MockSafetyLocalDatasource();
    currentUserCacheScope = MockCurrentUserCacheScope();
    networkInfo = MockNetworkInfo();
    when(
      () => currentUserCacheScope.getCurrentUserId(),
    ).thenAnswer((_) async => 'user-1');
    when(
      () => localDatasource.upsertSettings(any()),
    ).thenAnswer((_) async {});
    repository = SafetyRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
      currentUserCacheScope: currentUserCacheScope,
      networkInfo: networkInfo,
      nowUtc: () => _cachedAtUtc,
    );
  });

  group('SafetyRepositoryImpl getSafetySettings', () {
    test('online success trả remote và upsert cache theo current user id', () async {
      _stubNetwork(networkInfo, true);
      final settings = _settings();
      when(
        () => remoteDatasource.getSafetySettings(),
      ).thenAnswer((_) async => settings);

      final result = await repository.getSafetySettings();

      _expectRightSame(result, settings);
      final captured = verify(
        () => localDatasource.upsertSettings(captureAny()),
      ).captured.single as SafetySettingsCache;
      expect(captured.cacheScopeUserId, 'user-1');
      expect(captured.cachedAtUtc, _cachedAtUtc);
      expect(captured.dailyDeadlineLocalTime, settings.dailyDeadlineLocalTime);
    });

    test('online success không có current user id thì không ghi cache', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => currentUserCacheScope.getCurrentUserId(),
      ).thenAnswer((_) async => null);
      final settings = _settings();
      when(
        () => remoteDatasource.getSafetySettings(),
      ).thenAnswer((_) async => settings);

      final result = await repository.getSafetySettings();

      _expectRightSame(result, settings);
      verifyNever(() => localDatasource.upsertSettings(any()));
    });

    test('offline có current user id và cache thì trả cached settings', () async {
      _stubNetwork(networkInfo, false);
      final cache = _cache();
      when(
        () => localDatasource.getSettings(cacheScopeUserId: 'user-1'),
      ).thenAnswer((_) async => cache);

      final result = await repository.getSafetySettings();

      result.fold((_) => fail('Expected Right'), (settings) {
        expect(settings.dailyDeadlineLocalTime, cache.dailyDeadlineLocalTime);
        expect(settings.gracePeriodMinutes, cache.gracePeriodMinutes);
        expect(settings.isDefault, cache.isDefault);
      });
      verifyNever(() => remoteDatasource.getSafetySettings());
    });

    test('offline không có current user id thì trả NetworkFailure', () async {
      _stubNetwork(networkInfo, false);
      when(
        () => currentUserCacheScope.getCurrentUserId(),
      ).thenAnswer((_) async => null);

      final result = await repository.getSafetySettings();

      _expectLeft(result, isA<NetworkFailure>());
      verifyNever(
        () => localDatasource.getSettings(
          cacheScopeUserId: any(named: 'cacheScopeUserId'),
        ),
      );
      verifyNever(() => remoteDatasource.getSafetySettings());
    });

    test('offline có current user id nhưng không có cache thì trả NetworkFailure', () async {
      _stubNetwork(networkInfo, false);
      when(
        () => localDatasource.getSettings(cacheScopeUserId: 'user-1'),
      ).thenAnswer((_) async => null);

      final result = await repository.getSafetySettings();

      _expectLeft(result, isA<NetworkFailure>());
      verifyNever(() => remoteDatasource.getSafetySettings());
    });

    test('remote unauthorized không fallback cache', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.getSafetySettings(),
      ).thenThrow(const UnauthorizedException(message: 'Unauthorized'));

      final result = await repository.getSafetySettings();

      _expectLeft(result, isA<UnauthorizedFailure>());
      verifyNever(
        () => localDatasource.getSettings(
          cacheScopeUserId: any(named: 'cacheScopeUserId'),
        ),
      );
      verifyNever(() => localDatasource.upsertSettings(any()));
    });

    test('remote server failure không fallback cache', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.getSafetySettings(),
      ).thenThrow(const ServerException(message: 'Server error'));

      final result = await repository.getSafetySettings();

      _expectLeft(result, isA<ServerFailure>());
      verifyNever(
        () => localDatasource.getSettings(
          cacheScopeUserId: any(named: 'cacheScopeUserId'),
        ),
      );
      verifyNever(() => localDatasource.upsertSettings(any()));
    });
  });

  group('SafetyRepositoryImpl updateSafetySettings', () {
    test('update success trả remote và upsert cache', () async {
      _stubNetwork(networkInfo, true);
      final settings = _settings(gracePeriodMinutes: 30);
      when(
        () => remoteDatasource.updateSafetySettings(body: any(named: 'body')),
      ).thenAnswer((_) async => settings);

      final result = await repository.updateSafetySettings(
        gracePeriodMinutes: 30,
      );

      _expectRightSame(result, settings);
      final body = verify(
        () => remoteDatasource.updateSafetySettings(
          body: captureAny(named: 'body'),
        ),
      ).captured.single as Map<String, dynamic>;
      expect(body, {'gracePeriodMinutes': 30});
      final captured = verify(
        () => localDatasource.upsertSettings(captureAny()),
      ).captured.single as SafetySettingsCache;
      expect(captured.cacheScopeUserId, 'user-1');
      expect(captured.gracePeriodMinutes, 30);
      expect(captured.cachedAtUtc, _cachedAtUtc);
    });

    test('update failure không mutate cache', () async {
      _stubNetwork(networkInfo, true);
      when(
        () => remoteDatasource.updateSafetySettings(body: any(named: 'body')),
      ).thenThrow(const ServerException(message: 'Update failed'));

      final result = await repository.updateSafetySettings(
        gracePeriodMinutes: 30,
      );

      _expectLeft(result, isA<ServerFailure>());
      verifyNever(() => localDatasource.upsertSettings(any()));
    });

    test('offline update trả NetworkFailure và không mutate cache', () async {
      _stubNetwork(networkInfo, false);

      final result = await repository.updateSafetySettings(
        gracePeriodMinutes: 30,
      );

      _expectLeft(result, isA<NetworkFailure>());
      verifyNever(
        () => remoteDatasource.updateSafetySettings(body: any(named: 'body')),
      );
      verifyNever(() => localDatasource.upsertSettings(any()));
    });

    test('validation failure khi body rỗng không mutate cache', () async {
      _stubNetwork(networkInfo, true);

      final result = await repository.updateSafetySettings();

      _expectLeft(result, isA<ValidationFailure>());
      verifyNever(
        () => remoteDatasource.updateSafetySettings(body: any(named: 'body')),
      );
      verifyNever(() => localDatasource.upsertSettings(any()));
    });
  });
}
