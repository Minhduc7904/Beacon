import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../friend_requests/presentation/widgets/send_friend_request_button.dart';
import '../../domain/entities/friend_profile.dart';

class AddFriendsPage extends ConsumerStatefulWidget {
  const AddFriendsPage({super.key});

  @override
  ConsumerState<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends ConsumerState<AddFriendsPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<FriendProfile> _results = const [];
  bool _isSearching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
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
        child: Column(
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
          title: Text(friend.username),
          subtitle: Text(friend.userId),
          trailing: SendFriendRequestButton(
            key: ValueKey<String>(friend.userId),
            receiverId: friend.userId,
          ),
        );
      },
    );
  }
}
