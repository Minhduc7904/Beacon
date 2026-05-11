import '../../domain/entities/group_message.dart';
import '../../domain/entities/message_group_detail.dart';

enum GroupChatDetailStatus { initial, loading, loaded, error }

class GroupChatDetailState {
  final GroupChatDetailStatus status;
  final List<GroupMessage> messages;
  final List<String> typingUserIds;
  final bool isSending;
  final String? errorMessage;
  final MessageGroupDetail? groupDetail;

  const GroupChatDetailState({
    this.status = GroupChatDetailStatus.initial,
    this.messages = const [],
    this.typingUserIds = const [],
    this.isSending = false,
    this.errorMessage,
    this.groupDetail,
  });

  GroupChatDetailState copyWith({
    GroupChatDetailStatus? status,
    List<GroupMessage>? messages,
    List<String>? typingUserIds,
    bool? isSending,
    String? errorMessage,
    MessageGroupDetail? groupDetail,
  }) {
    return GroupChatDetailState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      typingUserIds: typingUserIds ?? this.typingUserIds,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage ?? this.errorMessage,
      groupDetail: groupDetail ?? this.groupDetail,
    );
  }
}
