import '../../domain/entities/conversation.dart';

enum ConversationListStatus { initial, loading, loaded, error }

class ConversationListState {
  final ConversationListStatus status;
  final List<Conversation> conversations;
  final String? errorMessage;

  const ConversationListState({
    this.status = ConversationListStatus.initial,
    this.conversations = const [],
    this.errorMessage,
  });

  ConversationListState copyWith({
    ConversationListStatus? status,
    List<Conversation>? conversations,
    String? errorMessage,
  }) {
    return ConversationListState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
