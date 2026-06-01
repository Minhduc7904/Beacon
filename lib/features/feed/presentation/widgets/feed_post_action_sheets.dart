import 'package:flutter/material.dart';

import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icon_data.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../../../../core/theme/text/app_text_theme.dart';
import '../../../../core/widgets/text/text.dart';

enum OwnerPostAction { reactions, edit, delete }

enum ViewerPostAction { report }

class ViewerPostActionSheet extends StatelessWidget {
  const ViewerPostActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Material(
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHandle(color: colorScheme.outline),
                const SizedBox(height: 12),
                _PostActionTile(
                  icon: AppIcons.warning,
                  label: 'Báo cáo',
                  color: colorScheme.error,
                  onTap: () =>
                      Navigator.of(context).pop(ViewerPostAction.report),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OwnerPostActionSheet extends StatelessWidget {
  const OwnerPostActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Material(
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHandle(color: colorScheme.outline),
                const SizedBox(height: 12),
                _PostActionTile(
                  icon: AppIcons.users,
                  label: 'Người đã react',
                  color: colorScheme.onSurface,
                  onTap: () =>
                      Navigator.of(context).pop(OwnerPostAction.reactions),
                ),
                _PostActionTile(
                  icon: AppIcons.pencil,
                  label: 'Sửa',
                  color: colorScheme.onSurface,
                  onTap: () => Navigator.of(context).pop(OwnerPostAction.edit),
                ),
                _PostActionTile(
                  icon: AppIcons.trash,
                  label: 'Xóa',
                  color: colorScheme.error,
                  onTap: () =>
                      Navigator.of(context).pop(OwnerPostAction.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _PostActionTile extends StatelessWidget {
  const _PostActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final AppIconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 54,
        child: Row(
          children: [
            AppIcon(icon, size: 22, color: color),
            const SizedBox(width: 14),
            AppText(
              label,
              size: AppTextSize.small,
              spacing: AppTextSpacing.tight,
              weight: AppTextWeight.medium,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
