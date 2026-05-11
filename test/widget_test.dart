import 'package:beacon_app/core/providers/providers.dart';
import 'package:beacon_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App builds with provider scope', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;

    try {
      SharedPreferences.setMockInitialValues({});
      dotenv.testLoad(fileInput: 'APP_ENV=production\n');
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const MyApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
