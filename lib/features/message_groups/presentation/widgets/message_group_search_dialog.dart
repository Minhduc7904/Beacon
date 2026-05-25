import 'package:flutter/material.dart';

import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/text/text.dart';

/// Dialog popup yêu cầu nhập từ khóa tìm kiếm tin nhắn trong nhóm.
///
/// Khi nhấn "Tìm kiếm", trả về từ khóa đã nhập qua `Navigator.pop(context, keyword)`.
/// Nếu nhấn "Hủy" hoặc dismiss, trả về `null`.
class MessageGroupSearchDialog extends StatefulWidget {
  const MessageGroupSearchDialog({super.key});

  /// Hiển thị dialog và trả về từ khóa tìm kiếm, hoặc `null` nếu hủy.
  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const MessageGroupSearchDialog(),
    );
  }

  @override
  State<MessageGroupSearchDialog> createState() =>
      _MessageGroupSearchDialogState();
}

class _MessageGroupSearchDialogState extends State<MessageGroupSearchDialog> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _submit() {
    final keyword = _controller.text.trim();
    if (keyword.isEmpty) {
      return;
    }
    Navigator.of(context).pop(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppIcon(
                  AppIcons.search,
                  size: 22,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    'Tìm kiếm tin nhắn',
                    size: AppTextSize.large,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            AppText(
              'Nhập từ khóa để tìm kiếm tin nhắn trong nhóm',
              size: AppTextSize.tiny,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 14),
            Input(
              hintText: 'Nhập từ khóa...',
              controller: _controller,
              focusNode: _focusNode,
              type: InputType.leftIcon,
              leftIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: AppText(
                    'Hủy',
                    size: AppTextSize.small,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.medium,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _hasText ? _submit : null,
                  child: AppText(
                    'Tìm kiếm',
                    size: AppTextSize.small,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: _hasText
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
