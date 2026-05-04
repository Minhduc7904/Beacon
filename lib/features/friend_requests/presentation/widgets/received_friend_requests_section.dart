import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../domain/entities/friend_request.dart';

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

  @override
  Widget build(BuildContext context) {
    return _FriendRequestSectionCard(
      title: 'Lời mời đã nhận',
      isLoading: _isLoading,
      error: _error,
      emptyText: 'Chưa có lời mời nào',
      items: _items,
    );
  }
}

class _FriendRequestSectionCard extends StatelessWidget {
  const _FriendRequestSectionCard({
    required this.title,
    required this.isLoading,
    required this.error,
    required this.emptyText,
    required this.items,
  });

  final String title;
  final bool isLoading;
  final String? error;
  final String emptyText;
  final List<FriendRequest> items;

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
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (error != null)
            Text(error!, style: TextStyle(color: colorScheme.error))
          else if (items.isEmpty)
            Text(emptyText)
          else
            Column(
              children: items
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
