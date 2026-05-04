import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/message_mock_data.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_detail_state.dart';

int _msgId = 5000;

class ChatDetailNotifier extends StateNotifier<ChatDetailState> {
  ChatDetailNotifier({required this.conversationId})
      : super(const ChatDetailState());

  final String conversationId;

  /// Loads messages for the current conversation.
  Future<void> load() async {
    state = state.copyWith(status: ChatDetailStatus.loading);

    await Future.delayed(const Duration(milliseconds: 300));

    final messages = MessageMockData.messagesFor(conversationId);
    state = state.copyWith(
      status: ChatDetailStatus.loaded,
      messages: messages,
    );
  }

  /// Sends a user message and triggers an auto-reply after a short delay.
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: 'user_msg_${_msgId++}',
      conversationId: conversationId,
      content: content.trim(),
      sender: ChatMessageSender.me,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
    );

    // Simulate reply latency
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final reply = MessageMockData.generateAutoReply(conversationId);
    state = state.copyWith(
      messages: [...state.messages, reply],
      isSending: false,
    );
  }
}
