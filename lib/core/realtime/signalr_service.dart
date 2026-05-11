import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import 'realtime_config.dart';
import 'realtime_logger.dart';

class SignalRService {
  SignalRService(this._authLocalDatasource);

  final AuthLocalDatasource _authLocalDatasource;
  HubConnection? _connection;
  Future<void>? _connecting;

  String get _hubUrl => RealtimeConfig.signalRHubUrl;

  bool get isConnected => _connection?.state == HubConnectionState.connected;

  Future<void> connect() async {
    if (isConnected) {
      return;
    }

    final pending = _connecting;
    if (pending != null) {
      await pending;
      return;
    }

    _connecting = _connectInternal();
    try {
      await _connecting;
    } catch (_) {
      // Errors already logged in _connectInternal.
    } finally {
      _connecting = null;
    }
  }

  Future<void> disconnect() async {
    try {
      RealtimeLogger.stop(url: _hubUrl);
      await _stopConnection();
    } catch (error) {
      RealtimeLogger.disconnectError(url: _hubUrl, error: error);
    } finally {
      _connection = null;
    }
  }

  Future<void> invoke(String methodName, {List<Object?>? args}) async {
    final trimmedMethodName = methodName.trim();
    if (trimmedMethodName.isEmpty) {
      return;
    }

    await connect();
    final connection = _connection;
    if (connection == null ||
        connection.state != HubConnectionState.connected) {
      return;
    }

    await connection.invoke(trimmedMethodName, args: args ?? const []);
  }

  VoidCallback on(
    String eventName,
    void Function(Map<String, dynamic>) handler,
  ) {
    return onArgs(eventName, (args) {
      if (args == null || args.isEmpty) {
        return;
      }
      final payload = args.first;
      if (payload is Map) {
        handler(Map<String, dynamic>.from(payload));
      }
    });
  }

  VoidCallback onArgs(
    String eventName,
    void Function(List<Object?>? args) handler,
  ) {
    final trimmedEventName = eventName.trim();
    if (trimmedEventName.isEmpty) {
      return () {};
    }

    final connection = _connection ?? _buildConnection();
    _connection = connection;
    connection.on(trimmedEventName, handler);
    return () => connection.off(trimmedEventName, method: handler);
  }

  HubConnection _buildConnection() {
    final connection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          HttpConnectionOptions(
            accessTokenFactory: () async {
              final token = await _authLocalDatasource.getAccessToken();
              return token ?? '';
            },
          ),
        )
        .withAutomaticReconnect()
        .build();

    _attachLogging(connection);
    return connection;
  }

  Future<void> _connectInternal() async {
    final token = await _authLocalDatasource.getAccessToken();
    if (token == null || token.isEmpty) {
      RealtimeLogger.skip(url: _hubUrl, reason: 'Missing access token');
      return;
    }

    final connection = _connection ?? _buildConnection();
    _connection = connection;

    if (connection.state == HubConnectionState.connected ||
        connection.state == HubConnectionState.connecting) {
      return;
    }

    try {
      RealtimeLogger.connectStart(url: _hubUrl);
      await connection.start();
      RealtimeLogger.connected(
        url: _hubUrl,
        connectionId: connection.connectionId,
      );
    } catch (error) {
      RealtimeLogger.connectError(url: _hubUrl, error: error);
      await _stopConnection();
      rethrow;
    }
  }

  void _attachLogging(HubConnection connection) {
    connection.onclose((error) {
      RealtimeLogger.disconnected(url: _hubUrl, error: error);
    });

    connection.onreconnecting((error) {
      RealtimeLogger.reconnecting(url: _hubUrl, error: error);
    });

    connection.onreconnected((connectionId) {
      RealtimeLogger.reconnected(url: _hubUrl, connectionId: connectionId);
    });
  }

  Future<void> _stopConnection() async {
    final connection = _connection;
    if (connection == null) {
      return;
    }

    if (connection.state == HubConnectionState.disconnected) {
      return;
    }

    await connection.stop();
  }
}
