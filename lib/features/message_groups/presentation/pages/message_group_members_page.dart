import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/image/user_avatar.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/message_group.dart';
import '../../domain/entities/message_group_detail.dart';
import '../../domain/entities/message_group_member.dart';
import 'message_group_add_members_page.dart';

class MessageGroupMembersPageArgs {
  const MessageGroupMembersPageArgs({
    required this.group,
    required this.detail,
  });

  final MessageGroup group;
  final MessageGroupDetail detail;
}

class MessageGroupMembersPage extends StatelessWidget {
  const MessageGroupMembersPage({
    super.key,
    required this.group,
    required this.detail,
  });

  final MessageGroup group;
  final MessageGroupDetail detail;

  @override
  Widget build(BuildContext context) {
    final members = detail.members;
    final admins = members
        .where((member) => member.isAdminRole)
        .toList(growable: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => context.pop(),
          ),
          title: _MembersHeaderTitle(count: members.length),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                final added = await context.pushNamed<bool>(
                  AppRoutes.messageGroupAddMembersName,
                  extra: MessageGroupAddMembersPageArgs(
                    group: group,
                    detail: detail,
                  ),
                );

                if (added == true && context.mounted) {
                  context.pop(true);
                }
              },
              child: const AppText(
                'Thêm',
                size: AppTextSize.small,
                spacing: AppTextSpacing.tight,
                weight: AppTextWeight.bold,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Quản trị viên'),
            ],
          ),
        ),
        body: SafeArea(
          child: AppScreenLayout(
            child: TabBarView(
              children: [
                _MembersList(members: members),
                _MembersList(
                  members: admins,
                  emptyText: 'Chưa có quản trị viên',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MembersHeaderTitle extends StatelessWidget {
  const _MembersHeaderTitle({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          'Thành viên',
          size: AppTextSize.regular,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.bold,
          color: colorScheme.onSurface,
        ),
        const SizedBox(height: 2),
        AppText(
          '$count thành viên',
          size: AppTextSize.veryTiny,
          spacing: AppTextSpacing.tight,
          weight: AppTextWeight.regular,
          color: colorScheme.onSurface.withValues(alpha: 0.56),
        ),
      ],
    );
  }
}

class _MembersList extends StatelessWidget {
  const _MembersList({
    required this.members,
    this.emptyText = 'Chưa có thành viên',
  });

  final List<MessageGroupMember> members;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (members.isEmpty) {
      return Center(
        child: AppText(
          emptyText,
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
        return _MemberTile(member: members[index]);
      },
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final MessageGroupMember member;

  String get _name {
    final fullName = member.fullName.trim();
    return fullName.isEmpty ? 'Người dùng' : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          UserAvatar(avatarUrl: member.avatarUrl, givenName: _name, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  _name,
                  size: AppTextSize.regular,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.medium,
                  color: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                AppText(
                  member.roleLabelVi,
                  size: AppTextSize.veryTiny,
                  spacing: AppTextSpacing.tight,
                  weight: AppTextWeight.regular,
                  color: member.isAdminRole
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.56),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
