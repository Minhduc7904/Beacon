import 'dart:async';
import 'package:flutter/material.dart';
import '../../messages/app_message.dart';

class MessageToast extends StatefulWidget {
  final AppMessage message;
  final VoidCallback onDismiss;
  final Duration displayDuration;

  const MessageToast({
    super.key,
    required this.message,
    required this.onDismiss,
    this.displayDuration = const Duration(seconds: 3),
  });

  @override
  State<MessageToast> createState() => _MessageToastState();
}

class _MessageToastState extends State<MessageToast>
    with TickerProviderStateMixin {
  late final AnimationController _enterController;
  late final AnimationController _exitController;
  late final Animation<Offset> _enterSlide;
  late final Animation<Offset> _exitSlide;
  late final Animation<double> _fade;
  Timer? _timer;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _enterSlide = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterController, curve: Curves.easeOut));

    _exitSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1.5),
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _fade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _enterController.forward();
    _timer = Timer(widget.displayDuration, _startExit);
  }

  void _startExit() {
    if (!mounted || _isExiting) return;
    setState(() => _isExiting = true);
    _exitController.forward().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _enterController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_enterController, _exitController]),
      builder: (context, child) {
        return FractionalTranslation(
          translation: _isExiting ? _exitSlide.value : _enterSlide.value,
          child: Opacity(opacity: _fade.value, child: child),
        );
      },
      child: GestureDetector(onTap: _startExit, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    final (Color bgColor, IconData icon) = switch (widget.message.type) {
      MessageType.success => (
        Colors.green.shade700,
        Icons.check_circle_outline,
      ),
      MessageType.error => (Colors.red.shade700, Icons.error_outline),
      MessageType.warning => (
        Colors.orange.shade700,
        Icons.warning_amber_outlined,
      ),
      MessageType.info => (Colors.blue.shade700, Icons.info_outline),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.message.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _startExit,
            child: const Icon(Icons.close, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }
}
