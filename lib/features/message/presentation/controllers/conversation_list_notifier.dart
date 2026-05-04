import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/message_mock_data.dart';
import '../../domain/entities/conversation.dart';
import 'conversation_list_state.dart';

class ConversationListNotifier extends StateNotifier<ConversationListState> {
  ConversationListNotifier() : super(const ConversationListState());

  /// Loads mock conversations (simulates network delay).
  Future<void> load() async {
    state = state.copyWith(status: ConversationListStatus.loading);

    // Simulate a short network delay
    await Future.delayed(const Duration(milliseconds: 400));

    state = state.copyWith(
      status: ConversationListStatus.loaded,
      conversations: MessageMockData.conversations,
    );
  }

  /// Updates the last message and bumps a conversation to the top.
  void updateConversation(Conversation updated) {
    final list = List<Conversation>.from(state.conversations);
    final idx = list.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      list.removeAt(idx);
    }
    list.insert(0, updated);
    state = state.copyWith(conversations: list);
  }
}
