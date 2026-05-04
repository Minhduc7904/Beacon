import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';

class DeclineFriendRequestIconButton extends ConsumerStatefulWidget {
  const DeclineFriendRequestIconButton({
    super.key,
    required this.requestId,
    this.onSuccess,
  });

  final String requestId;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<DeclineFriendRequestIconButton> createState() =>
      _DeclineFriendRequestIconButtonState();
}

class _DeclineFriendRequestIconButtonState
    extends ConsumerState<DeclineFriendRequestIconButton> {
  bool _isLoading = false;

  Future<void> _onPressed() async {
    if (_isLoading) {
      return;
    }
    setState(() => _isLoading = true);

    final result = await ref
        .read(declineFriendRequestUseCaseProvider)
        .call(id: widget.requestId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) => ref
          .read(appMessageProvider.notifier)
          .addError(
            failure.message.isEmpty
                ? 'Từ chối lời mời thất bại'
                : failure.message,
          ),
      (_) {
        ref.read(appMessageProvider.notifier).addInfo('Đã từ chối lời mời');
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
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: 'Từ chối',
      onPressed: _isLoading ? null : _onPressed,
      icon: _isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.cancel_rounded, color: colorScheme.error),
    );
  }
}
