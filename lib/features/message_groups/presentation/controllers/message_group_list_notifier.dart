import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/usecase/get_message_group_detail_usecase.dart';
import '../../domain/usecase/get_message_groups_usecase.dart';
import 'message_group_list_state.dart';

class MessageGroupListNotifier extends StateNotifier<MessageGroupListState> {
  final GetMessageGroupsUseCase _getMessageGroupsUseCase;
  final GetMessageGroupDetailUseCase _getMessageGroupDetailUseCase;
  final AppMessageNotifier _messageNotifier;
  final String? _currentUserId;

  MessageGroupListNotifier(
    this._getMessageGroupsUseCase,
    this._getMessageGroupDetailUseCase,
    this._messageNotifier,
    this._currentUserId,
  )
    : super(const MessageGroupListState());

  Future<void> load() async {
    state = state.copyWith(status: MessageGroupListStatus.loading);
    await _loadInternal(showErrorBanner: true);
  }

  Future<void> refreshSilently() async {
    await _loadInternal(showErrorBanner: false);
  }

  void applyIncomingMessage(
    GroupMessage message, {
    required bool isFromCurrentUser,
  }) {
    final groups = List<MessageGroup>.from(state.groups);
    final index = groups.indexWhere((g) => g.groupId == message.groupId);
    if (index < 0) {
      return;
    }

    final current = groups.removeAt(index);
    final updated = MessageGroup(
      groupId: current.groupId,
      isPrivate: current.isPrivate,
      createdAtUtc: current.createdAtUtc,
      lastMessageId: message.id,
      lastMessageContent: message.content,
      lastMessageAtUtc: message.createdAtUtc,
      lastMessageSenderFamilyName: message.senderFamilyName,
      lastMessageSenderGivenName: message.senderGivenName,
      lastSeenMessageId: isFromCurrentUser
          ? message.id
          : current.lastSeenMessageId,
      isSeenLatest: isFromCurrentUser,
      unreadCount: isFromCurrentUser ? 0 : current.unreadCount + 1,
      displayName: current.displayName,
      displayAvatarUrl: current.displayAvatarUrl,
    );
    groups.insert(0, updated);
    state = state.copyWith(
      status: MessageGroupListStatus.loaded,
      groups: groups,
    );
  }

  void applyMessageGroupSeen({
    required String groupId,
    required String lastSeenMessageId,
  }) {
    final groups = List<MessageGroup>.from(state.groups);
    final index = groups.indexWhere((g) => g.groupId == groupId);
    if (index < 0) {
      return;
    }

    final current = groups[index];
    final isSeenLatest = current.lastMessageId == null ||
      current.lastMessageId == lastSeenMessageId;

    groups[index] = MessageGroup(
      groupId: current.groupId,
      isPrivate: current.isPrivate,
      createdAtUtc: current.createdAtUtc,
      lastMessageId: current.lastMessageId,
      lastMessageContent: current.lastMessageContent,
      lastMessageAtUtc: current.lastMessageAtUtc,
      lastMessageSenderFamilyName: current.lastMessageSenderFamilyName,
      lastMessageSenderGivenName: current.lastMessageSenderGivenName,
      lastSeenMessageId: lastSeenMessageId,
      isSeenLatest: isSeenLatest,
      unreadCount: isSeenLatest ? 0 : current.unreadCount,
      displayName: current.displayName,
      displayAvatarUrl: current.displayAvatarUrl,
    );

    state = state.copyWith(
      status: MessageGroupListStatus.loaded,
      groups: groups,
    );
  }

  Future<void> _loadInternal({required bool showErrorBanner}) async {
    final result = await _getMessageGroupsUseCase.call(limit: 20);
    result.fold(
      (failure) {
        if (showErrorBanner) {
          _messageNotifier.addError(failure.message);
          state = state.copyWith(
            status: MessageGroupListStatus.error,
            errorMessage: failure.message,
          );
        }
      },
      (page) {
        final sorted = List<MessageGroup>.from(page.items)
          ..sort((a, b) {
            final aTime =
                a.lastMessageAtUtc ?? a.createdAtUtc ?? DateTime(1970);
            final bTime =
                b.lastMessageAtUtc ?? b.createdAtUtc ?? DateTime(1970);
            return bTime.compareTo(aTime);
          });

        state = state.copyWith(
          status: MessageGroupListStatus.loaded,
          groups: sorted,
          errorMessage: null,
        );
        unawaited(_loadPrivatePeerIds(sorted));
      },
    );
  }

  Future<void> _loadPrivatePeerIds(List<MessageGroup> groups) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null || currentUserId.isEmpty) {
      return;
    }

    final next = Map<String, String>.from(state.peerUserIdByGroupId);
    for (final group in groups.where((group) => group.isPrivate)) {
      if (next.containsKey(group.groupId)) {
        continue;
      }

      final result = await _getMessageGroupDetailUseCase.call(
        groupId: group.groupId,
      );
      result.fold((_) {}, (detail) {
        for (final member in detail.members) {
          if (member.userId != currentUserId) {
            next[group.groupId] = member.userId;
            break;
          }
        }
      });
    }

    if (next.length != state.peerUserIdByGroupId.length) {
      state = state.copyWith(peerUserIdByGroupId: next);
    }
  }
}
