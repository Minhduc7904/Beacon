import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';
import '../controllers/conversation_list_notifier.dart';
import '../controllers/conversation_list_state.dart';
import '../widgets/list/conversation_empty_state.dart';
import '../widgets/list/conversation_tile.dart';

/// Provider for the conversation list notifier.
final conversationListProvider = StateNotifierProvider.autoDispose<
    ConversationListNotifier, ConversationListState>((ref) {
  return ConversationListNotifier();
});

/// The main message / conversations list page.
class MessageListPage extends ConsumerStatefulWidget {
  const MessageListPage({super.key});

  @override
  ConsumerState<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends ConsumerState<MessageListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationListProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(conversationListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          'Tin nhắn',
          size: AppTextSize.large,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                Icons.edit_square,
                size: 22,
                color: colorScheme.primary,
              ),
              onPressed: () {
                // TODO: new conversation — not yet implemented
              },
            ),
          ),
        ],
      ),
      body: _buildBody(state, colorScheme),
    );
  }

  Widget _buildBody(ConversationListState state, ColorScheme colorScheme) {
    switch (state.status) {
      case ConversationListStatus.initial:
      case ConversationListStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ConversationListStatus.error:
        return Center(
          child: AppText(
            state.errorMessage ?? 'Đã xảy ra lỗi',
            size: AppTextSize.small,
            spacing: AppTextSpacing.normal,
            weight: AppTextWeight.regular,
            color: colorScheme.error,
          ),
        );

      case ConversationListStatus.loaded:
        if (state.conversations.isEmpty) {
          return const ConversationEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.conversations.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            indent: 82,
            endIndent: 16,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          itemBuilder: (context, index) {
            final conv = state.conversations[index];
            return ConversationTile(
              conversation: conv,
              onTap: () {
                context.pushNamed(
                  AppRoutes.chatDetailName,
                  extra: conv,
                );
              },
            );
          },
        );
    }
  }
}
