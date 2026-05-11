import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/messages/app_message_notifier.dart';
import '../../domain/entities/friend_presence.dart';
import '../../domain/entities/friend_presence_event.dart';
import '../../domain/usecase/get_friends_presence_usecase.dart';
import 'friends_presence_state.dart';

class FriendsPresenceNotifier extends StateNotifier<FriendsPresenceState> {
  FriendsPresenceNotifier(
    this._getFriendsPresenceUseCase,
    this._messageNotifier,
  ) : super(const FriendsPresenceState());

  final GetFriendsPresenceUseCase _getFriendsPresenceUseCase;
  final AppMessageNotifier _messageNotifier;

  Future<void> load({bool forceRefresh = false, int limit = 20}) async {
    if (!forceRefresh &&
        (state.status == FriendsPresenceStatus.loading ||
            state.status == FriendsPresenceStatus.loaded)) {
      return;
    }

    state = state.copyWith(
      status: FriendsPresenceStatus.loading,
      friends: forceRefresh ? const [] : state.friends,
      errorMessage: null,
    );
    await _loadPage(cursor: null, limit: limit, append: false);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == FriendsPresenceStatus.loading) {
      return;
    }

    state = state.copyWith(status: FriendsPresenceStatus.loading);
    await _loadPage(cursor: state.nextCursor, limit: state.limit, append: true);
  }

  void applyPresenceEvent(FriendPresenceEvent event) {
    final friends = List<FriendPresence>.from(state.friends);
    final index = friends.indexWhere((friend) => friend.userId == event.userId);
    if (index < 0) {
      return;
    }

    final current = friends[index];
    friends[index] = current.copyWith(
      isOnline: event.isOnline,
      lastActiveAtUtc: event.lastActiveAtUtc,
    );

    state = state.copyWith(
      status: FriendsPresenceStatus.loaded,
      friends: friends,
      errorMessage: null,
    );
  }

  Future<void> _loadPage({
    required String? cursor,
    required int limit,
    required bool append,
  }) async {
    final result = await _getFriendsPresenceUseCase.call(
      cursor: cursor,
      limit: limit,
    );

    result.fold(
      (failure) {
        _messageNotifier.addWarning(
          failure.message.isEmpty
              ? 'Khong the tai trang thai ban be'
              : failure.message,
        );
        state = state.copyWith(
          status: FriendsPresenceStatus.error,
          errorMessage: failure.message,
        );
      },
      (page) {
        final items = append
            ? <FriendPresence>[...state.friends, ...page.items]
            : page.items;
        state = state.copyWith(
          status: FriendsPresenceStatus.loaded,
          friends: items,
          nextCursor: page.nextCursor,
          limit: page.limit,
          hasMore: page.hasMore,
          errorMessage: null,
        );
      },
    );
  }
}
