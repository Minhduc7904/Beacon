import 'package:flutter/material.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/group_message.dart';
import '../../domain/usecase/search_group_messages_usecase.dart';

/// Trạng thái của controller tìm kiếm tin nhắn.
class MessageGroupSearchState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<GroupMessage> messages;
  final String? error;
  final String? nextCursor;
  final bool hasMore;

  const MessageGroupSearchState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.messages = const [],
    this.error,
    this.nextCursor,
    this.hasMore = false,
  });

  MessageGroupSearchState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<GroupMessage>? messages,
    String? error,
    String? nextCursor,
    bool? hasMore,
  }) {
    return MessageGroupSearchState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      messages: messages ?? this.messages,
      error: error,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Controller quản lý logic tìm kiếm tin nhắn trong nhóm.
///
/// Gọi [search] để thực hiện tìm kiếm lần đầu,
/// gọi [loadMore] để load thêm kết quả cũ hơn.
class MessageGroupSearchController extends ChangeNotifier {
  MessageGroupSearchController({
    required SearchGroupMessagesUseCase searchUseCase,
    required String groupId,
    required String keyword,
  })  : _searchUseCase = searchUseCase,
        _groupId = groupId,
        _keyword = keyword;

  final SearchGroupMessagesUseCase _searchUseCase;
  final String _groupId;
  final String _keyword;

  MessageGroupSearchState _state = const MessageGroupSearchState();
  MessageGroupSearchState get state => _state;

  /// Thực hiện tìm kiếm lần đầu.
  Future<void> search() async {
    _state = const MessageGroupSearchState(isLoading: true);
    notifyListeners();

    final result = await _searchUseCase.call(
      groupId: _groupId,
      search: _keyword,
    );

    result.fold(
      (failure) {
        _state = MessageGroupSearchState(
          error: failure is ValidationFailure
              ? failure.message
              : 'Không thể tìm kiếm tin nhắn',
        );
      },
      (page) {
        _state = MessageGroupSearchState(
          messages: page.items,
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        );
      },
    );

    notifyListeners();
  }

  /// Load thêm kết quả cũ hơn (pagination).
  Future<void> loadMore() async {
    if (_state.isLoadingMore || !_state.hasMore || _state.nextCursor == null) {
      return;
    }

    _state = _state.copyWith(isLoadingMore: true);
    notifyListeners();

    final result = await _searchUseCase.call(
      groupId: _groupId,
      search: _keyword,
      cursor: _state.nextCursor,
    );

    result.fold(
      (failure) {
        _state = _state.copyWith(isLoadingMore: false);
      },
      (page) {
        _state = _state.copyWith(
          isLoadingMore: false,
          messages: [..._state.messages, ...page.items],
          nextCursor: page.nextCursor,
          hasMore: page.hasMore,
        );
      },
    );

    notifyListeners();
  }
}
