import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/conversation.dart';
import '../controllers/chat_detail_notifier.dart';
import '../controllers/chat_detail_state.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/message_input_bar.dart';

/// Family provider — one notifier per conversation ID.
final chatDetailProvider = StateNotifierProvider.autoDispose
    .family<ChatDetailNotifier, ChatDetailState, String>((ref, conversationId) {
  return ChatDetailNotifier(conversationId: conversationId);
});

/// The individual chat / conversation detail page.
class ChatDetailPage extends ConsumerStatefulWidget {
  const ChatDetailPage({super.key, required this.conversation});

  final Conversation conversation;

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(chatDetailProvider(widget.conversation.id).notifier)
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(chatDetailProvider(widget.conversation.id));

    // Auto-scroll when new messages arrive
    ref.listen(chatDetailProvider(widget.conversation.id), (prev, next) {
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
              avatarUrl: widget.conversation.participantAvatarUrl,
              givenName: widget.conversation.participantName,
              size: 34,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    widget.conversation.participantName,
                    size: AppTextSize.regular,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.bold,
                    color: colorScheme.onSurface,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppText(
                    'Đang hoạt động',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                Icons.more_vert_rounded,
                color: colorScheme.onSurface,
              ),
              onPressed: () {
                // TODO: chat options menu
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Messages list ──
          Expanded(child: _buildMessages(state, colorScheme)),

          // ── Input bar ──
          MessageInputBar(
            isSending: state.isSending,
            onSend: (text) {
              ref
                  .read(chatDetailProvider(widget.conversation.id).notifier)
                  .sendMessage(text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessages(ChatDetailState state, ColorScheme colorScheme) {
    switch (state.status) {
      case ChatDetailStatus.initial:
      case ChatDetailStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ChatDetailStatus.error:
        return Center(
          child: AppText(
            state.errorMessage ?? 'Đã xảy ra lỗi',
            size: AppTextSize.small,
            spacing: AppTextSpacing.normal,
            weight: AppTextWeight.regular,
            color: colorScheme.error,
          ),
        );

      case ChatDetailStatus.loaded:
        return ChatMessageList(
          messages: state.messages,
          scrollController: _scrollController,
        );
    }
  }
}
