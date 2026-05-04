import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/entities/friend_request.dart';

class SentFriendRequestsSection extends ConsumerStatefulWidget {
  const SentFriendRequestsSection({super.key});

  @override
  ConsumerState<SentFriendRequestsSection> createState() =>
      _SentFriendRequestsSectionState();
}

class _SentFriendRequestsSectionState
    extends ConsumerState<SentFriendRequestsSection> {
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
        .read(getSentFriendRequestsUseCaseProvider)
        .call(limit: 10);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _error = failure.message.isEmpty
              ? 'Không tải được lời mời đã gửi'
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
            'Lời mời đã gửi',
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
            const Text('Chưa gửi lời mời nào')
          else
            Column(
              children: _items
                  .map(
                    (item) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.senderUsername),
                      subtitle: Text(item.senderId),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
