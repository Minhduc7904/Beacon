import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';

class HomeActionButton extends ConsumerStatefulWidget {
  const HomeActionButton({super.key});

  @override
  ConsumerState<HomeActionButton> createState() =>
      _HomeActionButtonState();
}

class _HomeActionButtonState extends ConsumerState<HomeActionButton>
    with SingleTickerProviderStateMixin {
  static const Duration _minimumLoadingDuration =
      Duration(milliseconds: 1000);

  late final AnimationController _controller;
  late final Animation<double> _borderWidthAnim;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    /// 🔥 border dày lên (2 → 5)
    _borderWidthAnim = Tween<double>(
      begin: 2.0,
      end: 5.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    final canTap =
        !_isAnimating && !state.showBusy && !state.hasCapturedImage;

    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: canTap ? _handlePress : null,
      child: SizedBox(
        width: 80,
        height: 80,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final borderWidth =
                _isAnimating ? _borderWidthAnim.value : 2.0;

            /// scale nhẹ theo border cho cảm giác "thở"
            final scale =
                _isAnimating ? 1 + (borderWidth / 30) : 1.0;

            return Stack(
              alignment: Alignment.center,
              children: [
                /// 🔥 BORDER (phồng ra ngoài)
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.teal400,
                        width: borderWidth,
                      ),
                    ),
                  ),
                ),

                /// 🔥 BACKGROUND (gần sát border hơn)
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor,
                  ),
                ),

                /// 🔥 INNER BUTTON
                AnimatedScale(
                  scale: _isAnimating ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isAnimating
                          ? AppColors.teal500
                          : (canTap
                              ? AppColors.teal400
                              : AppColors.teal100),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handlePress() async {
    final currentState = ref.read(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    if (currentState.cameraError != null &&
        !currentState.hasCapturedImage) {
      await notifier.initializeCamera();
      return;
    }

    if (_isAnimating ||
        currentState.showBusy ||
        currentState.hasCapturedImage) {
      return;
    }

    setState(() => _isAnimating = true);

    /// 🔥 chạy animation ping-pong
    _controller.repeat(reverse: true);

    try {
      await notifier.capturePhoto(
        minimumPublishDelay: _minimumLoadingDuration,
      );
    } finally {
      if (mounted) {
        _controller
          ..stop()
          ..value = 0;

        setState(() => _isAnimating = false);
      }
    }
  }
}