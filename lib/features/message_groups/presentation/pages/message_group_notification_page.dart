import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/switch_button/switch_button.dart';
import '../../../../core/widgets/text/text.dart';

class MessageGroupNotificationPageArgs {
  const MessageGroupNotificationPageArgs({
    required this.groupId,
    required this.isMuted,
  });

  final String groupId;
  final bool isMuted;
}

class MessageGroupNotificationPage extends ConsumerStatefulWidget {
  const MessageGroupNotificationPage({
    super.key,
    required this.groupId,
    required this.initialMuted,
  });

  final String groupId;
  final bool initialMuted;

  @override
  ConsumerState<MessageGroupNotificationPage> createState() =>
      _MessageGroupNotificationPageState();
}

class _MessageGroupNotificationPageState
    extends ConsumerState<MessageGroupNotificationPage> {
  late bool _isMuted;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _isMuted = widget.initialMuted;
  }

  Future<void> _toggleMute(bool value) async {
    if (_isUpdating) {
      return;
    }

    final previous = _isMuted;
    setState(() {
      _isMuted = value;
      _isUpdating = true;
    });

    final result = await ref.read(updateMessageGroupMuteUseCaseProvider).call(
          groupId: widget.groupId,
          isMuted: value,
        );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        ref.read(appMessageProvider.notifier).addError(failure.message);
        setState(() {
          _isMuted = previous;
          _isUpdating = false;
        });
      },
      (_) {
        ref.read(appMessageProvider.notifier).addSuccess(
              value ? 'Đã tắt thông báo' : 'Đã bật thông báo',
            );
        setState(() => _isUpdating = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          'Thông báo và âm thanh',
          size: AppTextSize.large,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AppScreenLayout(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView(
            children: [
              AppSwitchButton(
                label: 'Tắt thông báo',
                description:
                    'Bật để tạm dừng thông báo từ nhóm chat này.',
                value: _isMuted,
                onChanged: _isUpdating ? null : _toggleMute,
                enabled: !_isUpdating,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
