import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_member.dart';
import '../widgets/message_group_member_nickname_dialog.dart';

final messageGroupNicknamesProvider = FutureProvider.autoDispose
    .family<MessageGroupDetail, MessageGroup>((ref, group) async {
      final result = await ref
          .watch(getMessageGroupDetailUseCaseProvider)
          .call(groupId: group.groupId);

      return result.fold((failure) => throw failure, (detail) => detail);
    });

class MessageGroupNicknamesPage extends ConsumerWidget {
  const MessageGroupNicknamesPage({super.key, required this.group});

  final MessageGroup group;

  Future<void> _openNicknameDialog(
    BuildContext context,
    WidgetRef ref,
    MessageGroupMember member,
  ) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => MessageGroupMemberNicknameDialog(
        groupId: group.groupId,
        member: member,
        onUpdated: () {
          ref.invalidate(messageGroupNicknamesProvider(group));
        },
      ),
    );

    if (updated == true) {
      ref.invalidate(messageGroupNicknamesProvider(group));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final detailAsync = ref.watch(messageGroupNicknamesProvider(group));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: AppText(
          'Biệt danh',
          size: AppTextSize.large,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AppScreenLayout(
          child: detailAsync.when(
            loading: () => Center(
              child: AppLoadingIndicator(color: colorScheme.primary, size: 24),
            ),
            error: (error, _) => Center(
              child: AppText(
                'Không thể tải biệt danh thành viên',
                size: AppTextSize.small,
                spacing: AppTextSpacing.normal,
                weight: AppTextWeight.regular,
                color: colorScheme.error,
                textAlign: TextAlign.center,
              ),
            ),
            data: (detail) {
              final joinedMembers = detail.members
                  .where((member) => member.status.isJoined)
                  .toList(growable: false);
              return _NicknameMemberList(
                members: joinedMembers,
                onMemberTap: (member) =>
                    _openNicknameDialog(context, ref, member),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NicknameMemberList extends StatelessWidget {
  const _NicknameMemberList({
    required this.members,
    required this.onMemberTap,
  });

  final List<MessageGroupMember> members;
  final ValueChanged<MessageGroupMember> onMemberTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (members.isEmpty) {
      return Center(
        child: AppText(
          'Chưa có thành viên',
          size: AppTextSize.small,
          spacing: AppTextSpacing.normal,
          weight: AppTextWeight.regular,
          color: colorScheme.onSurface.withValues(alpha: 0.58),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: members.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        indent: 58,
        color: colorScheme.outline.withValues(alpha: 0.16),
      ),
      itemBuilder: (context, index) {
        final member = members[index];
        return _NicknameMemberTile(
          member: member,
          onTap: () => onMemberTap(member),
        );
      },
    );
  }
}

class _NicknameMemberTile extends StatelessWidget {
  const _NicknameMemberTile({required this.member, required this.onTap});

  final MessageGroupMember member;
  final VoidCallback onTap;

  String get _fullName {
    final fullName = member.fullName.trim();
    return fullName.isEmpty ? 'Người dùng' : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customName = member.customName?.trim();
    final hasCustomName = customName != null && customName.isNotEmpty;
    final nicknameLabel = hasCustomName ? customName : 'Đặt biệt danh';

    return Material(
      color: colorScheme.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              UserAvatar(
                avatarUrl: member.avatarUrl,
                givenName: _fullName,
                size: 46,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      nicknameLabel,
                      size: AppTextSize.regular,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.medium,
                      color: hasCustomName
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.48),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    AppText(
                      _fullName,
                      size: AppTextSize.veryTiny,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.regular,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
