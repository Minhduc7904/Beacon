import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/usecase/get_message_groups_usecase.dart';
import 'message_group_list_state.dart';

class MessageGroupListNotifier extends StateNotifier<MessageGroupListState> {
  final GetMessageGroupsUseCase _getMessageGroupsUseCase;
  final AppMessageNotifier _messageNotifier;

  MessageGroupListNotifier(this._getMessageGroupsUseCase, this._messageNotifier)
    : super(const MessageGroupListState());

  Future<void> load({bool forceRefresh = false}) async {
    if (!forceRefresh && state.status == MessageGroupListStatus.loaded) {
      return;
    }

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

    if (message.type == GroupMessageType.groupDeleted) {
      groups.removeAt(index);
      state = state.copyWith(
        status: MessageGroupListStatus.loaded,
        groups: groups,
      );
      return;
    }

    final current = groups.removeAt(index);
    final metadata = _metadataMap(message);
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
      displayName: _displayNameFor(message, metadata, current.displayName),
      displayAvatarUrl: _displayAvatarUrlFor(
        message,
        metadata,
        current.displayAvatarUrl,
      ),
      peerUserId: current.peerUserId,
      requireApprovalToAddMembers: current.requireApprovalToAddMembers,
    );
    groups.insert(0, updated);
    state = state.copyWith(
      status: MessageGroupListStatus.loaded,
      groups: groups,
    );
  }

  String? _displayNameFor(
    GroupMessage message,
    Map<String, dynamic>? metadata,
    String? currentDisplayName,
  ) {
    if (message.type != GroupMessageType.groupNameChanged) {
      return currentDisplayName;
    }

    return _nullableStringValue(metadata?['name']) ?? currentDisplayName;
  }

  String? _displayAvatarUrlFor(
    GroupMessage message,
    Map<String, dynamic>? metadata,
    String? currentDisplayAvatarUrl,
  ) {
    if (message.type != GroupMessageType.groupAvatarChanged) {
      return currentDisplayAvatarUrl;
    }

    return _nullableStringValue(metadata?['avatarUrl']) ??
        currentDisplayAvatarUrl;
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

  String? _nullableStringValue(dynamic value) {
    if (value == null) {
      return null;
    }
    final raw = value.toString().trim();
    return raw.isEmpty ? null : raw;
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
    final isSeenLatest =
        current.lastMessageId == null ||
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
      peerUserId: current.peerUserId,
      requireApprovalToAddMembers: current.requireApprovalToAddMembers,
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
      },
    );
  }
}
