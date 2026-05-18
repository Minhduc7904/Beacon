import 'package:flutter/material.dart';

import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/utils/time_utils.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../../../posts/domain/entities/post.dart';
import '../../../domain/entities/group_message.dart';
import '../../../domain/entities/message_group_member.dart';
import 'group_chat_bubble.dart';
import 'group_message_seen_indicator.dart';

class GroupMessageList extends StatefulWidget {
  const GroupMessageList({
    super.key,
    required this.messages,
    required this.members,
    required this.scrollController,
    required this.currentUserId,
    required this.isPrivateChat,
  });

  final List<GroupMessage> messages;
  final List<MessageGroupMember> members;
  final ScrollController scrollController;
  final String? currentUserId;
  final bool isPrivateChat;

  @override
  State<GroupMessageList> createState() => _GroupMessageListState();
}

class _GroupMessageListState extends State<GroupMessageList>
    with SingleTickerProviderStateMixin {
  static const double _timeRevealDistance = 72;
  static const double _timeRevealShift = 72;

  late final AnimationController _timeRevealController;

  @override
  void initState() {
    super.initState();
    _timeRevealController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 140),
        )..addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
  }

  @override
  void dispose() {
    _timeRevealController.dispose();
    super.dispose();
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    _timeRevealController.stop();
    final nextValue =
        _timeRevealController.value - details.delta.dx / _timeRevealDistance;
    _timeRevealController.value = nextValue.clamp(0.0, 1.0);
  }

  void _handleHorizontalDragEnd([DragEndDetails? _]) {
    _timeRevealController.animateTo(
      0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 160),
    );
  }

  Map<String, List<GroupMessage>> _groupByDate() {
    final groups = <String, List<GroupMessage>>{};

    for (final msg in widget.messages) {
      final dt = msg.createdAtUtc ?? DateTime.now().toUtc();
      final vietnamTime = TimeUtils.toVietnamTime(dt);
      final key = _dateLabel(vietnamTime);
      groups.putIfAbsent(key, () => []).add(msg);
    }

    return groups;
  }

  String _dateLabel(DateTime vietnamTime) {
    final now = TimeUtils.nowVietnam();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(vietnamTime.year, vietnamTime.month, vietnamTime.day);
    final diff = today.difference(date).inDays;

    if (diff == 0) return 'Hom nay';
    if (diff == 1) return 'Hom qua';
    return TimeUtils.formatDate(vietnamTime);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.messages.isEmpty) {
      return Center(
        child: AppText(
          'Chưa có tin nhắn nào.\nHãy bắt đầu cuộc trò chuyện!',
          size: AppTextSize.small,
          spacing: AppTextSpacing.normal,
          weight: AppTextWeight.regular,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
          textAlign: TextAlign.center,
        ),
      );
    }

    final groups = _groupByDate();
    final entries = groups.entries.toList();
    final seenByMessageId = _buildSeenByMessageId();

    final items = <_GroupListItem>[];
    for (final entry in entries) {
      items.add(_GroupListItem.header(entry.key));
      items.addAll(_buildMessageItems(entry.value));
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: _handleHorizontalDragUpdate,
      onHorizontalDragEnd: _handleHorizontalDragEnd,
      onHorizontalDragCancel: _handleHorizontalDragEnd,
      child: Stack(
        children: [
          ListView.builder(
            controller: widget.scrollController,
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[items.length - 1 - index];
              if (item.isHeader) {
                return Transform.translate(
                  offset: Offset(
                    -_timeRevealShift * _timeRevealController.value,
                    0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.6,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText(
                          item.headerText!,
                          size: AppTextSize.veryTiny,
                          spacing: AppTextSpacing.tight,
                          weight: AppTextWeight.medium,
                          color: colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ),
                  ),
                );
              }

              final contentShift =
                  _timeRevealShift * _timeRevealController.value;
              if (item.thread != null) {
                return _PostMessageThread(
                  thread: item.thread!,
                  seenByMessageId: seenByMessageId,
                  currentUserId: widget.currentUserId,
                  isPrivateChat: widget.isPrivateChat,
                  timeRevealProgress: _timeRevealController.value,
                  contentShift: contentShift,
                );
              }

              return _MessageWithSeenIndicator(
                message: item.message!,
                seenMembers: seenByMessageId[item.message!.id] ?? const [],
                currentUserId: widget.currentUserId,
                isPrivateChat: widget.isPrivateChat,
                timeRevealProgress: _timeRevealController.value,
                contentShift: contentShift,
              );
            },
          ),
        ],
      ),
    );
  }

  Map<String, List<MessageGroupMember>> _buildSeenByMessageId() {
    final messageIndexById = <String, int>{};
    for (var i = 0; i < widget.messages.length; i++) {
      messageIndexById[widget.messages[i].id] = i;
    }

    final seenByMessageId = <String, List<MessageGroupMember>>{};
    for (final member in widget.members) {
      if (member.userId == widget.currentUserId) {
        continue;
      }
      final seenId = member.lastSeenMessageId;
      if (seenId == null || seenId.isEmpty) {
        continue;
      }
      final seenIndex = messageIndexById[seenId];
      if (seenIndex == null) {
        continue;
      }
      final seenMessageId = widget.messages[seenIndex].id;
      seenByMessageId.putIfAbsent(seenMessageId, () => []).add(member);
    }
    return seenByMessageId;
  }

  List<_GroupListItem> _buildMessageItems(List<GroupMessage> messages) {
    final items = <_GroupListItem>[];
    var index = 0;

    while (index < messages.length) {
      final message = messages[index];
      final postId = message.postId?.trim();
      final post = message.post;
      if (postId == null || postId.isEmpty || post == null) {
        items.add(_GroupListItem.message(message));
        index += 1;
        continue;
      }

      final threadMessages = <GroupMessage>[message];
      index += 1;
      while (index < messages.length) {
        final next = messages[index];
        if (next.postId?.trim() != postId) {
          break;
        }
        threadMessages.add(next);
        index += 1;
      }

      items.add(
        _GroupListItem.thread(
          _PostMessageThreadData(post: post, messages: threadMessages),
        ),
      );
    }

    return items;
  }
}

class _MessageWithSeenIndicator extends StatelessWidget {
  const _MessageWithSeenIndicator({
    required this.message,
    required this.seenMembers,
    required this.currentUserId,
    required this.isPrivateChat,
    required this.timeRevealProgress,
    required this.contentShift,
  });

  final GroupMessage message;
  final List<MessageGroupMember> seenMembers;
  final String? currentUserId;
  final bool isPrivateChat;
  final double timeRevealProgress;
  final double contentShift;

  bool get _isMine =>
      currentUserId != null && currentUserId == message.senderId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GroupChatBubble(
          message: message,
          currentUserId: currentUserId,
          timeRevealProgress: timeRevealProgress,
          contentShift: contentShift,
        ),
        if (_isMine && seenMembers.isNotEmpty)
          GroupMessageSeenIndicator(
            seenMembers: seenMembers,
            isPrivateChat: isPrivateChat,
            contentShift: contentShift,
          ),
      ],
    );
  }
}

class _PostMessageThread extends StatelessWidget {
  const _PostMessageThread({
    required this.thread,
    required this.seenByMessageId,
    required this.currentUserId,
    required this.isPrivateChat,
    required this.timeRevealProgress,
    required this.contentShift,
  });

  final _PostMessageThreadData thread;
  final Map<String, List<MessageGroupMember>> seenByMessageId;
  final String? currentUserId;
  final bool isPrivateChat;
  final double timeRevealProgress;
  final double contentShift;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MessagePostPreview(post: thread.post, currentUserId: currentUserId),
          const SizedBox(height: 8),
          for (final message in thread.messages)
            if (message.content.trim().isNotEmpty)
              _MessageWithSeenIndicator(
                message: message,
                seenMembers: seenByMessageId[message.id] ?? const [],
                currentUserId: currentUserId,
                isPrivateChat: isPrivateChat,
                timeRevealProgress: timeRevealProgress,
                contentShift: contentShift,
              ),
        ],
      ),
    );
  }
}

class _MessagePostPreview extends StatelessWidget {
  const _MessagePostPreview({required this.post, required this.currentUserId});

  final Post post;
  final String? currentUserId;

  String get _authorName {
    final name = post.owner?.displayName.trim();
    if (name == null || name.isEmpty) {
      return 'Người dùng';
    }
    return name;
  }

  String get _imageUrl {
    final thumbnail = post.media.thumbnailUrl?.trim();
    if (thumbnail != null && thumbnail.isNotEmpty) {
      return thumbnail;
    }
    return post.media.url.trim();
  }

  String get _displayName {
    if (currentUserId != null && currentUserId == post.ownerUserId) {
      return 'Tôi';
    }

    return _authorName;
  }

  String _formatTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime.toLocal());
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  @override
  Widget build(BuildContext context) {
    final caption = post.caption?.trim() ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    color: Colors.white70,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: AppText(
                    'Không thể tải ảnh',
                    size: AppTextSize.tiny,
                    spacing: AppTextSpacing.tight,
                    weight: AppTextWeight.regular,
                    color: Colors.white70,
                  ),
                );
              },
            ),
            Positioned(
              left: 12,
              top: 12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 5, 12, 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserAvatar(
                        avatarUrl: post.owner?.avatarUrl,
                        givenName: _displayName,
                        size: 30,
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 180),
                        child: AppText(
                          _displayName,
                          size: AppTextSize.tiny,
                          spacing: AppTextSpacing.tight,
                          weight: AppTextWeight.bold,
                          color: Colors.white,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppText(
                        _formatTime(post.createdAtUtc),
                        size: AppTextSize.veryTiny,
                        spacing: AppTextSpacing.tight,
                        weight: AppTextWeight.regular,
                        color: Colors.white.withValues(alpha: 0.74),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (caption.isNotEmpty)
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.48),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: AppText(
                        caption,
                        size: AppTextSize.small,
                        spacing: AppTextSpacing.normal,
                        weight: AppTextWeight.medium,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GroupListItem {
  final GroupMessage? message;
  final _PostMessageThreadData? thread;
  final String? headerText;

  bool get isHeader => headerText != null;

  _GroupListItem.message(GroupMessage value)
    : message = value,
      thread = null,
      headerText = null;

  _GroupListItem.thread(_PostMessageThreadData value)
    : message = null,
      thread = value,
      headerText = null;

  _GroupListItem.header(String value)
    : message = null,
      thread = null,
      headerText = value;
}

class _PostMessageThreadData {
  const _PostMessageThreadData({required this.post, required this.messages});

  final Post post;
  final List<GroupMessage> messages;
}
