import 'package:flutter/material.dart';
import 'package:flutter_twemoji/flutter_twemoji.dart';

class AppEmoji extends StatelessWidget {
  const AppEmoji({
    super.key,
    required this.emoji,
    this.size = 20,
    this.semanticLabel,
  });

  final String emoji;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final trimmedEmoji = emoji.trim();
    if (trimmedEmoji.isEmpty) {
      return SizedBox(width: size, height: size);
    }

    return Semantics(
      label: semanticLabel ?? trimmedEmoji,
      child: Twemoji(emoji: trimmedEmoji, width: size, height: size),
    );
  }
}

class AppEmojiText extends StatelessWidget {
  const AppEmojiText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.emojiFontMultiplier = 1,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double emojiFontMultiplier;

  @override
  Widget build(BuildContext context) {
    return TwemojiText(
      text: text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      emojiFontMultiplier: emojiFontMultiplier,
    );
  }
}
