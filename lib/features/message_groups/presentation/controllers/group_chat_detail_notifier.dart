import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_member.dart';
import '../../domain/usecase/get_group_messages_usecase.dart';
import '../../domain/usecase/join_message_group_realtime_usecase.dart';
import '../../domain/usecase/leave_message_group_realtime_usecase.dart';
import '../../domain/usecase/mark_message_group_seen_usecase.dart';
import '../../domain/usecase/send_group_message_usecase.dart';
import '../../domain/usecase/send_typing_status_realtime_usecase.dart';
import '../../domain/usecase/subscribe_message_seen_status_realtime_usecase.dart';
import '../../domain/usecase/subscribe_typing_status_realtime_usecase.dart';
import 'group_chat_detail_state.dart';

class GroupChatDetailNotifier extends StateNotifier<GroupChatDetailState> {
  final String groupId;
  final GetGroupMessagesUseCase _getGroupMessagesUseCase;
  final SendGroupMessageUseCase _sendGroupMessageUseCase;
  final MarkMessageGroupSeenUseCase _markMessageGroupSeenUseCase;
  final AppMessageNotifier _messageNotifier;
  final JoinMessageGroupRealtimeUseCase _joinMessageGroupRealtimeUseCase;
  final LeaveMessageGroupRealtimeUseCase _leaveMessageGroupRealtimeUseCase;
  final SendTypingStatusRealtimeUseCase _sendTypingStatusRealtimeUseCase;
  final SubscribeMessageSeenStatusRealtimeUseCase
  _subscribeMessageSeenStatusRealtimeUseCase;
  final SubscribeTypingStatusRealtimeUseCase
  _subscribeTypingStatusRealtimeUseCase;
  final String? _currentUserId;
  String? _lastSeenMessageId;
  bool _markingSeen = false;
  void Function(String groupId)? _unsubscribeTypingStatus;
  void Function(String groupId)? _unsubscribeMessageSeenStatus;

  GroupChatDetailNotifier({
    required this.groupId,
    required GetGroupMessagesUseCase getGroupMessagesUseCase,
    required SendGroupMessageUseCase sendGroupMessageUseCase,
    required MarkMessageGroupSeenUseCase markMessageGroupSeenUseCase,
    required AppMessageNotifier messageNotifier,
    required JoinMessageGroupRealtimeUseCase joinMessageGroupRealtimeUseCase,
    required LeaveMessageGroupRealtimeUseCase leaveMessageGroupRealtimeUseCase,
    required SendTypingStatusRealtimeUseCase sendTypingStatusRealtimeUseCase,
    required SubscribeMessageSeenStatusRealtimeUseCase
    subscribeMessageSeenStatusRealtimeUseCase,
    required SubscribeTypingStatusRealtimeUseCase
    subscribeTypingStatusRealtimeUseCase,
    required String? currentUserId,
  }) : _getGroupMessagesUseCase = getGroupMessagesUseCase,
       _sendGroupMessageUseCase = sendGroupMessageUseCase,
       _markMessageGroupSeenUseCase = markMessageGroupSeenUseCase,
       _messageNotifier = messageNotifier,
       _joinMessageGroupRealtimeUseCase = joinMessageGroupRealtimeUseCase,
       _leaveMessageGroupRealtimeUseCase = leaveMessageGroupRealtimeUseCase,
       _sendTypingStatusRealtimeUseCase = sendTypingStatusRealtimeUseCase,
       _subscribeMessageSeenStatusRealtimeUseCase =
           subscribeMessageSeenStatusRealtimeUseCase,
       _subscribeTypingStatusRealtimeUseCase =
           subscribeTypingStatusRealtimeUseCase,
       _currentUserId = currentUserId,
       super(const GroupChatDetailState());

  Future<void> load({MessageGroupDetail? initialDetail}) async {
    state = state.copyWith(status: GroupChatDetailStatus.loading);

    if (initialDetail != null) {
      setGroupDetail(initialDetail);
    }

    final result = await _getGroupMessagesUseCase.call(
      groupId: groupId,
      limit: 40,
    );

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          status: GroupChatDetailStatus.error,
          errorMessage: failure.message,
        );
      },
      (page) {
        final sorted = List<GroupMessage>.from(page.items)
          ..sort((a, b) {
            final aTime = a.createdAtUtc ?? DateTime(1970);
            final bTime = b.createdAtUtc ?? DateTime(1970);
            return aTime.compareTo(bTime);
          });

        state = state.copyWith(
          status: GroupChatDetailStatus.loaded,
          messages: sorted,
          errorMessage: null,
        );
      },
    );

    await _markLatestSeenIfNeeded();
    await _bindRealtime();
  }

  void setGroupDetail(MessageGroupDetail detail) {
    for (final member in detail.members) {
      if (member.userId == _currentUserId) {
        _lastSeenMessageId = member.lastSeenMessageId;
        break;
      }
    }
    state = state.copyWith(groupDetail: detail);
  }

  Future<void> sendMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.isSending) {
      return;
    }

    state = state.copyWith(isSending: true);

    final result = await _sendGroupMessageUseCase.call(
      groupId: groupId,
      content: trimmed,
    );

    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(isSending: false, errorMessage: failure.message);
      },
      (sentMessage) {
        unawaited(sendTypingStatus(false));
        final nextMessages = _upsertSorted(state.messages, sentMessage);
        state = state.copyWith(
          messages: nextMessages,
          isSending: false,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> sendTypingStatus(bool isTyping) async {
    try {
      await _sendTypingStatusRealtimeUseCase.call(
        groupId: groupId,
        isTyping: isTyping,
      );
    } catch (_) {}
  }

  Future<void> _bindRealtime() async {
    await _subscribeMessageSeenStatusRealtimeUseCase.call(
      groupId: groupId,
      onSeenStatus: _onSeenStatus,
    );
    _unsubscribeMessageSeenStatus = _subscribeMessageSeenStatusRealtimeUseCase
        .unsubscribe();

    await _subscribeTypingStatusRealtimeUseCase.call(
      groupId: groupId,
      onTypingStatus: _onTypingStatus,
    );
    _unsubscribeTypingStatus = _subscribeTypingStatusRealtimeUseCase
        .unsubscribe();

    await _joinMessageGroupRealtimeUseCase.call(
      groupId: groupId,
      onMessage: _handleRealtimeMessage,
    );
  }

  void _handleRealtimeMessage(GroupMessage message) {
    _applyRealtimeMessageMetadata(message);

    final nextMessages = _upsertSorted(state.messages, message);
    state = state.copyWith(
      messages: nextMessages,
      status: GroupChatDetailStatus.loaded,
    );
    unawaited(_markLatestSeenIfNeeded());
  }

  void _applyRealtimeMessageMetadata(GroupMessage message) {
    final detail = state.groupDetail;
    if (detail == null || !message.isSystemMessage) {
      return;
    }

    final metadata = _metadataMap(message);
    if (metadata == null && message.type != GroupMessageType.groupDeleted) {
      return;
    }

    switch (message.type) {
      case GroupMessageType.roleChanged:
        _updateMemberRole(
          userId: _stringValue(metadata?['userId']),
          role: _intValue(metadata?['role']),
        );
      case GroupMessageType.memberAdded:
        _upsertMembers(_membersValue(metadata?['members']));
      case GroupMessageType.memberLeft:
        removeMember(_stringValue(metadata?['userId']) ?? '');
      case GroupMessageType.memberNicknameChanged:
        _updateMemberCustomName(
          userId: _stringValue(metadata?['userId']),
          customName: _nullableStringValue(metadata?['customName']),
        );
      case GroupMessageType.groupAvatarChanged:
        _updateGroupDetail(
          displayAvatarUrl: _nullableStringValue(metadata?['avatarUrl']),
        );
      case GroupMessageType.groupDeleted:
        _messageNotifier.addInfo('Nhóm chat đã bị xóa');
      case GroupMessageType.memberApproved:
        _upsertMember(_memberValue(metadata?['member']));
      case GroupMessageType.memberDenied:
        removeMember(_stringValue(metadata?['userId']) ?? '');
      case GroupMessageType.groupNameChanged:
        _updateGroupDetail(
          displayName: _nullableStringValue(metadata?['name']),
        );
      case GroupMessageType.normal:
      case GroupMessageType.nicknameChanged:
      case GroupMessageType.groupApprovalSettingChanged:
        return;
    }
  }

  void _onSeenStatus(
    String? seenByUserId,
    String lastSeenMessageId,
    DateTime? seenAtUtc,
  ) {
    final detail = state.groupDetail;
    if (detail == null) {
      return;
    }

    final members = List.of(detail.members);
    if (members.isEmpty) {
      return;
    }

    var targetIndex = -1;
    if (seenByUserId != null && seenByUserId.trim().isNotEmpty) {
      targetIndex = members.indexWhere((m) => m.userId == seenByUserId);
    } else {
      // Fallback: in 1-1 chats we can infer the peer.
      if (members.length == 2) {
        targetIndex = members.indexWhere((m) => m.userId != _currentUserId);
      }
    }

    if (targetIndex < 0) {
      return;
    }

    final target = members[targetIndex];
    members[targetIndex] = MessageGroupMember(
      userId: target.userId,
      familyName: target.familyName,
      givenName: target.givenName,
      customName: target.customName,
      avatarUrl: target.avatarUrl,
      role: target.role,
      status: target.status,
      lastSeenMessageId: lastSeenMessageId,
      lastSeenAtUtc: seenAtUtc ?? DateTime.now().toUtc(),
    );

    _updateMembers(detail, members);
  }

  void updateMemberStatus({
    required String userId,
    required MessageGroupMemberStatus status,
  }) {
    final detail = state.groupDetail;
    if (detail == null) {
      return;
    }

    final members = List<MessageGroupMember>.from(detail.members);
    final targetIndex = members.indexWhere((member) => member.userId == userId);
    if (targetIndex < 0) {
      return;
    }

    final target = members[targetIndex];
    members[targetIndex] = MessageGroupMember(
      userId: target.userId,
      familyName: target.familyName,
      givenName: target.givenName,
      customName: target.customName,
      avatarUrl: target.avatarUrl,
      role: target.role,
      status: status,
      lastSeenMessageId: target.lastSeenMessageId,
      lastSeenAtUtc: target.lastSeenAtUtc,
    );

    _updateMembers(detail, members);
  }

  void _updateMemberRole({required String? userId, required int? role}) {
    if (userId == null || userId.trim().isEmpty || role == null) {
      return;
    }

    final detail = state.groupDetail;
    if (detail == null) {
      return;
    }

    final members = List<MessageGroupMember>.from(detail.members);
    final targetIndex = members.indexWhere((member) => member.userId == userId);
    if (targetIndex < 0) {
      return;
    }

    final target = members[targetIndex];
    members[targetIndex] = MessageGroupMember(
      userId: target.userId,
      familyName: target.familyName,
      givenName: target.givenName,
      customName: target.customName,
      avatarUrl: target.avatarUrl,
      role: role,
      status: target.status,
      lastSeenMessageId: target.lastSeenMessageId,
      lastSeenAtUtc: target.lastSeenAtUtc,
    );

    _updateMembers(detail, members);
  }

  void _updateMemberCustomName({
    required String? userId,
    required String? customName,
  }) {
    if (userId == null || userId.trim().isEmpty) {
      return;
    }

    final detail = state.groupDetail;
    if (detail == null) {
      return;
    }

    final members = List<MessageGroupMember>.from(detail.members);
    final targetIndex = members.indexWhere((member) => member.userId == userId);
    if (targetIndex < 0) {
      return;
    }

    final target = members[targetIndex];
    members[targetIndex] = MessageGroupMember(
      userId: target.userId,
      familyName: target.familyName,
      givenName: target.givenName,
      customName: customName,
      avatarUrl: target.avatarUrl,
      role: target.role,
      status: target.status,
      lastSeenMessageId: target.lastSeenMessageId,
      lastSeenAtUtc: target.lastSeenAtUtc,
    );

    _updateMembers(detail, members);
  }

  void removeMember(String userId) {
    final detail = state.groupDetail;
    if (detail == null) {
      return;
    }

    final members = detail.members
        .where((member) => member.userId != userId)
        .toList(growable: false);
    _updateMembers(detail, members);
  }

  void _updateMembers(
    MessageGroupDetail detail,
    List<MessageGroupMember> members,
  ) {
    state = state.copyWith(
      groupDetail: MessageGroupDetail(
        groupId: detail.groupId,
        isPrivate: detail.isPrivate,
        createdAtUtc: detail.createdAtUtc,
        displayName: detail.displayName,
        displayAvatarUrl: detail.displayAvatarUrl,
        members: members,
        requireApprovalToAddMembers: detail.requireApprovalToAddMembers,
        isMuted: detail.isMuted,
      ),
    );
  }

  void _upsertMembers(List<MessageGroupMember> incomingMembers) {
    for (final member in incomingMembers) {
      _upsertMember(member);
    }
  }

  void _upsertMember(MessageGroupMember? incomingMember) {
    if (incomingMember == null || incomingMember.userId.trim().isEmpty) {
      return;
    }

    final detail = state.groupDetail;
    if (detail == null) {
      return;
    }

    final members = List<MessageGroupMember>.from(detail.members);
    final existingIndex = members.indexWhere(
      (member) => member.userId == incomingMember.userId,
    );
    if (existingIndex >= 0) {
      members[existingIndex] = incomingMember;
    } else {
      members.add(incomingMember);
    }

    _updateMembers(detail, members);
  }

  void _updateGroupDetail({String? displayName, String? displayAvatarUrl}) {
    final detail = state.groupDetail;
    if (detail == null) {
      return;
    }

    state = state.copyWith(
      groupDetail: MessageGroupDetail(
        groupId: detail.groupId,
        isPrivate: detail.isPrivate,
        createdAtUtc: detail.createdAtUtc,
        displayName: displayName ?? detail.displayName,
        displayAvatarUrl: displayAvatarUrl ?? detail.displayAvatarUrl,
        members: detail.members,
        requireApprovalToAddMembers: detail.requireApprovalToAddMembers,
        isMuted: detail.isMuted,
      ),
    );
  }

  void _onTypingStatus(String typingUserId, bool isTyping) {
    final currentUserId = _currentUserId;
    if (typingUserId == currentUserId) {
      return;
    }

    final nextTypingUserIds = List<String>.from(state.typingUserIds);
    final existingIndex = nextTypingUserIds.indexOf(typingUserId);
    if (isTyping) {
      if (existingIndex < 0) {
        nextTypingUserIds.add(typingUserId);
      }
    } else if (existingIndex >= 0) {
      nextTypingUserIds.removeAt(existingIndex);
    }

    state = state.copyWith(typingUserIds: nextTypingUserIds);
  }

  Future<void> _markLatestSeenIfNeeded() async {
    if (_markingSeen) {
      return;
    }
    final currentUserId = _currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      return;
    }
    if (state.messages.isEmpty) {
      return;
    }

    final latest = state.messages.last;
    if (latest.senderId == currentUserId) {
      return;
    }
    if (_lastSeenMessageId == latest.id) {
      return;
    }

    _markingSeen = true;
    final result = await _markMessageGroupSeenUseCase.call(
      groupId: groupId,
      lastSeenMessageId: latest.id,
    );
    result.fold((_) {}, (_) {
      _lastSeenMessageId = latest.id;
    });
    _markingSeen = false;
  }

  Map<String, dynamic>? _metadataMap(GroupMessage message) {
    final raw = message.metadataJson?.trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (_) {}

    return null;
  }

  List<MessageGroupMember> _membersValue(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map(_memberValue)
        .whereType<MessageGroupMember>()
        .toList(growable: false);
  }

  MessageGroupMember? _memberValue(dynamic value) {
    if (value is! Map) {
      return null;
    }

    final json = value.map((key, item) => MapEntry(key.toString(), item));
    final userId = _stringValue(json['userId']);
    if (userId == null || userId.trim().isEmpty) {
      return null;
    }

    return MessageGroupMember(
      userId: userId,
      familyName: _nullableStringValue(json['familyName']),
      givenName: _nullableStringValue(json['givenName'] ?? json['username']),
      customName: _nullableStringValue(json['customName']),
      avatarUrl: _nullableStringValue(json['avatarUrl']),
      role: _intValue(json['role']) ?? 0,
      status: MessageGroupMemberStatus.fromInt(_intValue(json['status']) ?? 0),
      lastSeenMessageId: _nullableStringValue(json['lastSeenMessageId']),
      lastSeenAtUtc: _dateTimeValue(
        json['lastSeenAtUtc'] ??
            json['lastSeenAt'] ??
            json['seenAtUtc'] ??
            json['seenAt'],
      ),
    );
  }

  String? _stringValue(dynamic value) {
    final raw = value?.toString().trim();
    return raw == null || raw.isEmpty ? null : raw;
  }

  String? _nullableStringValue(dynamic value) {
    if (value == null) {
      return null;
    }
    final raw = value.toString().trim();
    return raw.isEmpty ? null : raw;
  }

  int? _intValue(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '');
  }

  DateTime? _dateTimeValue(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return null;
    }

    final hasTimezoneSuffix =
        raw.endsWith('Z') ||
        raw.contains('+') ||
        (raw.length > 10 && raw.substring(10).contains('-'));
    if (hasTimezoneSuffix) {
      return parsed.toUtc();
    }

    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }

  List<GroupMessage> _upsertSorted(
    List<GroupMessage> current,
    GroupMessage incoming,
  ) {
    final next = List<GroupMessage>.from(current);
    final existingIndex = next.indexWhere((m) => m.id == incoming.id);
    if (existingIndex >= 0) {
      next[existingIndex] = incoming;
    } else {
      next.add(incoming);
    }

    next.sort((a, b) {
      final aTime = a.createdAtUtc ?? DateTime(1970);
      final bTime = b.createdAtUtc ?? DateTime(1970);
      return aTime.compareTo(bTime);
    });
    return next;
  }

  @override
  void dispose() {
    unawaited(sendTypingStatus(false));
    _unsubscribeMessageSeenStatus?.call(groupId);
    _unsubscribeMessageSeenStatus = null;
    _unsubscribeTypingStatus?.call(groupId);
    _unsubscribeTypingStatus = null;
    unawaited(_leaveMessageGroupRealtimeUseCase.call(groupId));
    super.dispose();
  }
}
