import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/text/text.dart';
import '../../../friends/presentation/controllers/friends_presence_state.dart';
import '../../domain/entities/group_message.dart';
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
        ref.watch(getMessageGroupDetailUseCaseProvider),
        ref.watch(appMessageProvider.notifier),
        ref.watch(meProfileProvider).valueOrNull?.id,
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
  final Set<String> _receivedMessageIds = <String>{};
  void Function()? _unsubscribeNewMessages;
  void Function()? _unsubscribeMessageGroupSeen;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messageGroupListProvider.notifier).load();
      ref.read(friendsPresenceNotifierProvider.notifier).load();
      unawaited(_subscribeRealtimeMessages());
      unawaited(_subscribeMessageGroupSeen());
    });
  }

  Future<void> _subscribeRealtimeMessages() async {
    await ref
        .read(subscribeNewMessagesRealtimeUseCaseProvider)
        .call(onMessage: _handleIncomingMessage);
    _unsubscribeNewMessages = ref
        .read(subscribeNewMessagesRealtimeUseCaseProvider)
        .unsubscribe();
  }

  Future<void> _subscribeMessageGroupSeen() async {
    await ref
        .read(subscribeMessageGroupSeenRealtimeUseCaseProvider)
        .call(
          onMessageGroupSeen: (groupId, lastSeenMessageId) {
            ref
                .read(messageGroupListProvider.notifier)
                .applyMessageGroupSeen(
                  groupId: groupId,
                  lastSeenMessageId: lastSeenMessageId,
                );
          },
        );
    _unsubscribeMessageGroupSeen = ref
        .read(subscribeMessageGroupSeenRealtimeUseCaseProvider)
        .unsubscribe();
  }

  void _handleIncomingMessage(GroupMessage message) {
    if (!_receivedMessageIds.add(message.id)) {
      return;
    }

    final meId = ref.read(meProfileProvider).valueOrNull?.id;
    final isFromMe = meId != null && meId == message.senderId;
    if (!isFromMe) {
      final sender = message.senderFullName.trim().isEmpty
          ? 'Tin nhan moi'
          : message.senderFullName.trim();
      final content = message.content.trim();
      final toast = content.isEmpty ? sender : '$sender: $content';
      ref.read(appMessageProvider.notifier).addInfo(toast);
    }

    final listNotifier = ref.read(messageGroupListProvider.notifier);
    listNotifier.applyIncomingMessage(message, isFromCurrentUser: isFromMe);
    final hasGroup = ref
        .read(messageGroupListProvider)
        .groups
        .any((g) => g.groupId == message.groupId);
    if (!hasGroup) {
      unawaited(listNotifier.refreshSilently());
    }
  }

  @override
  void dispose() {
    _unsubscribeNewMessages?.call();
    _unsubscribeNewMessages = null;
    _unsubscribeMessageGroupSeen?.call();
    _unsubscribeMessageGroupSeen = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(messageGroupListProvider);
    final presenceState = ref.watch(friendsPresenceNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: widget.onBackToHome ?? () => context.pop(),
        ),
        title: AppText(
          'Tin nhắn',
          size: AppTextSize.large,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AppScreenLayout(
          child: _buildBody(state, presenceState, colorScheme),
        ),
      ),
    );
  }

  Widget _buildBody(
    MessageGroupListState state,
    FriendsPresenceState presenceState,
    ColorScheme colorScheme,
  ) {
    switch (state.status) {
      case MessageGroupListStatus.initial:
      case MessageGroupListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MessageGroupListStatus.error:
        return Center(
          child: AppText(
            state.errorMessage ?? 'Đã xảy ra lỗi',
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
          itemCount: state.groups.length + 1,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            indent: 82,
            endIndent: 16,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _MessageGroupListHeader(count: state.groups.length);
            }

            final group = state.groups[index - 1];
            final peerUserId = state.peerUserIdByGroupId[group.groupId];
            final presence = presenceState.friendByUserId(peerUserId);
            return MessageGroupTile(
              group: group,
              isOnline: group.isPrivate ? presence?.isOnline ?? false : null,
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

class _MessageGroupListHeader extends StatelessWidget {
  const _MessageGroupListHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Hội thoại',
                  size: AppTextSize.large,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.bold,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(height: 4),
                AppText(
                  '$count cuộc trò chuyện',
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.regular,
                  color: colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
