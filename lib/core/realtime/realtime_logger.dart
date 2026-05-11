import 'package:flutter/foundation.dart';

class RealtimeLogger {
  RealtimeLogger._();

  static const String _divider = '------------------------------------------';

  static void connectStart({required String url}) {
    _log('REALTIME CONNECT', {'URL': url});
  }

  static void connected({required String url, String? connectionId}) {
    _log('REALTIME CONNECTED', {'URL': url, 'ID': connectionId});
  }

  static void connectError({required String url, Object? error}) {
    _log('REALTIME CONNECT ERROR', {
      'URL': url,
      'ERROR': _stringifyError(error),
    });
  }

  static void reconnecting({required String url, Object? error}) {
    _log('REALTIME RECONNECTING', {
      'URL': url,
      'ERROR': _stringifyError(error),
    });
  }

  static void reconnected({required String url, String? connectionId}) {
    _log('REALTIME RECONNECTED', {'URL': url, 'ID': connectionId});
  }

  static void disconnected({required String url, Object? error}) {
    _log('REALTIME DISCONNECTED', {
      'URL': url,
      'ERROR': _stringifyError(error),
    });
  }

  static void disconnectError({required String url, Object? error}) {
    _log('REALTIME DISCONNECT ERROR', {
      'URL': url,
      'ERROR': _stringifyError(error),
    });
  }

  static void stop({required String url}) {
    _log('REALTIME STOP', {'URL': url});
  }

  static void joinGroup({required String url, required String groupId}) {
    _log('REALTIME JOIN GROUP', {'URL': url, 'GROUP': groupId});
  }

  static void joinGroupError({
    required String url,
    required String groupId,
    Object? error,
  }) {
    _log('REALTIME JOIN GROUP ERROR', {
      'URL': url,
      'GROUP': groupId,
      'ERROR': _stringifyError(error),
    });
  }

  static void leaveGroup({required String url, required String groupId}) {
    _log('REALTIME LEAVE GROUP', {'URL': url, 'GROUP': groupId});
  }

  static void leaveGroupError({
    required String url,
    required String groupId,
    Object? error,
  }) {
    _log('REALTIME LEAVE GROUP ERROR', {
      'URL': url,
      'GROUP': groupId,
      'ERROR': _stringifyError(error),
    });
  }

  static void skip({required String url, required String reason}) {
    _log('REALTIME SKIP', {'URL': url, 'REASON': reason});
  }

  static void _log(String title, Map<String, String?> lines) {
    if (!kDebugMode) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln(_divider)
      ..writeln(title);
    for (final entry in lines.entries) {
      final value = entry.value;
      if (value == null || value.isEmpty) {
        continue;
      }
      buffer.writeln('  ${entry.key.padRight(8)}: $value');
    }
    buffer.writeln(_divider);
    debugPrint(buffer.toString());
  }

  static String? _stringifyError(Object? error) {
    if (error == null) {
      return null;
    }
    return error.toString();
  }
}
