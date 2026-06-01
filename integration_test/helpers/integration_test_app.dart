import 'package:beacon_app/core/config/app_env.dart';
import 'package:beacon_app/core/database/app_database.dart';
import 'package:beacon_app/core/database/isar_database.dart';
import 'package:beacon_app/core/network/api_endpoints.dart';
import 'package:beacon_app/core/network/network_info.dart';
import 'package:beacon_app/core/providers/providers.dart';
import 'package:beacon_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:beacon_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fakes/fake_realtime_services.dart';

const _appEnvOverride = String.fromEnvironment('APP_ENV');
const _baseUrlOverride = String.fromEnvironment('BASE_URL');
const _signalRHubUrlOverride = String.fromEnvironment('SIGNALR_HUB_URL');
const _devSeedResetTokenOverride = String.fromEnvironment(
  'DEV_SEED_RESET_TOKEN',
);

class BeaconIntegrationTestApp {
  BeaconIntegrationTestApp._({
    required this.prefs,
    required this.authLocalDatasource,
    required this.pushNotificationService,
    required this.appDatabase,
  });

  final SharedPreferences prefs;
  final IntegrationAuthLocalDatasource authLocalDatasource;
  final FakePushNotificationService pushNotificationService;
  final AppDatabase appDatabase;

  static Future<BeaconIntegrationTestApp> create({
    bool resetBackend = true,
  }) async {
    SharedPreferences.setMockInitialValues({});
    await _loadIntegrationEnv();

    if (resetBackend) {
      await resetBackendTestData();
    }

    final prefs = await SharedPreferences.getInstance();
    final authLocalDatasource = IntegrationAuthLocalDatasource();
    final appDatabase = await IsarDatabase.open();

    await appDatabase.clearAll();

    return BeaconIntegrationTestApp._(
      prefs: prefs,
      authLocalDatasource: authLocalDatasource,
      pushNotificationService: FakePushNotificationService(),
      appDatabase: appDatabase,
    );
  }

  Widget build() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authLocalDatasourceProvider.overrideWithValue(authLocalDatasource),
        appDatabaseProvider.overrideWithValue(appDatabase),
        networkInfoProvider.overrideWithValue(
          const AlwaysConnectedNetworkInfo(),
        ),
        pushNotificationServiceProvider.overrideWithValue(
          pushNotificationService,
        ),
      ],
      child: const MyApp(),
    );
  }

  Future<void> dispose() async {
    await appDatabase.close();
  }
}

Future<BeaconIntegrationTestApp> pumpBeaconIntegrationApp(
  WidgetTester tester, {
  bool resetBackend = true,
}) async {
  final app = await BeaconIntegrationTestApp.create(resetBackend: resetBackend);

  await tester.pumpWidget(app.build());
  await tester.pump(const Duration(milliseconds: 100));

  addTearDown(app.dispose);

  return app;
}

Future<void> resetBackendTestData() async {
  final token = AppEnv.devSeedResetToken;
  if (token.isEmpty) {
    throw StateError(
      'DEV_SEED_RESET_TOKEN is required for N2N integration tests.',
    );
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      validateStatus: (_) => true,
    ),
  );

  final response = await dio.post<dynamic>(
    '/dev/test-data/reset',
    options: Options(headers: {'X-Dev-Seed-Token': token}),
  );

  final statusCode = response.statusCode ?? 0;
  if (statusCode < 200 || statusCode >= 300) {
    throw StateError(
      'Backend test data reset failed with HTTP $statusCode: ${response.data}',
    );
  }
}

Future<void> _loadIntegrationEnv() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Tests can run with only --dart-define values.
  }

  final appEnv = _resolveEnvValue(
    key: 'APP_ENV',
    overrideValue: _appEnvOverride,
    defaultValue: 'production',
  );

  final baseUrl = _resolveEnvValue(
    key: 'BASE_URL',
    overrideValue: _baseUrlOverride,
    defaultValue: 'http://localhost:5000/api/v1',
  );

  final signalRHubUrl = _resolveEnvValue(
    key: 'SIGNALR_HUB_URL',
    overrideValue: _signalRHubUrlOverride,
    defaultValue: '',
  );

  final devSeedResetToken = _resolveEnvValue(
    key: 'DEV_SEED_RESET_TOKEN',
    overrideValue: _devSeedResetTokenOverride,
    defaultValue: '',
  );

  dotenv.testLoad(
    fileInput: [
      'APP_ENV=$appEnv',
      'BASE_URL=$baseUrl',
      if (signalRHubUrl.isNotEmpty) 'SIGNALR_HUB_URL=$signalRHubUrl',
      if (devSeedResetToken.isNotEmpty)
        'DEV_SEED_RESET_TOKEN=$devSeedResetToken',
    ].join('\n'),
  );
}

String _resolveEnvValue({
  required String key,
  required String overrideValue,
  required String defaultValue,
}) {
  final trimmedOverride = overrideValue.trim();
  if (trimmedOverride.isNotEmpty) {
    return trimmedOverride;
  }

  final dotenvValue = dotenv.env[key]?.trim();
  if (dotenvValue != null && dotenvValue.isNotEmpty) {
    return dotenvValue;
  }

  return defaultValue;
}

class IntegrationAuthLocalDatasource implements AuthLocalDatasource {
  String? _accessToken;
  String? _refreshToken;
  DateTime? _accessTokenExpiresAt;

  @override
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _accessTokenExpiresAt = null;
  }

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<DateTime?> getAccessTokenExpiresAt() async => _accessTokenExpiresAt;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> saveAccessToken(String token) async {
    _accessToken = token;
  }

  @override
  Future<void> saveAccessTokenExpiresAt(DateTime? expiresAt) async {
    _accessTokenExpiresAt = expiresAt;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _refreshToken = token;
  }
}

class AlwaysConnectedNetworkInfo implements NetworkInfo {
  const AlwaysConnectedNetworkInfo();

  @override
  Future<bool> get isConnected async => true;
}