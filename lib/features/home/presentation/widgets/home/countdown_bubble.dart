import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../controllers/home_checkin_state.dart';

class CountdownBubble extends StatefulWidget {
  const CountdownBubble({super.key, required this.state, this.size});

  final HomeCheckinState state;
  final double? size;

  @override
  State<CountdownBubble> createState() => _CountdownBubbleState();
}

class _CountdownBubbleState extends State<CountdownBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;
  _PulseConfig _pulseConfig = const _PulseConfig.disabled();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _configurePulse(widget.state.phase);
  }

  @override
  void didUpdateWidget(CountdownBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.phase != widget.state.phase) {
      _configurePulse(widget.state.phase);
    }
  }

  void _configurePulse(HomeCheckinPhase phase) {
    final config = _resolvePulseConfig(phase);
    _pulseConfig = config;

    if (!config.shouldPulse) {
      _controller
        ..stop()
        ..duration = const Duration(milliseconds: 1)
        ..value = 0;
      _pulse = AlwaysStoppedAnimation(config.minScale);
      return;
    }

    _controller
      ..stop()
      ..duration = config.duration
      ..value = 0;
    _pulse = _buildHeartbeatAnimation(config);
    _controller.repeat();
  }

  Animation<double> _buildHeartbeatAnimation(_PulseConfig config) {
    final minScale = config.minScale;
    final maxScale = config.maxScale;
    final secondPeak = minScale + (maxScale - minScale) * 0.7;

    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: minScale,
          end: maxScale,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: maxScale,
          end: minScale,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: minScale,
          end: secondPeak,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: secondPeak,
          end: minScale,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 12,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(minScale), weight: 56),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(context, widget.state.phase);
    final size = widget.size ?? 280.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = _pulse.value;
        final pulseIntensity = _pulseConfig.intensityForScale(scale);
        final glowBlur = _pulseConfig.glowBlur(pulseIntensity);
        final glowSpread = _pulseConfig.glowSpread(pulseIntensity);
        final innerGlowBlur = (glowBlur * 0.6).clamp(12.0, 28.0).toDouble();

        return Transform.scale(
          scale: scale,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 0.9,
                colors: [palette.highlight, palette.base],
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.innerGlow.withValues(alpha: 0.55),
                  blurRadius: innerGlowBlur,
                  spreadRadius: -4,
                  blurStyle: ui.BlurStyle.inner,
                ),
                BoxShadow(
                  color: palette.glow.withValues(alpha: 0.45),
                  blurRadius: glowBlur,
                  spreadRadius: glowSpread,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: _BubbleContent(state: widget.state, palette: palette),
    );
  }

  Color _mix(Color a, Color b, double t) {
    return Color.lerp(a, b, t) ?? a;
  }

  _PulseConfig _resolvePulseConfig(HomeCheckinPhase phase) {
    switch (phase) {
      case HomeCheckinPhase.pending:
        return const _PulseConfig(
          duration: Duration(milliseconds: 2600),
          minScale: 0.985,
          maxScale: 1.015,
          minGlow: 20,
          maxGlow: 30,
          minSpread: 2,
          maxSpread: 8,
        );
      case HomeCheckinPhase.grace:
        return const _PulseConfig(
          duration: Duration(milliseconds: 1700),
          minScale: 0.975,
          maxScale: 1.035,
          minGlow: 26,
          maxGlow: 38,
          minSpread: 4,
          maxSpread: 12,
        );
      case HomeCheckinPhase.emergency:
        return const _PulseConfig(
          duration: Duration(milliseconds: 900),
          minScale: 0.96,
          maxScale: 1.06,
          minGlow: 32,
          maxGlow: 48,
          minSpread: 8,
          maxSpread: 16,
        );
      case HomeCheckinPhase.checkedIn:
        return const _PulseConfig(
          duration: Duration(milliseconds: 3200),
          minScale: 0.992,
          maxScale: 1.01,
          minGlow: 14,
          maxGlow: 22,
          minSpread: 2,
          maxSpread: 6,
        );
      case HomeCheckinPhase.monitoringOff:
        return const _PulseConfig(
          duration: Duration(milliseconds: 3600),
          minScale: 0.993,
          maxScale: 1.008,
          minGlow: 12,
          maxGlow: 18,
          minSpread: 1,
          maxSpread: 5,
        );
      case HomeCheckinPhase.unknown:
        return const _PulseConfig(
          duration: Duration(milliseconds: 3400),
          minScale: 0.994,
          maxScale: 1.007,
          minGlow: 12,
          maxGlow: 16,
          minSpread: 1,
          maxSpread: 4,
        );
    }
  }

  _BubblePalette _resolvePalette(BuildContext context, HomeCheckinPhase phase) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (phase) {
      case HomeCheckinPhase.pending:
        final base = colorScheme.primaryContainer;
        return _BubblePalette(
          base: base,
          highlight: _mix(colorScheme.surface, base, 0.35),
          innerGlow: _mix(colorScheme.surface, base, 0.6),
          glow: colorScheme.primary,
        );
      case HomeCheckinPhase.grace:
        final base = colorScheme.secondaryContainer;
        return _BubblePalette(
          base: base,
          highlight: _mix(colorScheme.surface, base, 0.35),
          innerGlow: _mix(colorScheme.surface, base, 0.6),
          glow: colorScheme.secondary,
        );
      case HomeCheckinPhase.emergency:
        final base = AppColors.red100;
        return _BubblePalette(
          base: base,
          highlight: _mix(colorScheme.surface, base, 0.35),
          innerGlow: _mix(colorScheme.surface, base, 0.65),
          glow: colorScheme.error,
        );
      case HomeCheckinPhase.checkedIn:
        final base = AppColors.success.withValues(alpha: 0.18);
        return _BubblePalette(
          base: base,
          highlight: _mix(colorScheme.surface, base, 0.5),
          innerGlow: _mix(colorScheme.surface, base, 0.7),
          glow: AppColors.success,
        );
      case HomeCheckinPhase.monitoringOff:
        final base = colorScheme.surface;
        return _BubblePalette(
          base: base,
          highlight: _mix(colorScheme.surface, base, 0.2),
          innerGlow: colorScheme.outline.withValues(alpha: 0.45),
          glow: colorScheme.outline,
        );
      case HomeCheckinPhase.unknown:
        final base = colorScheme.surface;
        return _BubblePalette(
          base: base,
          highlight: _mix(colorScheme.surface, base, 0.2),
          innerGlow: colorScheme.outline.withValues(alpha: 0.35),
          glow: colorScheme.outline,
        );
    }
  }
}

class _BubbleContent extends StatelessWidget {
  const _BubbleContent({required this.state, required this.palette});

  final HomeCheckinState state;
  final _BubblePalette palette;

  @override
  Widget build(BuildContext context) {
    final content = _resolveContent();

    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Column(
          key: ValueKey('${state.phase}-${content.title}-${content.value}'),
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              content.title.toUpperCase(),
              size: AppTextSize.large,
              spacing: AppTextSpacing.none,
              weight: AppTextWeight.medium,
              color: AppColors.ink100,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              content.value,
              preset: AppTextPreset.title1,
              color: AppColors.ink600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  _BubbleTextContent _resolveContent() {
    if (state.isLoading && state.todayStatus == null) {
      return const _BubbleTextContent(title: 'Đang tải', value: '--:--');
    }

    switch (state.phase) {
      case HomeCheckinPhase.pending:
        return _BubbleTextContent(
          title: 'Đếm ngược',
          value: _formatDuration(state.remainingSeconds),
        );
      case HomeCheckinPhase.grace:
        return _BubbleTextContent(
          title: 'Gia hạn',
          value: _formatDuration(_resolveGraceSeconds()),
        );
      case HomeCheckinPhase.emergency:
        return _BubbleTextContent(
          title: 'Quá hạn',
          value: _formatDuration(state.remainingSeconds?.abs()),
        );
      case HomeCheckinPhase.checkedIn:
        return _BubbleTextContent(title: 'Đã check-in', value: 'An toàn');
      case HomeCheckinPhase.monitoringOff:
        return const _BubbleTextContent(
          title: 'Theo dõi tắt',
          value: 'Không đếm ngược',
        );
      case HomeCheckinPhase.unknown:
        return const _BubbleTextContent(title: 'Đang tải', value: '--:--');
    }
  }

  int? _resolveGraceSeconds() {
    final remaining = state.remainingSeconds;
    if (remaining == null) {
      return null;
    }

    final delaySeconds = state.autoAlertDelayMinutes * 60;
    final overdueSeconds = remaining.abs();
    final graceLeft = delaySeconds - overdueSeconds;

    return graceLeft < 0 ? 0 : graceLeft;
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) {
      return '--:--';
    }

    final value = seconds.abs();
    final hours = value ~/ 3600;
    final minutes = (value % 3600) ~/ 60;
    final secs = value % 60;

    if (hours > 0) {
      return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(secs)}';
    }

    return '${_twoDigits(minutes)}:${_twoDigits(secs)}';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class _BubbleTextContent {
  final String title;
  final String value;

  const _BubbleTextContent({required this.title, required this.value});
}

class _BubblePalette {
  final Color base;
  final Color highlight;
  final Color glow;
  final Color innerGlow;

  const _BubblePalette({
    required this.base,
    required this.highlight,
    required this.glow,
    required this.innerGlow,
  });
}

class _PulseConfig {
  final Duration duration;
  final double minScale;
  final double maxScale;
  final double minGlow;
  final double maxGlow;
  final double minSpread;
  final double maxSpread;

  const _PulseConfig({
    required this.duration,
    required this.minScale,
    required this.maxScale,
    required this.minGlow,
    required this.maxGlow,
    required this.minSpread,
    required this.maxSpread,
  });

  const _PulseConfig.disabled()
    : duration = Duration.zero,
      minScale = 1,
      maxScale = 1,
      minGlow = 0,
      maxGlow = 0,
      minSpread = 0,
      maxSpread = 0;

  bool get shouldPulse => duration != Duration.zero;

  double glowBlur(double t) => ui.lerpDouble(minGlow, maxGlow, t) ?? minGlow;

  double glowSpread(double t) =>
      ui.lerpDouble(minSpread, maxSpread, t) ?? minSpread;

  double intensityForScale(double scale) {
    final range = (maxScale - minScale).abs();
    if (range <= 0) {
      return 0;
    }

    return ((scale - minScale) / range).clamp(0.0, 1.0);
  }
}
