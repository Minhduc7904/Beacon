import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group_member.dart';

class MessageGroupMemberNicknameDialog extends ConsumerStatefulWidget {
  const MessageGroupMemberNicknameDialog({
    super.key,
    required this.groupId,
    required this.member,
    this.onUpdated,
  });

  final String groupId;
  final MessageGroupMember member;
  final VoidCallback? onUpdated;

  @override
  ConsumerState<MessageGroupMemberNicknameDialog> createState() =>
      _MessageGroupMemberNicknameDialogState();
}

class _MessageGroupMemberNicknameDialogState
    extends ConsumerState<MessageGroupMemberNicknameDialog> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.member.customName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyCustomName({
    required String? customName,
    required String successMessage,
  }) async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await ref
        .read(updateMessageGroupMemberCustomNameUseCaseProvider)
        .call(
          groupId: widget.groupId,
          userId: widget.member.userId,
          customName: customName,
        );

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      },
      (_) {
        ref.read(appMessageProvider.notifier).addSuccess(successMessage);
        widget.onUpdated?.call();
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      },
    );
  }

  Future<void> _submitNickname() async {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      ref
          .read(appMessageProvider.notifier)
          .addError('Vui lòng nhập biệt danh');
      return;
    }

    await _applyCustomName(
      customName: trimmed,
      successMessage: 'Đã cập nhật biệt danh',
    );
  }

  Future<void> _removeNickname() async {
    await _applyCustomName(
      customName: null,
      successMessage: 'Đã gỡ biệt danh',
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
              'Chỉnh sửa biệt danh',
              size: AppTextSize.large,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: 6),
            AppText(
              'Mọi người trong cuộc trò chuyện cũng sẽ thấy biệt hiệu này',
              size: AppTextSize.tiny,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 14),
            Input(
              labelText: 'Biệt danh',
              hintText: 'Nhập biệt danh',
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
                  onPressed: _isSubmitting ? null : _removeNickname,
                  child: AppText(
                    'Gỡ',
                    size: AppTextSize.small,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.medium,
                    color: AppColors.red500,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _isSubmitting ? null : _submitNickname,
                  child: _isSubmitting
                      ? AppLoadingIndicator(
                          color: colorScheme.primary,
                          size: 16,
                          strokeWidth: 2,
                        )
                      : AppText(
                          'Đặt',
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
