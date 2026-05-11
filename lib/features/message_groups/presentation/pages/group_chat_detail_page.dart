import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_member.dart';
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
        getMessageGroupDetailUseCase: ref.watch(
          getMessageGroupDetailUseCaseProvider,
        ),
        sendGroupMessageUseCase: ref.watch(sendGroupMessageUseCaseProvider),
        markMessageGroupSeenUseCase: ref.watch(
          markMessageGroupSeenUseCaseProvider,
        ),
        messageNotifier: ref.watch(appMessageProvider.notifier),
        joinMessageGroupRealtimeUseCase: ref.watch(
          joinMessageGroupRealtimeUseCaseProvider,
        ),
        leaveMessageGroupRealtimeUseCase: ref.watch(
          leaveMessageGroupRealtimeUseCaseProvider,
        ),
        sendTypingStatusRealtimeUseCase: ref.watch(
          sendTypingStatusRealtimeUseCaseProvider,
        ),
        subscribeMessageSeenStatusRealtimeUseCase: ref.watch(
          subscribeMessageSeenStatusRealtimeUseCaseProvider,
        ),
        subscribeTypingStatusRealtimeUseCase: ref.watch(
          subscribeTypingStatusRealtimeUseCaseProvider,
        ),
        currentUserId: ref.watch(meProfileProvider).valueOrNull?.id,
      );
    });

class GroupChatDetailPage extends ConsumerStatefulWidget {
  const GroupChatDetailPage({super.key, required this.group});

  final MessageGroup group;

  @override
  ConsumerState<GroupChatDetailPage> createState() =>
      _GroupChatDetailPageState();
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
    final members = List<MessageGroupMember>.from(
      state.groupDetail?.members ?? const <MessageGroupMember>[],
    );
    if (members.isNotEmpty) {
      if (members.length == 2) {
        final meId = ref.read(meProfileProvider).valueOrNull?.id;
        var peer = members.first;
        for (final member in members) {
          if (member.userId != meId) {
            peer = member;
            break;
          }
        }
        final fullName = peer.fullName;
        if (fullName.isNotEmpty) {
          return fullName;
        }
      }

      return 'Nhóm ${members.length} thành viên';
    }

    return widget.group.resolvedDisplayName;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(groupChatDetailProvider(widget.group.groupId));
    final currentUserId = ref.watch(meProfileProvider).valueOrNull?.id;
    final resolvedAvatarUrl =
        state.groupDetail?.displayAvatarUrl ?? widget.group.displayAvatarUrl;

    ref.listen(groupChatDetailProvider(widget.group.groupId), (prev, next) {
      if ((prev?.messages.length ?? 0) < next.messages.length) {
        _scrollToBottom();
      }
    });

    final typingText = _typingText(state);

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
              avatarUrl: resolvedAvatarUrl,
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
                    typingText,
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: typingText == 'Dang nhap...'
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: AppScreenLayout(
          child: Column(
            children: [
              Expanded(
                child: _buildMessages(state, colorScheme, currentUserId),
              ),
              GroupMessageInputBar(
                isSending: state.isSending,
                onTypingChanged: (isTyping) {
                  unawaited(
                    ref
                        .read(
                          groupChatDetailProvider(
                            widget.group.groupId,
                          ).notifier,
                        )
                        .sendTypingStatus(isTyping),
                  );
                },
                onSend: (text) {
                  ref
                      .read(
                        groupChatDetailProvider(widget.group.groupId).notifier,
                      )
                      .sendMessage(text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typingText(GroupChatDetailState state) {
    return state.typingUserIds.isNotEmpty ? 'Dang nhap...' : 'Dang hoat dong';
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
          members: state.groupDetail?.members ?? const [],
          scrollController: _scrollController,
          currentUserId: currentUserId,
        );
    }
  }
}
