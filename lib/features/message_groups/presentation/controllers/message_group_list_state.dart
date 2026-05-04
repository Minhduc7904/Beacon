import '../../domain/entities/message_group.dart';

enum MessageGroupListStatus { initial, loading, loaded, error }

class MessageGroupListState {
  final MessageGroupListStatus status;
  final List<MessageGroup> groups;
  final String? errorMessage;

  const MessageGroupListState({
    this.status = MessageGroupListStatus.initial,
    this.groups = const [],
    this.errorMessage,
  });

  MessageGroupListState copyWith({
    MessageGroupListStatus? status,
    List<MessageGroup>? groups,
    String? errorMessage,
  }) {
    return MessageGroupListState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
