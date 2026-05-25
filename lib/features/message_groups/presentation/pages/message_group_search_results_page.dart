import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../../core/widgets/text/text.dart';
import '../../domain/entities/group_message.dart';
import '../controllers/message_group_search_controller.dart';

/// Argument truyền vào [MessageGroupSearchResultsPage].
class MessageGroupSearchResultsArgs {
  final String groupId;
  final String groupName;
  final String keyword;

  const MessageGroupSearchResultsArgs({
    required this.groupId,
    required this.groupName,
    required this.keyword,
  });
}

/// Trang hiển thị kết quả tìm kiếm tin nhắn trong nhóm.
///
/// Header là tên nhóm chat. Chỉ hiển thị kết quả, không có ô tìm kiếm lại.
/// Hỗ trợ load thêm (pagination) khi scroll tới cuối.
class MessageGroupSearchResultsPage extends ConsumerStatefulWidget {
  const MessageGroupSearchResultsPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.keyword,
  });

  final String groupId;
  final String groupName;
  final String keyword;

  @override
  ConsumerState<MessageGroupSearchResultsPage> createState() =>
      _MessageGroupSearchResultsPageState();
}

class _MessageGroupSearchResultsPageState
    extends ConsumerState<MessageGroupSearchResultsPage> {
  late final MessageGroupSearchController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize controller on first build when ref is available.
    if (!_initialized) {
      _controller = MessageGroupSearchController(
        searchUseCase: ref.read(searchGroupMessagesUseCaseProvider),
        groupId: widget.groupId,
        keyword: widget.keyword,
      );
      _controller.addListener(_onStateChanged);
      _controller.search();
      _initialized = true;
    }
  }

  bool _initialized = false;

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    // Load more when near the bottom
    if (currentScroll >= maxScroll - 200) {
      _controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = _controller.state;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            AppText(
              widget.groupName,
              size: AppTextSize.regular,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.onSurface,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            AppText(
              'Kết quả cho "${widget.keyword}"',
              size: AppTextSize.veryTiny,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.55),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AppScreenLayout(
          child: _buildBody(state, colorScheme),
        ),
      ),
    );
  }

  Widget _buildBody(MessageGroupSearchState state, ColorScheme colorScheme) {
    if (state.isLoading) {
      return Center(
        child: AppLoadingIndicator(color: colorScheme.primary, size: 24),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AppText(
            state.error!,
            size: AppTextSize.small,
            spacing: AppTextSpacing.normal,
            weight: AppTextWeight.regular,
            color: colorScheme.error,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: colorScheme.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 14),
            AppText(
              'Không tìm thấy kết quả',
              size: AppTextSize.regular,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.medium,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 6),
            AppText(
              'Thử tìm với từ khóa khác',
              size: AppTextSize.small,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.regular,
              color: colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: state.messages.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colorScheme.outlineVariant.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        if (index >= state.messages.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: AppLoadingIndicator(
                color: colorScheme.primary,
                size: 18,
                strokeWidth: 2,
              ),
            ),
          );
        }

        return _SearchResultTile(message: state.messages[index]);
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.message});

  final GroupMessage message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final senderName = message.senderFullName.isEmpty
        ? 'Người dùng'
        : message.senderFullName;
    final createdAt = message.createdAtUtc;
    final timeText = createdAt != null
        ? TimeUtils.formatVietnamTime(TimeUtils.toVietnamTime(createdAt))
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar placeholder
          CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
            child: AppText(
              _getInitial(senderName),
              size: AppTextSize.small,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        senderName,
                        size: AppTextSize.small,
                        spacing: AppTextSpacing.tight,
                        weight: AppTextWeight.bold,
                        color: colorScheme.onSurface,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      timeText,
                      size: AppTextSize.veryTiny,
                      spacing: AppTextSpacing.tight,
                      weight: AppTextWeight.regular,
                      color: colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppText(
                  message.content,
                  size: AppTextSize.small,
                  spacing: AppTextSpacing.normal,
                  weight: AppTextWeight.regular,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitial(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
