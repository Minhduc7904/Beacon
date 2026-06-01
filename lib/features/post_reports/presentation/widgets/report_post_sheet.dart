import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/text/text.dart';

class ReportPostSheet extends ConsumerStatefulWidget {
  const ReportPostSheet({
    super.key,
    required this.postId,
    required this.authorName,
  });

  final String postId;
  final String authorName;

  @override
  ConsumerState<ReportPostSheet> createState() => _ReportPostSheetState();
}

class _ReportPostSheetState extends ConsumerState<ReportPostSheet> {
  static const int _maxDescriptionLength = 1000;
  static const String _otherReason = 'Khác';

  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedReason;

  static const List<String> _reportReasons = [
    'Nội dung không phù hợp',
    'Quấy rối hoặc bắt nạt',
    'Ngôn từ thù ghét',
    'Bạo lực hoặc đe dọa',
    'Ảnh nhạy cảm hoặc khỏa thân',
    'Spam hoặc lừa đảo',
    'Thông tin sai lệch',
    'Mạo danh người khác',
    'Xâm phạm quyền riêng tư',
    'Tự gây hại hoặc nguy hiểm',
    'Bán hàng hóa bị cấm',
    _otherReason,
  ];

  bool get _hasReason => _selectedReason != null;

  bool get _isOtherReason => _selectedReason == _otherReason;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_handleDescriptionChanged);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_handleDescriptionChanged);
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleDescriptionChanged() {
    setState(() {});
  }

  Future<void> _showReasonPicker() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => _ReasonPickerDialog(
        reasons: _reportReasons,
        selectedReason: _selectedReason,
      ),
    );

    if (!mounted || selected == null) {
      return;
    }

    if (selected != _otherReason) {
      _descriptionController.clear();
    }

    setState(() {
      _selectedReason = selected;
    });
  }

  Future<void> _submit() async {
    final state = ref.read(postReportNotifierProvider);
    final reason = _selectedReason;
    if (reason == null || state.isSubmitting) {
      return;
    }

    final didSubmit = await ref
        .read(postReportNotifierProvider.notifier)
        .submitReport(
          postId: widget.postId,
          reason: reason,
          description: _isOtherReason ? _descriptionController.text : null,
        );

    if (!mounted || !didSubmit) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final state = ref.watch(postReportNotifierProvider);
    final descriptionLength = _descriptionController.text.length;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Material(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AppText(
                  'Báo cáo bài đăng',
                  size: AppTextSize.regular,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: 6),
                AppText(
                  'Bài đăng của ${widget.authorName}',
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.normal,
                  weight: AppTextWeight.regular,
                  color: colorScheme.onSurface.withValues(alpha: 0.64),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 18),
                _ReasonDropdownButton(
                  value: _selectedReason,
                  onPressed: state.isSubmitting ? null : _showReasonPicker,
                ),
                if (_isOtherReason) ...[
                  const SizedBox(height: 16),
                  Input(
                    height: 112,
                    label: 'Mô tả thêm',
                    hintText: 'Nhập lý do cụ thể',
                    rightCaption: '$descriptionLength/$_maxDescriptionLength',
                    controller: _descriptionController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(_maxDescriptionLength),
                    ],
                  ),
                ],
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  AppText(
                    state.errorMessage!,
                    size: AppTextSize.small,
                    spacing: AppTextSpacing.normal,
                    weight: AppTextWeight.regular,
                    color: colorScheme.error,
                  ),
                ],
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Button(
                        text: 'Hủy',
                        type: ButtonType.outline,
                        onPressed: state.isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Button(
                        text: 'Gửi',
                        isLoading: state.isSubmitting,
                        state: _hasReason
                            ? ButtonState.defaultState
                            : ButtonState.disabled,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReasonDropdownButton extends StatelessWidget {
  const _ReasonDropdownButton({required this.value, required this.onPressed});

  final String? value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasValue = value != null && value!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          'Lý do',
          color: colorScheme.onSurface,
          size: AppTextSize.regular,
          spacing: AppTextSpacing.none,
          weight: AppTextWeight.bold,
        ),
        const SizedBox(height: 12),
        Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outline),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: AppText(
                      hasValue ? value! : 'Chọn lý do báo cáo',
                      size: AppTextSize.small,
                      spacing: AppTextSpacing.normal,
                      weight: hasValue
                          ? AppTextWeight.medium
                          : AppTextWeight.regular,
                      color: hasValue
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.55),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppIcon(
                    AppIcons.caretDown,
                    size: 20,
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReasonPickerDialog extends StatelessWidget {
  const _ReasonPickerDialog({
    required this.reasons,
    required this.selectedReason,
  });

  final List<String> reasons;
  final String? selectedReason;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      'Chọn lý do',
                      size: AppTextSize.regular,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: AppIcon(
                      AppIcons.close,
                      size: 20,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: reasons.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  itemBuilder: (context, index) {
                    final reason = reasons[index];
                    return _ReasonOptionTile(
                      label: reason,
                      isSelected: reason == selectedReason,
                      onTap: () => Navigator.of(context).pop(reason),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonOptionTile extends StatelessWidget {
  const _ReasonOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            _SelectionMark(isSelected: isSelected),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                label,
                size: AppTextSize.small,
                spacing: AppTextSpacing.tight,
                weight: isSelected ? AppTextWeight.bold : AppTextWeight.regular,
                color: isSelected ? selectedColor : colorScheme.onSurface,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionMark extends StatelessWidget {
  const _SelectionMark({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = isSelected
        ? colorScheme.primary
        : colorScheme.outline.withValues(alpha: 0.72);

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: isSelected
          ? Center(
              child: AppIcon(
                AppIcons.check,
                size: 15,
                color: colorScheme.onPrimary,
              ),
            )
          : null,
    );
  }
}
