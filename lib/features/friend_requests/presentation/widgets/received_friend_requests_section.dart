import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../domain/entities/friend_request.dart';
import 'accept_friend_request_icon_button.dart';
import 'decline_friend_request_icon_button.dart';

class ReceivedFriendRequestsSection extends ConsumerStatefulWidget {
  const ReceivedFriendRequestsSection({super.key});

  @override
  ConsumerState<ReceivedFriendRequestsSection> createState() =>
      _ReceivedFriendRequestsSectionState();
}

class _ReceivedFriendRequestsSectionState
    extends ConsumerState<ReceivedFriendRequestsSection> {
  bool _isLoading = true;
  String? _error;
  List<FriendRequest> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ref
        .read(getReceivedFriendRequestsUseCaseProvider)
        .call(limit: 10);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _error = failure.message.isEmpty
              ? 'Không tải được lời mời đã nhận'
              : failure.message;
          _isLoading = false;
        });
      },
      (page) {
        setState(() {
          _items = page.items;
          _isLoading = false;
        });
      },
    );
  }

  void _removeItem(String requestId) {
    setState(() {
      _items = _items.where((item) => item.id != requestId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lời mời đã nhận',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            Text(_error!, style: TextStyle(color: colorScheme.error))
          else if (_items.isEmpty)
            const Text('Chưa có lời mời nào')
          else
            Column(
              children: _items
                  .map(
                    (item) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: UserAvatar(
                        avatarUrl: item.avatarUrl,
                        givenName: item.givenName,
                      ),
                      title: Text(
                        item.fullName.isEmpty ? 'Người dùng' : item.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AcceptFriendRequestIconButton(
                            requestId: item.id,
                            onSuccess: () => _removeItem(item.id),
                          ),
                          DeclineFriendRequestIconButton(
                            requestId: item.id,
                            onSuccess: () => _removeItem(item.id),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
