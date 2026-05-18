import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/usecase/delete_fcm_token_usecase.dart';
import '../../features/auth/domain/usecase/update_fcm_token_usecase.dart';
import '../../features/message_groups/domain/entities/message_group.dart';
import '../config/app_router.dart';
import '../config/app_routes.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class PushNotificationService {
  PushNotificationService({
    required FirebaseMessaging messaging,
    required FlutterLocalNotificationsPlugin localNotifications,
    required UpdateFcmTokenUseCase updateFcmTokenUseCase,
    required DeleteFcmTokenUseCase deleteFcmTokenUseCase,
  }) : _messaging = messaging,
       _localNotifications = localNotifications,
       _updateFcmTokenUseCase = updateFcmTokenUseCase,
       _deleteFcmTokenUseCase = deleteFcmTokenUseCase;

  static const String messageNewType = 'MESSAGE_NEW';
  static const String notificationType = 'NOTIFICATION';
  static const String postReactionNotificationType = 'PostReaction';
  static const String _androidChannelId = 'beacon_messages';
  static const String _androidChannelName = 'Messages';
  static const String _androidChannelDescription =
      'Notifications for new chat messages';

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final UpdateFcmTokenUseCase _updateFcmTokenUseCase;
  final DeleteFcmTokenUseCase _deleteFcmTokenUseCase;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  String? _pendingPostReactionPostId;
  bool _initialized = false;

  bool get _isSupported {
    return !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  Future<void> initialize() async {
    if (_initialized || !_isSupported) {
      return;
    }
    _initialized = true;

    await _initializeLocalNotifications();

    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );
    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      _sendTokenToBackend,
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _scheduleNotificationNavigation(initialMessage);
    }
  }

  Future<void> requestNotificationPermission() async {
    if (!_isSupported) {
      return;
    }

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> registerCurrentDeviceToken() async {
    if (!_isSupported) {
      return;
    }

    await requestNotificationPermission();
    await _registerCurrentDeviceTokenWithoutPrompt();
  }

  Future<void> syncCurrentDeviceTokenIfAuthorized() async {
    if (!_isSupported) {
      return;
    }

    final settings = await _messaging.getNotificationSettings();
    final status = settings.authorizationStatus;
    if (status != AuthorizationStatus.authorized &&
        status != AuthorizationStatus.provisional) {
      return;
    }

    await _registerCurrentDeviceTokenWithoutPrompt();
  }

  Future<void> _registerCurrentDeviceTokenWithoutPrompt() async {
    final token = await _messaging.getToken();
    if (token == null || token.trim().isEmpty) {
      return;
    }

    await _sendTokenToBackend(token);
  }

  Future<void> deleteCurrentDeviceToken() async {
    if (!_isSupported) {
      return;
    }

    final token = await _messaging.getToken();
    if (token == null || token.trim().isEmpty) {
      return;
    }

    await _deleteFcmTokenUseCase(token: token);
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _foregroundSubscription = null;
    _openedAppSubscription = null;
    _initialized = false;
  }

  Future<void> _initializeLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    const channel = AndroidNotificationChannel(
      _androidChannelId,
      _androidChannelName,
      description: _androidChannelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(channel);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (!_canShowForegroundNotification(message.data)) {
      return;
    }

    final notification = message.notification;
    final title = notification?.title?.trim().isNotEmpty == true
        ? notification!.title!
        : _fallbackNotificationTitle(message.data);
    final body = _localNotificationBody(message);
    final payload = jsonEncode(message.data);

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          channelDescription: _androidChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void _handleLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.trim().isEmpty) {
      return;
    }

    final decoded = jsonDecode(payload);
    if (decoded is Map<String, dynamic>) {
      _navigateFromData(decoded);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    _navigateFromData(message.data);
  }

  void _scheduleNotificationNavigation(RemoteMessage message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(
        const Duration(milliseconds: 500),
        () => _handleNotificationTap(message),
      );
    });
  }

  void _navigateFromData(Map<String, dynamic> data) {
    if (_isPostReactionNotification(data)) {
      final payload = _parsePostReactionPayload(data);
      final postId = payload?.postId.trim();
      if (postId == null || postId.isEmpty) {
        return;
      }

      _pendingPostReactionPostId = postId;
      _openHomeForPostReaction(postId);
      return;
    }

    if (data['type'] != messageNewType) {
      return;
    }

    final groupId = data['messageGroupId']?.toString().trim();
    if (groupId == null || groupId.isEmpty) {
      return;
    }

    final group = MessageGroup(
      groupId: groupId,
      isPrivate: true,
      createdAtUtc: null,
      lastMessageId: data['messageId']?.toString(),
      lastMessageContent: null,
      lastMessageAtUtc: null,
      lastMessageSenderFamilyName: null,
      lastMessageSenderGivenName: null,
      lastSeenMessageId: null,
      isSeenLatest: false,
      unreadCount: 1,
      displayName: null,
      displayAvatarUrl: null,
      peerUserId: data['peerUserId']?.toString(),
    );

    try {
      appRouter.pushNamed(AppRoutes.chatDetailName, extra: group);
    } on GoException {
      appRouter.goNamed(AppRoutes.messageListName);
    }
  }

  String? consumePendingPostReactionPostId() {
    final postId = _pendingPostReactionPostId;
    _pendingPostReactionPostId = null;
    return postId;
  }

  bool _canShowForegroundNotification(Map<String, dynamic> data) {
    return data['type'] == messageNewType || _isPostReactionNotification(data);
  }

  bool _isPostReactionNotification(Map<String, dynamic> data) {
    return data['type'] == notificationType &&
        data['notificationType'] == postReactionNotificationType;
  }

  _PostReactionNotificationPayload? _parsePostReactionPayload(
    Map<String, dynamic> data,
  ) {
    final rawPayload = data['data'];
    if (rawPayload is! String || rawPayload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawPayload);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return _PostReactionNotificationPayload.fromJson(decoded);
    } on FormatException {
      return null;
    }
  }

  String _fallbackNotificationTitle(Map<String, dynamic> data) {
    if (_isPostReactionNotification(data)) {
      return 'Co nguoi vua react bai dang';
    }

    return 'Tin nhan moi';
  }

  String _localNotificationBody(RemoteMessage message) {
    final body = message.notification?.body ?? '';
    final payload = _parsePostReactionPayload(message.data);
    final reactionIcon = payload?.reactionIcon.trim();
    if (reactionIcon == null || reactionIcon.isEmpty) {
      return body;
    }

    if (body.trim().isEmpty) {
      return reactionIcon;
    }

    return '$reactionIcon $body';
  }

  void _openHomeForPostReaction(String postId) {
    final extra = <String, dynamic>{'targetPostId': postId};
    try {
      appRouter.goNamed(AppRoutes.homeName, extra: extra);
    } on GoException {
      appRouter.go(AppRoutes.home, extra: extra);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    final trimmedToken = token.trim();
    if (trimmedToken.isEmpty) {
      return;
    }

    await _updateFcmTokenUseCase(
      token: trimmedToken,
      platform: _currentPlatform,
    );
  }

  String get _currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return defaultTargetPlatform.name;
    }
  }
}

class _PostReactionNotificationPayload {
  const _PostReactionNotificationPayload({
    required this.postId,
    required this.reactionIcon,
    required this.reactorUserId,
    required this.reactorDisplayName,
    required this.reactorAvatarUrl,
  });

  final String postId;
  final String reactionIcon;
  final String reactorUserId;
  final String reactorDisplayName;
  final String reactorAvatarUrl;

  factory _PostReactionNotificationPayload.fromJson(Map<String, dynamic> json) {
    return _PostReactionNotificationPayload(
      postId: json['postId']?.toString() ?? '',
      reactionIcon: json['reactionIcon']?.toString() ?? '',
      reactorUserId: json['reactorUserId']?.toString() ?? '',
      reactorDisplayName: json['reactorDisplayName']?.toString() ?? '',
      reactorAvatarUrl: json['reactorAvatarUrl']?.toString() ?? '',
    );
  }
}
