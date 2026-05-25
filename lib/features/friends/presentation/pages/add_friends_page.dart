import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../friend_requests/presentation/widgets/received_friend_requests_section.dart';
import '../../../friend_requests/presentation/widgets/send_friend_request_button.dart';
import '../../../friend_requests/presentation/widgets/sent_friend_requests_section.dart';
import '../../domain/entities/friend_profile.dart';

class AddFriendsPage extends ConsumerStatefulWidget {
  const AddFriendsPage({super.key});

  @override
  ConsumerState<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends ConsumerState<AddFriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _searchDebouncer = Debouncer(
    delay: const Duration(milliseconds: 450),
  );
  List<FriendProfile> _results = const [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchDebouncer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebouncer.run(() {
      _search(value);
    });
  }

  Future<void> _search(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _results = const [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final result = await ref
        .read(searchFriendsUseCaseProvider)
        .call(search: query, limit: 20);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref
            .read(appMessageProvider.notifier)
            .addError(
              failure.message.isEmpty ? 'Tìm kiếm thất bại' : failure.message,
            );
        setState(() {
          _results = const [];
          _isSearching = false;
        });
      },
      (page) {
        setState(() {
          _results = page.items;
          _isSearching = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final showDropdown = query.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Thêm bạn bè')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Input(
              controller: _searchController,
              hintText: 'Nhập tên để tìm bạn bè',
              type: InputType.leftIcon,
              leftIcon: const Icon(Icons.search_rounded),
              state: InputState.defaultState,
              onChanged: _onSearchChanged,
            ),
            if (showDropdown) ...[
              const SizedBox(height: 8),
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(10),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: _buildDropdownBody(),
                ),
              ),
            ],
            const SizedBox(height: 12),
            const ReceivedFriendRequestsSection(),
            const SizedBox(height: 10),
            const SentFriendRequestsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownBody() {
    if (_isSearching) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Không tìm thấy bạn bè phù hợp'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final friend = _results[index];
        return ListTile(
          leading: UserAvatar(
            avatarUrl: friend.avatarUrl,
            givenName: friend.givenName,
          ),
          title: Text(
            friend.fullName.isEmpty ? 'Người dùng' : friend.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: _buildTrailingAction(friend),
        );
      },
    );
  }

  Widget _buildTrailingAction(FriendProfile friend) {
    switch (friend.friendshipStatus) {
      case 0:
        return SendFriendRequestButton(
          key: ValueKey<String>('add-${friend.userId}'),
          receiverId: friend.userId,
        );
      case 1:
        return const _FriendStatusBadge(label: 'Bạn bè');
      case 2:
        return const _FriendStatusBadge(label: 'Đã gửi lời mời');
      case 3:
        return const _FriendStatusBadge(label: 'Đã nhận lời mời');
      default:
        return const _FriendStatusBadge(label: 'Không khả dụng');
    }
  }
}

class _FriendStatusBadge extends StatelessWidget {
  const _FriendStatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}
