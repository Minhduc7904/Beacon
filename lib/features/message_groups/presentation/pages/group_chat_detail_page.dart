import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_member.dart';
import '../controllers/group_chat_detail_notifier.dart';
import '../controllers/group_chat_detail_state.dart';
import '../controllers/message_group_detail_provider.dart';
import '../widgets/detail/group_message_input_bar.dart';
import '../widgets/detail/group_message_list.dart';
import '../widgets/detail/pending_group_members_section.dart';

final groupChatDetailProvider = StateNotifierProvider.autoDispose
    .family<GroupChatDetailNotifier, GroupChatDetailState, String>((
      ref,
      groupId,
    ) {
      return GroupChatDetailNotifier(
        groupId: groupId,
        getGroupMessagesUseCase: ref.watch(getGroupMessagesUseCaseProvider),
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
      _loadChatDetail();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      final targetOffset = _scrollController.position.minScrollExtent;
      if (animated) {
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(targetOffset);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_scrollController.hasClients) {
          return;
        }

        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      });
    });
  }

  Future<void> _loadChatDetail() async {
    MessageGroupDetail? initialDetail;
    try {
      initialDetail = await ref.read(
        messageGroupDetailProvider(widget.group.groupId).future,
      );
    } catch (_) {}

    if (!mounted) {
      return;
    }

    await ref
        .read(groupChatDetailProvider(widget.group.groupId).notifier)
        .load(initialDetail: initialDetail);

    _scrollToBottom(animated: false);
  }

  String _title(GroupChatDetailState state) {
    final members = List<MessageGroupMember>.from(
      state.groupDetail?.members ?? const <MessageGroupMember>[],
    );
    final joinedMembers = members
        .where((member) => member.status.isJoined)
        .toList(growable: false);
    final displayMembers = joinedMembers.isNotEmpty ? joinedMembers : members;
    final detailDisplayName = state.groupDetail?.displayName?.trim();
    final listDisplayName = widget.group.displayName?.trim();

    if (!widget.group.isPrivate) {
      if (detailDisplayName != null && detailDisplayName.isNotEmpty) {
        return detailDisplayName;
      }
      if (listDisplayName != null && listDisplayName.isNotEmpty) {
        return listDisplayName;
      }
    }

    if (displayMembers.isNotEmpty) {
      if (displayMembers.length == 2) {
        final meId = ref.read(meProfileProvider).valueOrNull?.id;
        var peer = displayMembers.first;
        for (final member in displayMembers) {
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

      return 'Nhóm ${displayMembers.length} thành viên';
    }

    return widget.group.resolvedDisplayName;
  }

  void _openGroupInfo() {
    context.pushNamed(AppRoutes.messageGroupInfoName, extra: widget.group);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(groupChatDetailProvider(widget.group.groupId));
    ref.listen<AsyncValue<MessageGroupDetail>>(
      messageGroupDetailProvider(widget.group.groupId),
      (_, next) {
        next.whenData((detail) {
          ref
              .read(groupChatDetailProvider(widget.group.groupId).notifier)
              .setGroupDetail(detail);
        });
      },
    );
    final currentUserId = ref.watch(meProfileProvider).valueOrNull?.id;
    final presenceState = ref.watch(friendsPresenceNotifierProvider);
    final members = state.groupDetail?.members ?? const <MessageGroupMember>[];
    final joinedMembers = members
        .where((member) => member.status.isJoined)
        .toList(growable: false);
    final pendingMembers = members
        .where((member) => member.isPendingApproval)
        .toList(growable: false);
    final currentMember = _currentMember(members, currentUserId);
    final canManagePending = currentMember?.isAdminRole ?? false;
    final resolvedAvatarUrl =
        state.groupDetail?.displayAvatarUrl ?? widget.group.displayAvatarUrl;
    final peerUserId = _peerUserId(joinedMembers, currentUserId);
    final peerPresence = presenceState.friendByUserId(peerUserId);
    final isPeerOnline = widget.group.isPrivate
        ? peerPresence?.isOnline ?? false
        : null;
    final isPrivateChat =
        state.groupDetail?.isPrivate ?? widget.group.isPrivate;

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
                    _presenceLabel(isPeerOnline, joinedMembers.length),
                    size: AppTextSize.veryTiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: isPeerOnline == true
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (!isPrivateChat)
            IconButton(
              tooltip: 'Thông tin nhóm',
              icon: const AppIcon(AppIcons.info, size: 22),
              onPressed: _openGroupInfo,
            ),
        ],
      ),
      body: Column(
        children: [
          if (!isPrivateChat)
            PendingGroupMembersSection(
              groupId: widget.group.groupId,
              members: pendingMembers,
              canManage: canManagePending,
              onMemberApproved: (userId) {
                ref
                    .read(
                      groupChatDetailProvider(widget.group.groupId).notifier,
                    )
                    .updateMemberStatus(
                      userId: userId,
                      status: MessageGroupMemberStatus.joined,
                    );
              },
              onMemberDenied: (userId) {
                ref
                    .read(
                      groupChatDetailProvider(widget.group.groupId).notifier,
                    )
                    .removeMember(userId);
              },
            ),
          Expanded(
            child: SafeArea(
              bottom: false,
              child: AppScreenLayout(
                child: _buildMessages(
                  state,
                  colorScheme,
                  currentUserId,
                  joinedMembers,
                ),
              ),
            ),
          ),
          _TypingStatusBar(
            typingUserIds: state.typingUserIds,
            members: members,
          ),
          GroupMessageInputBar(
            isSending: state.isSending,
            onTypingChanged: (isTyping) {
              unawaited(
                ref
                    .read(
                      groupChatDetailProvider(widget.group.groupId).notifier,
                    )
                    .sendTypingStatus(isTyping),
              );
            },
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
    List<MessageGroupMember> members,
  ) {
    switch (state.status) {
      case GroupChatDetailStatus.initial:
      case GroupChatDetailStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case GroupChatDetailStatus.error:
        return Center(
          child: AppText(
            state.errorMessage ?? 'Đã xảy ra lỗi',
            size: AppTextSize.small,
            spacing: AppTextSpacing.normal,
            weight: AppTextWeight.regular,
            color: colorScheme.error,
          ),
        );
      case GroupChatDetailStatus.loaded:
        return GroupMessageList(
          messages: state.messages,
          members: members,
          scrollController: _scrollController,
          currentUserId: currentUserId,
          isPrivateChat: state.groupDetail?.isPrivate ?? widget.group.isPrivate,
        );
    }
  }

  String? _peerUserId(List<MessageGroupMember> members, String? currentUserId) {
    if (!widget.group.isPrivate) {
      return null;
    }

    for (final member in members) {
      if (member.userId != currentUserId) {
        return member.userId;
      }
    }
    return null;
  }

  MessageGroupMember? _currentMember(
    List<MessageGroupMember> members,
    String? currentUserId,
  ) {
    if (currentUserId == null || currentUserId.trim().isEmpty) {
      return null;
    }

    for (final member in members) {
      if (member.userId == currentUserId) {
        return member;
      }
    }
    return null;
  }

  String _presenceLabel(bool? isPeerOnline, int joinedCount) {
    if (!widget.group.isPrivate) {
      return joinedCount == 0 ? 'Nhóm chat' : '$joinedCount thành viên';
    }

    return isPeerOnline == true ? 'Đang hoạt động' : 'Không hoạt động';
  }
}

class _TypingStatusBar extends StatelessWidget {
  const _TypingStatusBar({required this.typingUserIds, required this.members});

  final List<String> typingUserIds;
  final List<MessageGroupMember> members;

  MessageGroupMember? get _typingMember {
    if (typingUserIds.isEmpty) {
      return null;
    }

    final typingUserId = typingUserIds.first;
    for (final member in members) {
      if (member.userId == typingUserId) {
        return member;
      }
    }
    return null;
  }

  String get _typingName {
    final fullName = _typingMember?.fullName.trim();
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }
    return 'Người dùng';
  }

  double _contentWidthForColumns(int columns) {
    return (AppScreenLayout.columnWidth * columns) +
        (AppScreenLayout.gutter * (columns - 1));
  }

  @override
  Widget build(BuildContext context) {
    if (typingUserIds.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final typingMember = _typingMember;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final isTablet = maxWidth >= AppScreenLayout.tabletBreakpoint;
        final columnCount = isTablet
            ? AppScreenLayout.tabletColumnCount
            : AppScreenLayout.mobileColumnCount;
        final designWidth = _contentWidthForColumns(columnCount);
        final safeWidth = math.max(
          0.0,
          maxWidth - AppScreenLayout.minHorizontalSafeInset * 2,
        );
        final layoutWidth = math.min(designWidth, safeWidth);

        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: layoutWidth,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserAvatar(
                    avatarUrl: typingMember?.avatarUrl,
                    givenName: _typingName,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    'Đang nhập...',
                    size: AppTextSize.tiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
