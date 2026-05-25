import '../../../friends/domain/entities/friend_profile.dart';

enum CreateMessageGroupSheetStatus { initial, loading, loaded, error }

class CreateMessageGroupSheetState {
  final CreateMessageGroupSheetStatus status;
  final String search;
  final List<FriendProfile> friends;
  final Set<String> selectedUserIds;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const CreateMessageGroupSheetState({
    this.status = CreateMessageGroupSheetStatus.initial,
    this.search = '',
    this.friends = const [],
    this.selectedUserIds = const {},
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  int get selectedCount => selectedUserIds.length;

  bool isSelected(String userId) => selectedUserIds.contains(userId);

  CreateMessageGroupSheetState copyWith({
    CreateMessageGroupSheetStatus? status,
    String? search,
    List<FriendProfile>? friends,
    Set<String>? selectedUserIds,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CreateMessageGroupSheetState(
      status: status ?? this.status,
      search: search ?? this.search,
      friends: friends ?? this.friends,
      selectedUserIds: selectedUserIds ?? this.selectedUserIds,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
