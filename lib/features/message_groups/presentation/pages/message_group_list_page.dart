import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../controllers/message_group_list_notifier.dart';
import '../controllers/message_group_list_state.dart';
import '../widgets/list/message_group_empty_state.dart';
import '../widgets/list/message_group_tile.dart';

final messageGroupListProvider =
    StateNotifierProvider.autoDispose<
      MessageGroupListNotifier,
      MessageGroupListState
    >((ref) {
      return MessageGroupListNotifier(
        ref.watch(getMessageGroupsUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
      );
    });

class MessageGroupListPage extends ConsumerStatefulWidget {
  const MessageGroupListPage({super.key, this.onBackToHome});

  final VoidCallback? onBackToHome;

  @override
  ConsumerState<MessageGroupListPage> createState() =>
      _MessageGroupListPageState();
}

class _MessageGroupListPageState extends ConsumerState<MessageGroupListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageGroupListProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(messageGroupListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: widget.onBackToHome ?? () => context.pop(),
        ),
        title: AppText(
          'Tin nhan',
          size: AppTextSize.large,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AppScreenLayout(child: _buildBody(state, colorScheme)),
      ),
    );
  }

  Widget _buildBody(MessageGroupListState state, ColorScheme colorScheme) {
    switch (state.status) {
      case MessageGroupListStatus.initial:
      case MessageGroupListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MessageGroupListStatus.error:
        return Center(
          child: AppText(
            state.errorMessage ?? 'Da xay ra loi',
            size: AppTextSize.small,
            spacing: AppTextSpacing.normal,
            weight: AppTextWeight.regular,
            color: colorScheme.error,
          ),
        );
      case MessageGroupListStatus.loaded:
        if (state.groups.isEmpty) {
          return const MessageGroupEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.groups.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            indent: 82,
            endIndent: 16,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          itemBuilder: (context, index) {
            final group = state.groups[index];
            return MessageGroupTile(
              group: group,
              onTap: () => _openDetail(group),
            );
          },
        );
    }
  }

  void _openDetail(MessageGroup group) {
    context.pushNamed(AppRoutes.chatDetailName, extra: group);
  }
}
