import 'dart:math' as math;

import 'package:flutter/material.dart';

class ReactionFlyOverlay extends StatefulWidget {
  const ReactionFlyOverlay({
    super.key,
    required this.reactions,
    this.minCopiesPerReaction = 5,
    this.maxCopiesPerReaction = 6,
    this.maxReactionTypes = 5,
    this.onCompleted,
  });

  final List<String> reactions;
  final int minCopiesPerReaction;
  final int maxCopiesPerReaction;
  final int maxReactionTypes;
  final VoidCallback? onCompleted;

  @override
  State<ReactionFlyOverlay> createState() => _ReactionFlyOverlayState();
}

class _ReactionFlyOverlayState extends State<ReactionFlyOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ReactionFlyParticle> _particles;

  @override
  void initState() {
    super.initState();

    final reactionTypes = _uniqueReactionTypes(widget.reactions);
    _particles = _buildParticles(reactionTypes);
    final duration = 3800 + (_particles.length * 35);

    _controller =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: duration.clamp(4200, 5400).toInt()),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.onCompleted?.call();
          }
        });

    if (_particles.isNotEmpty) {
      _controller.forward();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onCompleted?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final particle in _particles) {
      particle.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  List<String> _uniqueReactionTypes(List<String> reactions) {
    final reactionTypes = <String>[];
    for (final reaction in reactions) {
      final trimmed = reaction.trim();
      if (trimmed.isNotEmpty && !reactionTypes.contains(trimmed)) {
        reactionTypes.add(trimmed);
      }

      if (reactionTypes.length >= widget.maxReactionTypes) {
        break;
      }
    }

    return reactionTypes;
  }

  List<_ReactionFlyParticle> _buildParticles(List<String> reactionTypes) {
    final random = math.Random();
    final particles = <_ReactionFlyParticle>[];
    var particleIndex = 0;
    final minCopies = widget.minCopiesPerReaction.clamp(1, 12).toInt();
    final maxCopies = widget.maxCopiesPerReaction.clamp(minCopies, 14).toInt();

    for (final reaction in reactionTypes) {
      final copies = minCopies + random.nextInt(maxCopies - minCopies + 1);
      for (var copyIndex = 0; copyIndex < copies; copyIndex++) {
        final begin = (particleIndex * 0.026 + random.nextDouble() * 0.06)
            .clamp(0.0, 0.66)
            .toDouble();
        final end = (begin + 0.42 + random.nextDouble() * 0.18)
            .clamp(0.58, 1.0)
            .toDouble();

        particles.add(
          _ReactionFlyParticle(
            reaction: reaction,
            xFactor: 0.08 + random.nextDouble() * 0.84,
            drift: -90 + random.nextDouble() * 180,
            begin: begin,
            end: end,
            startScale: 0.78 + random.nextDouble() * 0.18,
            peakScale: 1.08 + random.nextDouble() * 0.22,
            fontSize: 38 + random.nextDouble() * 16,
            rotation: -0.28 + random.nextDouble() * 0.56,
          ),
        );
        particleIndex += 1;
      }
    }

    particles.shuffle(random);
    return particles;
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _ReactionFlyPainter(
                animation: _controller,
                particles: _particles,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ReactionFlyPainter extends CustomPainter {
  _ReactionFlyPainter({required this.animation, required this.particles})
    : super(repaint: animation);

  final Animation<double> animation;
  final List<_ReactionFlyParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    for (final particle in particles) {
      _paintParticle(canvas, size, particle, progress);
    }
  }

  void _paintParticle(
    Canvas canvas,
    Size size,
    _ReactionFlyParticle particle,
    double progress,
  ) {
    final span = particle.end - particle.begin;
    final rawT = span <= 0 ? 1.0 : (progress - particle.begin) / span;
    final t = rawT.clamp(0.0, 1.0).toDouble();
    if (t <= 0 || t >= 1) {
      return;
    }

    final moveT = Curves.easeInCubic.transform(t);
    final scaleDownT = const Interval(
      0.24,
      1.0,
      curve: Curves.easeOut,
    ).transform(t);
    final scale =
        particle.startScale +
        (particle.peakScale - particle.startScale) *
            const Interval(0.0, 0.24, curve: Curves.easeOutBack).transform(t) -
        (particle.peakScale - 0.96) * scaleDownT * 0.32;
    final centerX =
        (size.width * particle.xFactor +
                particle.drift * math.sin(moveT * math.pi))
            .clamp(particle.fontSize * 0.5, size.width - particle.fontSize * 0.5)
            .toDouble();
    final startBottom = -particle.fontSize - 48;
    final endBottom = size.height + particle.fontSize + 72;
    final bottom = startBottom + (endBottom - startBottom) * moveT;
    final centerY = size.height - bottom - particle.textPainter.height * 0.5;

    if (centerY < -particle.fontSize * 2 ||
        centerY > size.height + particle.fontSize * 2) {
      return;
    }

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(particle.rotation * moveT);
    canvas.scale(scale);
    particle.textPainter.paint(
      canvas,
      Offset(
        -particle.textPainter.width * 0.5,
        -particle.textPainter.height * 0.5,
      ),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ReactionFlyPainter oldDelegate) {
    return oldDelegate.particles != particles ||
        oldDelegate.animation != animation;
  }
}

class _ReactionFlyParticle {
  _ReactionFlyParticle({
    required this.reaction,
    required this.xFactor,
    required this.drift,
    required this.begin,
    required this.end,
    required this.startScale,
    required this.peakScale,
    required this.fontSize,
    required this.rotation,
  }) : textPainter = TextPainter(
         text: TextSpan(text: reaction, style: TextStyle(fontSize: fontSize)),
         textDirection: TextDirection.ltr,
       ) {
    textPainter.layout();
  }

  final String reaction;
  final double xFactor;
  final double drift;
  final double begin;
  final double end;
  final double startScale;
  final double peakScale;
  final double fontSize;
  final double rotation;
  final TextPainter textPainter;

  void dispose() {
    textPainter.dispose();
  }
}
