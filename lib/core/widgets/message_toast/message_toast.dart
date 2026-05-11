import 'dart:async';
import 'package:flutter/material.dart';
import '../../messages/app_message.dart';
import '../../theme/color/app_colors.dart';
import '../../theme/text/app_text_theme.dart';
import '../text/text.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final (Color bgColor, IconData icon) = switch (widget.message.type) {
      MessageType.success => (AppColors.success, Icons.check_circle_outline),
      MessageType.error => (AppColors.red500, Icons.error_outline),
      MessageType.warning => (AppColors.coral500, Icons.warning_amber_outlined),
      MessageType.info => (colorScheme.primary, Icons.info_outline),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.sky100, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              widget.message.message,
              size: AppTextSize.small,
              spacing: AppTextSpacing.normal,
              weight: AppTextWeight.medium,
              color: AppColors.sky100,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _startExit,
            child: Icon(
              Icons.close,
              color: AppColors.sky100.withValues(alpha: 0.72),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
