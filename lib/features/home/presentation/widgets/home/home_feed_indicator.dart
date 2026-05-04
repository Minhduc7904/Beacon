import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';

class HomeFeedIndicator extends StatefulWidget {
  const HomeFeedIndicator({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<HomeFeedIndicator> createState() => _HomeFeedIndicatorState();
}

class _HomeFeedIndicatorState extends State<HomeFeedIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _bounce = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              'Bảng tin',
              size: AppTextSize.small,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.medium,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 2),
            AnimatedBuilder(
              animation: _bounce,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounce.value),
                  child: child,
                );
              },
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
