import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../friends/domain/entities/friend_page.dart';
import '../../../friends/domain/usecase/get_friends_usecase.dart';
import 'create_message_group_sheet_state.dart';

class CreateMessageGroupSheetNotifier
    extends StateNotifier<CreateMessageGroupSheetState> {
  CreateMessageGroupSheetNotifier(
    this._getFriendsUseCase,
    this._messageNotifier,
  ) : super(const CreateMessageGroupSheetState());

  static const int _pageLimit = 20;

  final GetFriendsUseCase _getFriendsUseCase;
  final AppMessageNotifier _messageNotifier;
  final Debouncer _searchDebouncer = Debouncer(
    delay: const Duration(milliseconds: 350),
  );

  Future<void> load({bool forceRefresh = false}) async {
    if (!forceRefresh && state.status == CreateMessageGroupSheetStatus.loaded) {
      return;
    }

    state = state.copyWith(
      status: CreateMessageGroupSheetStatus.loading,
      friends: const [],
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
      status: CreateMessageGroupSheetStatus.loading,
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
    if (state.status != CreateMessageGroupSheetStatus.loaded ||
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
            ? CreateMessageGroupSheetStatus.loaded
            : CreateMessageGroupSheetStatus.error,
        isLoadingMore: false,
        errorMessage: failure.message,
      );
    }, (page) => _applyPage(page, append: append));
  }

  void _applyPage(FriendPage page, {required bool append}) {
    final merged = append ? [...state.friends, ...page.items] : page.items;
    state = state.copyWith(
      status: CreateMessageGroupSheetStatus.loaded,
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
