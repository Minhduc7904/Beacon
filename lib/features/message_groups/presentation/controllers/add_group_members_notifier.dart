import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../friends/domain/entities/friend_page.dart';
import '../../../friends/domain/usecase/get_friends_usecase.dart';
import '../../domain/usecase/add_group_members_usecase.dart';
import 'add_group_members_state.dart';

class AddGroupMembersNotifier extends StateNotifier<AddGroupMembersState> {
  AddGroupMembersNotifier(
    this._getFriendsUseCase,
    this._addGroupMembersUseCase,
    this._messageNotifier,
  ) : super(const AddGroupMembersState());

  static const int _pageLimit = 20;

  final GetFriendsUseCase _getFriendsUseCase;
  final AddGroupMembersUseCase _addGroupMembersUseCase;
  final AppMessageNotifier _messageNotifier;
  final Debouncer _searchDebouncer = Debouncer(
    delay: const Duration(milliseconds: 350),
  );

  Future<void> load({bool forceRefresh = false}) async {
    if (!forceRefresh && state.status == AddGroupMembersStatus.loaded) {
      return;
    }

    state = state.copyWith(
      status: AddGroupMembersStatus.loading,
      friends: const [],
      selectedUserIds: forceRefresh ? const {} : state.selectedUserIds,
      clearNextCursor: true,
      hasMore: false,
      isLoadingMore: false,
      clearErrorMessage: true,
    );

    await _loadPage(search: state.search, cursor: null, append: false);
  }

  void updateSearch(String value) {
    final search = value.trim();
    if (search == state.search) {
      return;
    }

    _searchDebouncer.cancel();
    state = state.copyWith(
      search: search,
      status: AddGroupMembersStatus.loading,
      friends: const [],
      clearNextCursor: true,
      hasMore: false,
      isLoadingMore: false,
      clearErrorMessage: true,
    );

    _searchDebouncer.run(() {
      unawaited(_loadPage(search: search, cursor: null, append: false));
    });
  }

  Future<void> loadMore() async {
    if (state.status != AddGroupMembersStatus.loaded ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final cursor = state.nextCursor;
    if (cursor == null || cursor.trim().isEmpty) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, clearErrorMessage: true);
    await _loadPage(search: state.search, cursor: cursor, append: true);
  }

  void toggleFriend(String userId) {
    final normalized = userId.trim();
    if (normalized.isEmpty) {
      return;
    }

    final selected = Set<String>.from(state.selectedUserIds);
    if (!selected.add(normalized)) {
      selected.remove(normalized);
    }

    state = state.copyWith(selectedUserIds: selected);
  }

  Future<bool> submit({required String groupId}) async {
    if (state.isSubmitting || state.selectedUserIds.isEmpty) {
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearErrorMessage: true);
    final result = await _addGroupMembersUseCase(
      groupId: groupId,
      targetUserIds: state.selectedUserIds.toList(growable: false),
    );

    return result.fold(
      (failure) {
        _messageNotifier.addError(failure.message);
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        _messageNotifier.addSuccess('Đã thêm thành viên');
        state = state.copyWith(isSubmitting: false);
        return true;
      },
    );
  }

  Future<void> _loadPage({
    required String search,
    required String? cursor,
    required bool append,
  }) async {
    final result = await _getFriendsUseCase(
      search: search.isEmpty ? null : search,
      cursor: cursor,
      limit: _pageLimit,
    );

    result.fold((failure) {
      _messageNotifier.addError(failure.message);
      state = state.copyWith(
        status: append
            ? AddGroupMembersStatus.loaded
            : AddGroupMembersStatus.error,
        isLoadingMore: false,
        errorMessage: failure.message,
      );
    }, (page) => _applyPage(page, append: append));
  }

  void _applyPage(FriendPage page, {required bool append}) {
    final merged = append ? [...state.friends, ...page.items] : page.items;
    state = state.copyWith(
      status: AddGroupMembersStatus.loaded,
      friends: merged,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
      isLoadingMore: false,
      clearErrorMessage: true,
    );
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }
}
