import 'package:beacon_app/core/providers/providers.dart';
import 'package:beacon_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fakes/fake_auth_backend.dart';
import '../fakes/fake_feature_repositories.dart';
import '../fakes/fake_realtime_services.dart';

class BeaconIntegrationTestApp {
  BeaconIntegrationTestApp._({
    required this.prefs,
    required this.authLocalDatasource,
    required this.authRepository,
    required this.signalRService,
    required this.pushNotificationService,
    required this.messageGroupRealtimeService,
    required this.friendsRealtimeService,
    required this.postsRealtimeService,
    required this.checkinRepository,
    required this.safetyRepository,
    required this.friendsRepository,
    required this.messageGroupsRepository,
    required this.postsRepository,
  });

  final SharedPreferences prefs;
  final InMemoryAuthLocalDatasource authLocalDatasource;
  final FakeAuthRepository authRepository;
  final FakeSignalRService signalRService;
  final FakePushNotificationService pushNotificationService;
  final FakeMessageGroupRealtimeService messageGroupRealtimeService;
  final FakeFriendsRealtimeService friendsRealtimeService;
  final FakePostsRealtimeService postsRealtimeService;
  final FakeCheckinRepository checkinRepository;
  final FakeSafetyRepository safetyRepository;
  final FakeFriendsRepository friendsRepository;
  final FakeMessageGroupsRepository messageGroupsRepository;
  final FakePostsRepository postsRepository;

  static Future<BeaconIntegrationTestApp> create({
    bool autoLoginAfterRegister = false,
  }) async {
    SharedPreferences.setMockInitialValues({});
    dotenv.testLoad(fileInput: 'APP_ENV=production\n');

    final prefs = await SharedPreferences.getInstance();
    final authLocalDatasource = InMemoryAuthLocalDatasource();

    return BeaconIntegrationTestApp._(
      prefs: prefs,
      authLocalDatasource: authLocalDatasource,
      authRepository: FakeAuthRepository(
        localDatasource: authLocalDatasource,
        autoLoginAfterRegister: autoLoginAfterRegister,
      ),
      signalRService: FakeSignalRService(),
      pushNotificationService: FakePushNotificationService(),
      messageGroupRealtimeService: FakeMessageGroupRealtimeService(),
      friendsRealtimeService: FakeFriendsRealtimeService(),
      postsRealtimeService: FakePostsRealtimeService(),
      checkinRepository: FakeCheckinRepository(),
      safetyRepository: FakeSafetyRepository(),
      friendsRepository: FakeFriendsRepository(),
      messageGroupsRepository: FakeMessageGroupsRepository(),
      postsRepository: FakePostsRepository(),
    );
  }

  Widget build() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authLocalDatasourceProvider.overrideWithValue(authLocalDatasource),
        authRepositoryProvider.overrideWithValue(authRepository),
        signalRServiceProvider.overrideWithValue(signalRService),
        pushNotificationServiceProvider.overrideWithValue(
          pushNotificationService,
        ),
        messageGroupRealtimeServiceProvider.overrideWithValue(
          messageGroupRealtimeService,
        ),
        friendsRealtimeServiceProvider.overrideWithValue(
          friendsRealtimeService,
        ),
        postsRealtimeServiceProvider.overrideWithValue(postsRealtimeService),
        checkinRepositoryProvider.overrideWithValue(checkinRepository),
        safetyRepositoryProvider.overrideWithValue(safetyRepository),
        friendsRepositoryProvider.overrideWithValue(friendsRepository),
        messageGroupsRepositoryProvider.overrideWithValue(
          messageGroupsRepository,
        ),
        postsRepositoryProvider.overrideWithValue(postsRepository),
      ],
      child: const MyApp(),
    );
  }
}

Future<BeaconIntegrationTestApp> pumpBeaconIntegrationApp(
  WidgetTester tester, {
  bool autoLoginAfterRegister = false,
}) async {
  final app = await BeaconIntegrationTestApp.create(
    autoLoginAfterRegister: autoLoginAfterRegister,
  );

  await tester.pumpWidget(app.build());
  await tester.pump(const Duration(milliseconds: 100));

  return app;
}
