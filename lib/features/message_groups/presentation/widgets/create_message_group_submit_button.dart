import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/button/button.dart';
import '../../domain/entities/message_group_detail.dart';

class CreateMessageGroupSubmitButton extends ConsumerStatefulWidget {
  const CreateMessageGroupSubmitButton({
    super.key,
    required this.memberUserIds,
    this.onCreated,
  });

  final Set<String> memberUserIds;
  final Future<void> Function(MessageGroupDetail group)? onCreated;

  @override
  ConsumerState<CreateMessageGroupSubmitButton> createState() =>
      _CreateMessageGroupSubmitButtonState();
}

class _CreateMessageGroupSubmitButtonState
    extends ConsumerState<CreateMessageGroupSubmitButton> {
  bool _isCreating = false;

  Future<void> _submit() async {
    if (_isCreating || widget.memberUserIds.isEmpty) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    final result = await ref
        .read(createMessageGroupUseCaseProvider)
        .call(memberUserIds: widget.memberUserIds.toList(growable: false));

    if (!mounted) {
      return;
    }

    await result.fold(
      (failure) async {
        ref.read(appMessageProvider.notifier).addError(failure.message);
      },
      (group) async {
        ref.read(appMessageProvider.notifier).addSuccess('Đã tạo nhóm chat');
        await widget.onCreated?.call(group);
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
    );

    if (mounted) {
      setState(() {
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCount = widget.memberUserIds.length;
    final canSubmit = selectedCount > 0 && !_isCreating;

    return Button(
      text: selectedCount == 0 ? 'Tạo' : 'Tạo ($selectedCount)',
      state: canSubmit ? ButtonState.defaultState : ButtonState.disabled,
      isLoading: _isCreating,
      loadingText: 'Đang tạo',
      onPressed: canSubmit ? _submit : null,
    );
  }
}
