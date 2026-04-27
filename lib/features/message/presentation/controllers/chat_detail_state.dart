import '../../domain/entities/chat_message.dart';

enum ChatDetailStatus { initial, loading, loaded, error }

class ChatDetailState {
  final ChatDetailStatus status;
  final List<ChatMessage> messages;
  final bool isSending;
  final String? errorMessage;

  const ChatDetailState({
    this.status = ChatDetailStatus.initial,
    this.messages = const [],
    this.isSending = false,
    this.errorMessage,
  });

  ChatDetailState copyWith({
    ChatDetailStatus? status,
    List<ChatMessage>? messages,
    bool? isSending,
    String? errorMessage,
  }) {
    return ChatDetailState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
