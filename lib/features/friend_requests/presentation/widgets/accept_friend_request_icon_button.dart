import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';

class AcceptFriendRequestIconButton extends ConsumerStatefulWidget {
  const AcceptFriendRequestIconButton({
    super.key,
    required this.requestId,
    this.onSuccess,
  });

  final String requestId;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<AcceptFriendRequestIconButton> createState() =>
      _AcceptFriendRequestIconButtonState();
}

class _AcceptFriendRequestIconButtonState
    extends ConsumerState<AcceptFriendRequestIconButton> {
  bool _isLoading = false;

  Future<void> _onPressed() async {
    if (_isLoading) {
      return;
    }
    setState(() => _isLoading = true);

    final result = await ref
        .read(acceptFriendRequestUseCaseProvider)
        .call(id: widget.requestId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) => ref
          .read(appMessageProvider.notifier)
          .addError(
            failure.message.isEmpty
                ? 'Chấp nhận lời mời thất bại'
                : failure.message,
          ),
      (_) {
        ref
            .read(appMessageProvider.notifier)
            .addSuccess('Đã chấp nhận lời mời');
        widget.onSuccess?.call();
      },
    );

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Chấp nhận',
      onPressed: _isLoading ? null : _onPressed,
      icon: _isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.check_circle_rounded),
    );
  }
}
