import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/dropdown/dropdown.dart';
import '../../../../core/widgets/input/input.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../posts/domain/entities/post_visibility.dart';
import '../../domain/entities/feed_post.dart';

class EditPostResult {
  final String caption;
  final PostVisibility visibility;

  const EditPostResult({required this.caption, required this.visibility});
}

class FeedEditPostSheet extends StatefulWidget {
  const FeedEditPostSheet({super.key, required this.post});

  final FeedPost post;

  @override
  State<FeedEditPostSheet> createState() => _FeedEditPostSheetState();
}

class _FeedEditPostSheetState extends State<FeedEditPostSheet> {
  static const int _maxCaptionLength = 2000;

  late final TextEditingController _captionController;
  late PostVisibility _visibility;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.post.caption ?? '');
    _captionController.addListener(_handleCaptionChanged);
    _visibility = widget.post.visibility;
  }

  @override
  void dispose() {
    _captionController.removeListener(_handleCaptionChanged);
    _captionController.dispose();
    super.dispose();
  }

  void _handleCaptionChanged() {
    setState(() {});
  }

  void _submit() {
    Navigator.of(context).pop(
      EditPostResult(caption: _captionController.text, visibility: _visibility),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;
    final captionLength = _captionController.text.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Sửa bài đăng',
              size: AppTextSize.regular,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
            ),
            const SizedBox(height: 18),
            Input(
              height: 108,
              label: 'Caption',
              hintText: 'Nhập caption',
              rightCaption: '$captionLength/$_maxCaptionLength',
              controller: _captionController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              inputFormatters: [
                LengthLimitingTextInputFormatter(_maxCaptionLength),
              ],
            ),
            const SizedBox(height: 18),
            AppDropdown<PostVisibility>(
              labelText: 'Hiển thị',
              value: _visibility,
              items: const [
                AppDropdownItem(value: PostVisibility.friends, label: 'Bạn bè'),
                AppDropdownItem(
                  value: PostVisibility.private,
                  label: 'Riêng tư',
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _visibility = value;
                });
              },
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: Button(
                    text: 'Hủy',
                    type: ButtonType.outline,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Button(text: 'Lưu', onPressed: _submit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
