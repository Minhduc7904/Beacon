import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../controllers/group_chat_detail_notifier.dart';
import '../controllers/group_chat_detail_state.dart';
import '../widgets/detail/group_message_input_bar.dart';
import '../widgets/detail/group_message_list.dart';

final groupChatDetailProvider = StateNotifierProvider.autoDispose
    .family<GroupChatDetailNotifier, GroupChatDetailState, String>((
  ref,
  groupId,
) {
  return GroupChatDetailNotifier(
    groupId: groupId,
    getGroupMessagesUseCase: ref.watch(getGroupMessagesUseCaseProvider),
    getMessageGroupDetailUseCase: ref.watch(getMessageGroupDetailUseCaseProvider),
    sendGroupMessageUseCase: ref.watch(sendGroupMessageUseCaseProvider),
    messageNotifier: ref.watch(appMessageProvider.notifier),
  );
});

class GroupChatDetailPage extends ConsumerStatefulWidget {
  const GroupChatDetailPage({super.key, required this.group});

  final MessageGroup group;

  @override
  ConsumerState<GroupChatDetailPage> createState() => _GroupChatDetailPageState();
}

class _GroupChatDetailPageState extends ConsumerState<GroupChatDetailPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(groupChatDetailProvider(widget.group.groupId).notifier)
          .load()
          .then((_) => _scrollToBottom());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _title(GroupChatDetailState state) {
    final members = state.groupDetail?.members ?? const [];
    if (members.isNotEmpty) {
      if (members.length == 2) {
        final meId = ref.read(meProfileProvider).valueOrNull?.id;
        final peer = members.firstWhere(
          (m) => m.userId != meId,
          orElse: () => members.first,
        );
        final fullName =
            '${peer.familyName ?? ''} ${peer.givenName ?? ''}'.trim();
        if (fullName.isNotEmpty) {
          return fullName;
        }
        if (peer.username.trim().isNotEmpty) {
          return peer.username;
        }
      }

      return 'Nhóm ${members.length} thành viên';
    }

    final hint = widget.group.lastMessageSenderUsername?.trim();
    if (hint != null && hint.isNotEmpty) {
      return hint;
    }
    final gid = widget.group.groupId;
    final shortId = gid.length > 8 ? gid.substring(0, 8) : gid;
    return 'Nhom $shortId';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(groupChatDetailProvider(widget.group.groupId));
    final currentUserId = ref.watch(meProfileProvider).valueOrNull?.id;

    ref.listen(groupChatDetailProvider(widget.group.groupId), (prev, next) {
      if ((prev?.messages.length ?? 0) < next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(
              avatarUrl: null,
              givenName: _title(state),
              size: 34,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    _title(state),
                    size: AppTextSize.regular,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: colorScheme.onSurface,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    'Dang hoat dong',
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessages(state, colorScheme, currentUserId),
          ),
          GroupMessageInputBar(
            isSending: state.isSending,
            onSend: (text) {
              ref
                  .read(groupChatDetailProvider(widget.group.groupId).notifier)
                  .sendMessage(text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(
    GroupChatDetailState state,
    ColorScheme colorScheme,
    String? currentUserId,
  ) {
    switch (state.status) {
      case GroupChatDetailStatus.initial:
      case GroupChatDetailStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case GroupChatDetailStatus.error:
        return Center(
          child: AppText(
            state.errorMessage ?? 'Da xay ra loi',
            size: AppTextSize.small,
            spacing: AppTextSpacing.normal,
            weight: AppTextWeight.regular,
            color: colorScheme.error,
          ),
        );
      case GroupChatDetailStatus.loaded:
        return GroupMessageList(
          messages: state.messages,
          scrollController: _scrollController,
          currentUserId: currentUserId,
        );
    }
  }
}
