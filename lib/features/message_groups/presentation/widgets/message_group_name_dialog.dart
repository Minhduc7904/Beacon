import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/text/text.dart';

class MessageGroupNameDialog extends ConsumerStatefulWidget {
  const MessageGroupNameDialog({
    super.key,
    required this.groupId,
    required this.initialName,
    this.onUpdated,
  });

  final String groupId;
  final String initialName;
  final VoidCallback? onUpdated;

  @override
  ConsumerState<MessageGroupNameDialog> createState() =>
      _MessageGroupNameDialogState();
}

class _MessageGroupNameDialogState
    extends ConsumerState<MessageGroupNameDialog> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      ref
          .read(appMessageProvider.notifier)
          .addError('Vui lòng nhập tên nhóm');
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await ref
        .read(updateMessageGroupNameUseCaseProvider)
        .call(groupId: widget.groupId, name: trimmed);

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      },
      (_) {
        ref
            .read(appMessageProvider.notifier)
            .addSuccess('Đã cập nhật tên nhóm');
        widget.onUpdated?.call();
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      },
    );
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
            AppText(
              'Đổi tên nhóm',
              size: AppTextSize.large,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: 6),
            AppText(
              'Tên nhóm tối đa 100 ký tự',
              size: AppTextSize.tiny,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 14),
            Input(
              labelText: 'Tên nhóm',
              hintText: 'Nhập tên nhóm',
              controller: _controller,
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
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
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? AppLoadingIndicator(
                          color: colorScheme.primary,
                          size: 16,
                          strokeWidth: 2,
                        )
                      : AppText(
                          'Lưu',
                          size: AppTextSize.small,
                          spacing: AppTextSpacing.tight,
                          weight: AppTextWeight.bold,
                          color: colorScheme.primary,
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
