import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/input/input.dart';

class PostPreviewCaptionInput extends ConsumerStatefulWidget {
  const PostPreviewCaptionInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  ConsumerState<PostPreviewCaptionInput> createState() =>
      _PostPreviewCaptionInputState();
}

class _PostPreviewCaptionInputState
    extends ConsumerState<PostPreviewCaptionInput> {
  static const int _maxCaptionLength = 2000;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleCaptionChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleCaptionChanged);
    super.dispose();
  }

  void _handleCaptionChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isUploading = ref.watch(
      postPreviewNotifierProvider.select((value) => value.isUploading),
    );
    final length = widget.controller.text.length;

    return Input(
      height: 92,
      label: 'Caption',
      hintText: 'Thêm caption cho bài đăng',
      rightCaption: '$length/$_maxCaptionLength',
      controller: widget.controller,
      enabled: !isUploading,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      inputFormatters: [LengthLimitingTextInputFormatter(_maxCaptionLength)],
      state: isUploading ? InputState.disabled : InputState.defaultState,
    );
  }
}
