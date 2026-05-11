import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/usecase/get_group_messages_usecase.dart';
import '../../domain/usecase/get_message_group_detail_usecase.dart';
import '../../domain/usecase/join_message_group_realtime_usecase.dart';
import '../../domain/usecase/leave_message_group_realtime_usecase.dart';
import '../../domain/usecase/mark_message_group_seen_usecase.dart';
import '../../domain/usecase/send_group_message_usecase.dart';
import '../../domain/usecase/send_typing_status_realtime_usecase.dart';
import '../../domain/usecase/subscribe_typing_status_realtime_usecase.dart';
import 'group_chat_detail_state.dart';

class GroupChatDetailNotifier extends StateNotifier<GroupChatDetailState> {
  final String groupId;
  final GetGroupMessagesUseCase _getGroupMessagesUseCase;
  final GetMessageGroupDetailUseCase _getMessageGroupDetailUseCase;
  final SendGroupMessageUseCase _sendGroupMessageUseCase;
  final MarkMessageGroupSeenUseCase _markMessageGroupSeenUseCase;
  final AppMessageNotifier _messageNotifier;
  final JoinMessageGroupRealtimeUseCase _joinMessageGroupRealtimeUseCase;
  final LeaveMessageGroupRealtimeUseCase _leaveMessageGroupRealtimeUseCase;
  final SendTypingStatusRealtimeUseCase _sendTypingStatusRealtimeUseCase;
  final SubscribeTypingStatusRealtimeUseCase
  _subscribeTypingStatusRealtimeUseCase;
  final String? _currentUserId;
  String? _lastSeenMessageId;
  bool _markingSeen = false;
  void Function(String groupId)? _unsubscribeTypingStatus;

  GroupChatDetailNotifier({
    required this.groupId,
    required GetGroupMessagesUseCase getGroupMessagesUseCase,
    required GetMessageGroupDetailUseCase getMessageGroupDetailUseCase,
    required SendGroupMessageUseCase sendGroupMessageUseCase,
    required MarkMessageGroupSeenUseCase markMessageGroupSeenUseCase,
    required AppMessageNotifier messageNotifier,
    required JoinMessageGroupRealtimeUseCase joinMessageGroupRealtimeUseCase,
    required LeaveMessageGroupRealtimeUseCase leaveMessageGroupRealtimeUseCase,
    required SendTypingStatusRealtimeUseCase sendTypingStatusRealtimeUseCase,
    required SubscribeTypingStatusRealtimeUseCase
    subscribeTypingStatusRealtimeUseCase,
    required String? currentUserId,
  }) : _getGroupMessagesUseCase = getGroupMessagesUseCase,
       _getMessageGroupDetailUseCase = getMessageGroupDetailUseCase,
       _sendGroupMessageUseCase = sendGroupMessageUseCase,
       _markMessageGroupSeenUseCase = markMessageGroupSeenUseCase,
       _messageNotifier = messageNotifier,
       _joinMessageGroupRealtimeUseCase = joinMessageGroupRealtimeUseCase,
       _leaveMessageGroupRealtimeUseCase = leaveMessageGroupRealtimeUseCase,
       _sendTypingStatusRealtimeUseCase = sendTypingStatusRealtimeUseCase,
       _subscribeTypingStatusRealtimeUseCase =
           subscribeTypingStatusRealtimeUseCase,
       _currentUserId = currentUserId,
       super(const GroupChatDetailState());

  Future<void> load() async {
    state = state.copyWith(status: GroupChatDetailStatus.loading);

    final detailResult = await _getMessageGroupDetailUseCase.call(
      groupId: groupId,
    );
    detailResult.fold((_) {}, (detail) {
      for (final member in detail.members) {
        if (member.userId == _currentUserId) {
          _lastSeenMessageId = member.lastSeenMessageId;
          break;
        }
      }
      state = state.copyWith(groupDetail: detail);
    });

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
    await _subscribeTypingStatusRealtimeUseCase.call(
      groupId: groupId,
      onTypingStatus: _onTypingStatus,
    );
    _unsubscribeTypingStatus = _subscribeTypingStatusRealtimeUseCase
        .unsubscribe();

    await _joinMessageGroupRealtimeUseCase.call(
      groupId: groupId,
      onMessage: (message) {
        final nextMessages = _upsertSorted(state.messages, message);
        state = state.copyWith(
          messages: nextMessages,
          status: GroupChatDetailStatus.loaded,
        );
        unawaited(_markLatestSeenIfNeeded());
      },
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
    _unsubscribeTypingStatus?.call(groupId);
    _unsubscribeTypingStatus = null;
    unawaited(_leaveMessageGroupRealtimeUseCase.call(groupId));
    super.dispose();
  }
}
