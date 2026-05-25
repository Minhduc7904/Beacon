import '../../../friends/domain/entities/friend_profile.dart';

enum AddGroupMembersStatus { initial, loading, loaded, error }

class AddGroupMembersState {
  final AddGroupMembersStatus status;
  final String search;
  final List<FriendProfile> friends;
  final Set<String> selectedUserIds;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isSubmitting;
  final String? errorMessage;

  const AddGroupMembersState({
    this.status = AddGroupMembersStatus.initial,
    this.search = '',
    this.friends = const [],
    this.selectedUserIds = const {},
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  int get selectedCount => selectedUserIds.length;

  bool isSelected(String userId) => selectedUserIds.contains(userId);

  AddGroupMembersState copyWith({
    AddGroupMembersStatus? status,
    String? search,
    List<FriendProfile>? friends,
    Set<String>? selectedUserIds,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AddGroupMembersState(
      status: status ?? this.status,
      search: search ?? this.search,
      friends: friends ?? this.friends,
      selectedUserIds: selectedUserIds ?? this.selectedUserIds,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
