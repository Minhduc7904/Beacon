import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/utils/debouncer.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/input/input.dart';

class GroupMessageInputBar extends StatefulWidget {
  const GroupMessageInputBar({
    super.key,
    required this.onSend,
    this.onTypingChanged,
    this.isSending = false,
  });

  final ValueChanged<String> onSend;
  final ValueChanged<bool>? onTypingChanged;
  final bool isSending;

  @override
  State<GroupMessageInputBar> createState() => _GroupMessageInputBarState();
}

class _GroupMessageInputBarState extends State<GroupMessageInputBar> {
  final _controller = TextEditingController();
  final Debouncer _typingDebouncer = Debouncer(
    delay: const Duration(milliseconds: 1200),
  );
  bool _hasText = false;
  bool _typingSent = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }

      if (hasText) {
        if (!_typingSent) {
          _typingSent = true;
          widget.onTypingChanged?.call(true);
        }
        _typingDebouncer.run(() {
          _typingSent = false;
          widget.onTypingChanged?.call(false);
        });
      } else {
        _typingDebouncer.cancel();
        if (_typingSent) {
          _typingSent = false;
          widget.onTypingChanged?.call(false);
        }
      }
    });
  }

  @override
  void dispose() {
    _typingDebouncer.dispose();
    if (_typingSent) {
      widget.onTypingChanged?.call(false);
    }
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;

    widget.onSend(text);
    _controller.clear();
    _typingDebouncer.cancel();
    if (_typingSent) {
      _typingSent = false;
      widget.onTypingChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _InputBarContentLayout(
          child: Row(
            children: [
              Expanded(
                child: Input(
                  controller: _controller,
                  hintText: 'Nhắn tin...',
                  height: 44,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              _SendButton(
                isEnabled: _hasText && !widget.isSending,
                isSending: widget.isSending,
                onPressed: _handleSend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputBarContentLayout extends StatelessWidget {
  const _InputBarContentLayout({required this.child});

  static const _contentPadding = EdgeInsets.symmetric(vertical: 10);

  final Widget child;

  double _contentWidthForColumns(int columns) {
    return (AppScreenLayout.columnWidth * columns) +
        (AppScreenLayout.gutter * (columns - 1));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final isTablet = maxWidth >= AppScreenLayout.tabletBreakpoint;
        final columnCount = isTablet
            ? AppScreenLayout.tabletColumnCount
            : AppScreenLayout.mobileColumnCount;
        final designWidth = _contentWidthForColumns(columnCount);
        final safeWidth = math.max(
          0.0,
          maxWidth - AppScreenLayout.minHorizontalSafeInset * 2,
        );
        final layoutWidth = math.min(designWidth, safeWidth);

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: layoutWidth,
            child: Padding(padding: _contentPadding, child: child),
          ),
        );
      },
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
