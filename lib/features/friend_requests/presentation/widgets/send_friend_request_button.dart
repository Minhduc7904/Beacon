import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';

class SendFriendRequestButton extends ConsumerStatefulWidget {
  final String receiverId;

  const SendFriendRequestButton({super.key, required this.receiverId});

  @override
  ConsumerState<SendFriendRequestButton> createState() =>
      _SendFriendRequestButtonState();
}

class _SendFriendRequestButtonState
    extends ConsumerState<SendFriendRequestButton> {
  bool _isSending = false;
  bool _isSent = false;

  Future<void> _send() async {
    if (_isSending || _isSent) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    final result = await ref
        .read(sendFriendRequestUseCaseProvider)
        .call(receiverId: widget.receiverId);

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref
            .read(appMessageProvider.notifier)
            .addError(
              failure.message.isEmpty
                  ? 'Gửi lời mời kết bạn thất bại'
                  : failure.message,
            );
      },
      (_) {
        ref
            .read(appMessageProvider.notifier)
            .addSuccess('Đã gửi lời mời kết bạn');
        _isSent = true;
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _isSending || _isSent ? null : _send,
      child: Text(
        _isSent ? 'Đã gửi' : (_isSending ? 'Đang gửi' : 'Add friend'),
      ),
    );
  }
}
