import '../../domain/entities/message_group.dart';

enum MessageGroupListStatus { initial, loading, loaded, error }

class MessageGroupListState {
  final MessageGroupListStatus status;
  final List<MessageGroup> groups;
  final Map<String, String> peerUserIdByGroupId;
  final String? errorMessage;

  const MessageGroupListState({
    this.status = MessageGroupListStatus.initial,
    this.groups = const [],
    this.peerUserIdByGroupId = const {},
    this.errorMessage,
  });

  MessageGroupListState copyWith({
    MessageGroupListStatus? status,
    List<MessageGroup>? groups,
    Map<String, String>? peerUserIdByGroupId,
    String? errorMessage,
  }) {
    return MessageGroupListState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      peerUserIdByGroupId: peerUserIdByGroupId ?? this.peerUserIdByGroupId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
