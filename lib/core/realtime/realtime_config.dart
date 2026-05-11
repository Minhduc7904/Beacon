import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../network/api_endpoints.dart';

class RealtimeConfig {
  RealtimeConfig._();

  static final String signalRHubUrl =
      dotenv.env['SIGNALR_HUB_URL'] ?? _fallbackSignalRHubUrl();

  static String _fallbackSignalRHubUrl() {
    const suffix = '/api/v1';
    final baseUrl = ApiEndpoints.baseUrl;
    final base = baseUrl.endsWith(suffix)
        ? baseUrl.substring(0, baseUrl.length - suffix.length)
        : baseUrl;
    return '$base/hubs/beacon';
  }
}
