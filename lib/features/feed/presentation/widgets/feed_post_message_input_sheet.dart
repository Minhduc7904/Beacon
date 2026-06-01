import 'package:flutter/material.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/widgets/input/input.dart';

class PostMessageInputSheet extends StatefulWidget {
  const PostMessageInputSheet({
    super.key,
    required this.clientMessageId,
    required this.onSend,
  });

  final String clientMessageId;
  final Future<bool> Function(String content, String clientMessageId) onSend;

  @override
  State<PostMessageInputSheet> createState() => _PostMessageInputSheetState();
}

class _PostMessageInputSheetState extends State<PostMessageInputSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText == _hasText) {
      return;
    }

    setState(() {
      _hasText = hasText;
    });
  }

  Future<void> _handleSend() async {
    final content = _controller.text.trim();
    if (content.isEmpty || _isSending) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    final didSend = await widget.onSend(content, widget.clientMessageId);
    if (!mounted) {
      return;
    }

    if (didSend) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                Expanded(
                  child: Input(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    hintText: 'Nhắn tin...',
                    height: 44,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 10),
                _PostMessageSendButton(
                  isEnabled: _hasText && !_isSending,
                  isSending: _isSending,
                  onPressed: _handleSend,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PostMessageSendButton extends StatelessWidget {
  const _PostMessageSendButton({
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
    final backgroundColor = isEnabled ? colorScheme.primary : AppColors.ink100;

    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: backgroundColor,
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
                      valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                    ),
                  )
                : AppIcon(
                    AppIcons.send,
                    size: 20,
                    color: colorScheme.onPrimary,
                  ),
          ),
        ),
      ),
    );
  }
}
