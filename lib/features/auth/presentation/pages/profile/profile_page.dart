import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/text/app_text_theme.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../controllers/profile_state.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

  Future<void> _onChangeAvatarPressed(ProfileState state) async {
    if (state.isUpdatingAvatar) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }

    final filePath = result.files.single.path?.trim() ?? '';
    if (filePath.isEmpty) {
      ref
          .read(appMessageProvider.notifier)
          .addError('Không đọc được đường dẫn ảnh đã chọn');
      return;
    }

    await ref
        .read(profileNotifierProvider.notifier)
        .updateAvatar(filePath: filePath);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final profile = ref.watch(meProfileProvider).valueOrNull;
    final showLoading = profile == null && profileState.isLoadingProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: AppScreenLayout(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: showLoading
              ? const Center(child: CircularProgressIndicator())
              : profile == null
              ? _ProfileErrorState(
                  onRetry: () {
                    ref
                        .read(profileNotifierProvider.notifier)
                        .loadProfile(forceRefresh: true);
                  },
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileHeader(
                      fullName: profile.fullName,
                      email: profile.email,
                      avatarUrl: profile.avatarUrl,
                      givenName: profile.givenName,
                      isUpdatingAvatar: profileState.isUpdatingAvatar,
                      onChangeAvatar: () =>
                          _onChangeAvatarPressed(profileState),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        children: [
                          _ProfileMenuItem(
                            icon: Icons.person_outline_rounded,
                            title: 'Chỉnh sửa hồ sơ',
                            onTap: () => context.pushNamed(
                              AppRoutes.editProfileName,
                              extra: profile,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _ProfileMenuItem(
                            icon: Icons.security_rounded,
                            title: 'Cài đặt an toàn',
                            onTap: () =>
                                context.pushNamed(AppRoutes.safetySettingsName),
                          ),
                          const SizedBox(height: 10),
                          const _ProfileMenuItem(
                            icon: Icons.credit_card_rounded,
                            title: 'Phương thức thanh toán',
                          ),
                          const SizedBox(height: 10),
                          const _ProfileMenuItem(
                            icon: Icons.language_rounded,
                            title: 'Ngôn ngữ',
                          ),
                          const SizedBox(height: 10),
                          const _ProfileMenuItem(
                            icon: Icons.history_rounded,
                            title: 'Lịch sử đơn hàng',
                          ),
                          const SizedBox(height: 10),
                          const _ProfileMenuItem(
                            icon: Icons.group_add_rounded,
                            title: 'Mời bạn bè',
                          ),
                          const SizedBox(height: 10),
                          const _ProfileMenuItem(
                            icon: Icons.help_outline_rounded,
                            title: 'Trung tâm trợ giúp',
                          ),
                          const SizedBox(height: 10),
                          _ProfileMenuItem(
                            icon: Icons.logout_rounded,
                            title: 'Đăng xuất',
                            isDestructive: true,
                            onTap: () => context.goNamed(AppRoutes.logoutName),
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

class _ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String? avatarUrl;
  final String? givenName;
  final bool isUpdatingAvatar;
  final VoidCallback onChangeAvatar;

  const _ProfileHeader({
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.givenName,
    required this.isUpdatingAvatar,
    required this.onChangeAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = fullName.trim().isEmpty ? 'Người dùng' : fullName;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            UserAvatar(
              avatarUrl: avatarUrl,
              givenName: givenName,
              size: 110,
              initialStyle: Theme.of(context).textTheme.title2,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isUpdatingAvatar ? null : onChangeAvatar,
                  borderRadius: BorderRadius.circular(24),
                  child: Ink(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: isUpdatingAvatar
                        ? const Padding(
                            padding: EdgeInsets.all(9),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.sky100,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                            color: AppColors.sky100,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppText(
          displayName,
          preset: AppTextPreset.titleMedium,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        AppText(
          email,
          preset: AppTextPreset.bodySmall,
          color: AppColors.ink100,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleColor = isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: titleColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  title,
                  preset: AppTextPreset.bodyMedium,
                  color: titleColor,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ProfileErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText('Không thể tải thông tin hồ sơ'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}
