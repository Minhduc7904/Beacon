import 'package:flutter/material.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/feed_reaction.dart';

/// A horizontal row of emoji reaction buttons for a feed post.
class FeedReactionBar extends StatelessWidget {
  const FeedReactionBar({
    super.key,
    required this.myReaction,
    required this.reactionCounts,
    required this.onReact,
  });

  final ReactionType? myReaction;
  final Map<ReactionType, int> reactionCounts;
  final ValueChanged<ReactionType> onReact;

  static const _reactionEmojis = {
    ReactionType.heart: '❤️',
    ReactionType.fire: '🔥',
    ReactionType.laugh: '😂',
    ReactionType.sad: '😢',
    ReactionType.wow: '😮',
    ReactionType.clap: '👏',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ReactionType.values.map((type) {
        final isSelected = myReaction == type;
        final count = reactionCounts[type] ?? 0;
        final emoji = _reactionEmojis[type] ?? '?';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _ReactionChip(
            emoji: emoji,
            count: count,
            isSelected: isSelected,
            onTap: () => onReact(type),
          ),
        );
      }).toList(),
    );
  }
}

class _ReactionChip extends StatefulWidget {
  const _ReactionChip({
    required this.emoji,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ReactionChip> createState() => _ReactionChipState();
}

class _ReactionChipState extends State<_ReactionChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(_ReactionChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isSelected && widget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isSelected
                ? colorScheme.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: ScaleTransition(
          scale: _scale,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 16)),
              if (widget.count > 0) ...[
                const SizedBox(width: 3),
                AppText(
                  '${widget.count}',
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                  color: widget.isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
