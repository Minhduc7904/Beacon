import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import 'message_toast.dart';

class GlobalMessageOverlay extends ConsumerWidget {
  final Widget child;

  const GlobalMessageOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(appMessageProvider);

    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: messages
                    .map(
                      (m) => MessageToast(
                        key: ValueKey(m.id),
                        message: m,
                        onDismiss: () => ref
                            .read(appMessageProvider.notifier)
                            .removeMessage(m.id),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
