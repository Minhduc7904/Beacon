import 'package:flutter/material.dart';

import '../../../../../core/widgets/input/input.dart';

/// The message composer bar at the bottom of the chat screen.
class MessageInputBar extends StatefulWidget {
  const MessageInputBar({
    super.key,
    required this.onSend,
    this.isSending = false,
  });

  final ValueChanged<String> onSend;
  final bool isSending;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;

    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Text field (shared Input widget) ──
            Expanded(
              child: Input(
                controller: _controller,
                hintText: 'Nhắn tin...',
                height: 44,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),

            // ── Send button ──
            _SendButton(
              isEnabled: _hasText && !widget.isSending,
              isSending: widget.isSending,
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.isEnabled,
    required this.isSending,
    required this.onPressed,
  });

  final bool isEnabled;
  final bool isSending;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isEnabled ? colorScheme.primary : colorScheme.outline;

    return SizedBox(
      width: 42,
      height: 42,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: Center(
            child: isSending
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(colorScheme.onPrimary),
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    size: 20,
                    color: colorScheme.onPrimary,
                  ),
          ),
        ),
      ),
    );
  }
}
