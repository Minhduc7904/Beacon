import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_env.dart';
import 'core/config/app_router.dart';
import 'core/database/isar_database.dart';
import 'core/notifications/push_notification_service.dart';
import 'core/observers/app_provider_observer.dart';
import 'core/providers/providers.dart';
import 'core/theme/app/app_theme.dart';
import 'core/widgets/dev/dev_settings_bubble.dart';
import 'core/widgets/message_toast/global_message_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_supportsFirebaseMessaging) {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  await dotenv.load(fileName: '.env');
  final prefs = await SharedPreferences.getInstance();
  final database = await IsarDatabase.open();
  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWith((ref) {
          ref.onDispose(() {
            unawaited(database.close());
          });
          return database;
        }),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    if (_supportsFirebaseMessaging) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(ref.read(pushNotificationServiceProvider).initialize());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref
        .watch(isDarkModeProvider)
        .maybeWhen(
          data: (isDarkMode) => isDarkMode ? ThemeMode.dark : ThemeMode.light,
          orElse: () => ThemeMode.light,
        );

    return MaterialApp.router(
      title: 'Beacon',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      builder: (context, child) {
        final appChild = child ?? const SizedBox.shrink();

        if (!AppEnv.isDev) {
          return appChild;
        }

        return Stack(
          children: [
            GlobalMessageOverlay(child: appChild),
            const DevSettingsBubble(),
          ],
        );
      },
      routerConfig: appRouter,
    );
  }
}

bool get _supportsFirebaseMessaging {
  return !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
}
