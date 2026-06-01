import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static const String _appEnvOverride = String.fromEnvironment('APP_ENV');
  static const String _devSeedResetTokenOverride = String.fromEnvironment(
    'DEV_SEED_RESET_TOKEN',
  );

  static String get appEnv =>
      (_appEnvOverride.trim().isNotEmpty
              ? _appEnvOverride
              : dotenv.env['APP_ENV'] ?? 'dev')
          .trim()
          .toLowerCase();

  static bool get isDev => appEnv == 'dev';

  static bool get isProduction => appEnv == 'production';

  static String get devSeedResetToken =>
      (_devSeedResetTokenOverride.trim().isNotEmpty
              ? _devSeedResetTokenOverride
              : dotenv.env['DEV_SEED_RESET_TOKEN'] ?? '')
          .trim();
}
