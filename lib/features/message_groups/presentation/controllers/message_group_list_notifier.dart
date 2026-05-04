import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/usecase/get_message_groups_usecase.dart';
import 'message_group_list_state.dart';

class MessageGroupListNotifier extends StateNotifier<MessageGroupListState> {
  final GetMessageGroupsUseCase _getMessageGroupsUseCase;
  final AppMessageNotifier _messageNotifier;

  MessageGroupListNotifier(
    this._getMessageGroupsUseCase,
    this._messageNotifier,
  ) : super(const MessageGroupListState());

  Future<void> load() async {
    state = state.copyWith(status: MessageGroupListStatus.loading);

    final result = await _getMessageGroupsUseCase.call(limit: 20);
    result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          status: MessageGroupListStatus.error,
          errorMessage: failure.message,
        );
      },
      (page) {
        final sorted = List<MessageGroup>.from(page.items)
          ..sort((a, b) {
            final aTime = a.lastMessageAtUtc ?? a.createdAtUtc ?? DateTime(1970);
            final bTime = b.lastMessageAtUtc ?? b.createdAtUtc ?? DateTime(1970);
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
