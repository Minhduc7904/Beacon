import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../network/api_endpoints.dart';

class RealtimeConfig {
  RealtimeConfig._();

  static const String _hubUrlOverride = String.fromEnvironment(
    'SIGNALR_HUB_URL',
  );

  static final String signalRHubUrl = _hubUrlOverride.trim().isNotEmpty
      ? _hubUrlOverride.trim()
      : dotenv.env['SIGNALR_HUB_URL'] ?? _fallbackSignalRHubUrl();

  static String _fallbackSignalRHubUrl() {
    const suffix = '/api/v1';
    final baseUrl = ApiEndpoints.baseUrl;
    final base = baseUrl.endsWith(suffix)
        ? baseUrl.substring(0, baseUrl.length - suffix.length)
        : baseUrl;
    return '$base/hubs/beacon';
  }
}
