import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/usecase/get_group_messages_usecase.dart';
import '../../domain/usecase/get_message_group_detail_usecase.dart';
import '../../domain/usecase/send_group_message_usecase.dart';
import 'group_chat_detail_state.dart';

class GroupChatDetailNotifier extends StateNotifier<GroupChatDetailState> {
  final String groupId;
  final GetGroupMessagesUseCase _getGroupMessagesUseCase;
  final GetMessageGroupDetailUseCase _getMessageGroupDetailUseCase;
  final SendGroupMessageUseCase _sendGroupMessageUseCase;
  final AppMessageNotifier _messageNotifier;

  GroupChatDetailNotifier({
    required this.groupId,
    required GetGroupMessagesUseCase getGroupMessagesUseCase,
    required GetMessageGroupDetailUseCase getMessageGroupDetailUseCase,
    required SendGroupMessageUseCase sendGroupMessageUseCase,
    required AppMessageNotifier messageNotifier,
  }) : _getGroupMessagesUseCase = getGroupMessagesUseCase,
       _getMessageGroupDetailUseCase = getMessageGroupDetailUseCase,
       _sendGroupMessageUseCase = sendGroupMessageUseCase,
       _messageNotifier = messageNotifier,
       super(const GroupChatDetailState());

  Future<void> load() async {
    state = state.copyWith(status: GroupChatDetailStatus.loading);

    final detailResult = await _getMessageGroupDetailUseCase.call(
      groupId: groupId,
    );
    detailResult.fold(
      (_) {},
      (detail) {
        state = state.copyWith(groupDetail: detail);
      },
    );

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
        final nextMessages = List<GroupMessage>.from(state.messages)
          ..add(sentMessage);
        state = state.copyWith(
          messages: nextMessages,
          isSending: false,
          errorMessage: null,
        );
      },
    );
  }
}
