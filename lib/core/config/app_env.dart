import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static String get appEnv =>
      (dotenv.env['APP_ENV'] ?? 'dev').trim().toLowerCase();

  static bool get isDev => appEnv == 'dev';

  static bool get isProduction => appEnv == 'production';
}
