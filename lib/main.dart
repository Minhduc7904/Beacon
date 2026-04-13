import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_router.dart';
import 'core/observers/app_provider_observer.dart';
import 'core/providers/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/message_toast/global_message_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      builder: (context, child) => GlobalMessageOverlay(child: child!),
      routerConfig: appRouter,
    );
  }
}
