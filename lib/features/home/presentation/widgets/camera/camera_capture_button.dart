import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';

class CameraCaptureButton extends ConsumerStatefulWidget {
  const CameraCaptureButton({super.key});

  @override
  ConsumerState<CameraCaptureButton> createState() =>
      _CameraCaptureButtonState();
}

class _CameraCaptureButtonState extends ConsumerState<CameraCaptureButton>
    with SingleTickerProviderStateMixin {
  static const Duration _minimumLoadingDuration = Duration(milliseconds: 1000);

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
    _borderWidthAnim = Tween<double>(
      begin: 4.0,
      end: 4.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);
    final canTap = !_isAnimating && !state.showBusy && !state.hasCapturedImage;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: canTap ? _handlePress : null,
      child: SizedBox(
        width: 100,
        height: 100,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final borderWidth = _isAnimating ? _borderWidthAnim.value : 4.0;
            final scale = _isAnimating ? 1 + (borderWidth / 30) : 1.0;

            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.teal300,
                        width: borderWidth,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgColor,
                  ),
                ),
                AnimatedScale(
                  scale: _isAnimating ? 0.9 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isAnimating
                          ? AppColors.teal500
                          : (canTap ? AppColors.teal400 : AppColors.teal100),
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

    if (currentState.cameraError != null && !currentState.hasCapturedImage) {
      await notifier.initializeCamera();
      return;
    }

    if (_isAnimating ||
        currentState.showBusy ||
        currentState.hasCapturedImage) {
      return;
    }

    setState(() => _isAnimating = true);
    _controller.repeat(reverse: true);

    try {
      await notifier.capturePhoto(minimumPublishDelay: _minimumLoadingDuration);
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
