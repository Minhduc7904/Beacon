import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../theme/text/app_text_theme.dart';
import '../text/text.dart';

Future<String?> showAppEmojiPickerSheet(
  BuildContext context, {
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AppEmojiPickerSheet(),
  );
}

class AppEmojiPickerSheet extends StatelessWidget {
  const AppEmojiPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final emojiScale = Theme.of(context).platform == TargetPlatform.iOS
        ? 1.2
        : 1.0;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                child: Row(
                  children: [
                    AppText(
                      'Chọn emoji',
                      size: AppTextSize.regular,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    const Spacer(),
                    AppText(
                      'Nhấn để gửi react',
                      size: AppTextSize.veryTiny,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.regular,
                      color: colorScheme.onSurface.withValues(alpha: 0.58),
                    ),
                  ],
                ),
              ),
              EmojiPicker(
                onEmojiSelected: (_, emoji) {
                  Navigator.of(context).pop(emoji.emoji);
                },
                config: Config(
                  height: 334,
                  checkPlatformCompatibility: false,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 8,
                    emojiSizeMax: 28 * emojiScale,
                    backgroundColor: colorScheme.surface,
                    gridPadding: const EdgeInsets.symmetric(horizontal: 8),
                    buttonMode: ButtonMode.MATERIAL,
                    noRecents: Center(
                      child: AppText(
                        'Chưa có emoji gần đây',
                        size: AppTextSize.small,
                        spacing: AppTextSpacing.tight,
                        weight: AppTextWeight.regular,
                        color: colorScheme.onSurface.withValues(alpha: 0.54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    initCategory: Category.SMILEYS,
                    backgroundColor: colorScheme.surface,
                    indicatorColor: colorScheme.primary,
                    iconColor: colorScheme.onSurface.withValues(alpha: 0.45),
                    iconColorSelected: colorScheme.primary,
                    backspaceColor: colorScheme.primary,
                    dividerColor: colorScheme.outlineVariant.withValues(
                      alpha: 0.46,
                    ),
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    enabled: true,
                    showBackspaceButton: false,
                    backgroundColor: colorScheme.surface,
                    buttonColor: colorScheme.primary,
                    buttonIconColor: colorScheme.onPrimary,
                  ),
                  skinToneConfig: SkinToneConfig(
                    dialogBackgroundColor: colorScheme.surface,
                    indicatorColor: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
