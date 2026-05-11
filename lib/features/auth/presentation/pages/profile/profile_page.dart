import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_routes.dart';
import '../../../../../core/providers/providers.dart';
import '../../../../../core/theme/color/app_colors.dart';
import '../../../../../core/theme/icons/app_icons.dart';
import '../../../../../core/widgets/app_settings_section.dart';
import '../../../../../core/widgets/app_settings_tile.dart';
import '../../../../../core/widgets/image/user_avatar.dart';
import '../../../../../core/widgets/layout/screen_layout.dart';
import '../../../../../core/widgets/text/text.dart';
import '../../controllers/profile_state.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key, this.onBackToHome});

  final VoidCallback? onBackToHome;

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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: widget.onBackToHome ?? () => context.pop(),
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
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
                      child: _ProfileSettingsList(
                        onEditProfile: () => context.pushNamed(
                          AppRoutes.editProfileName,
                          extra: profile,
                        ),
                        onOpenSafetySettings: () =>
                            context.pushNamed(AppRoutes.safetySettingsName),
                        onOpenAddFriends: () =>
                            context.pushNamed(AppRoutes.addFriendsName),
                        onLogout: () => context.goNamed(AppRoutes.logoutName),
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
              initialStyle: Theme.of(context).textTheme.headlineLarge,
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

class _ProfileSettingsList extends StatelessWidget {
  const _ProfileSettingsList({
    required this.onEditProfile,
    required this.onOpenSafetySettings,
    required this.onOpenAddFriends,
    required this.onLogout,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onOpenSafetySettings;
  final VoidCallback onOpenAddFriends;
  final VoidCallback onLogout;

  static const double _sectionSpacing = 26;
  static const double _bottomPadding = 32;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final destructiveColor = colorScheme.error;

    return ListView(
      padding: const EdgeInsets.only(bottom: _bottomPadding),
      children: [
        AppSettingsSection(
          title: 'Cá nhân',
          children: [
            AppSettingsTile(
              title: 'Thông tin cá nhân',
              leadingIcon: AppIcons.user,
              onTap: onEditProfile,
            ),
            AppSettingsTile(
              title: 'Thêm bạn bè',
              leadingIcon: AppIcons.users,
              onTap: onOpenAddFriends,
            ),
          ],
        ),
        const SizedBox(height: _sectionSpacing),
        AppSettingsSection(
          title: 'Thiết lập an toàn',
          children: [
            const AppSettingsTile(
              title: 'Người liên hệ khẩn cấp',
              leadingIcon: AppIcons.phoneCall,
              enabled: false,
            ),
            AppSettingsTile(
              title: 'Cài đặt Deadline',
              leadingIcon: AppIcons.clockCountdown,
              onTap: onOpenSafetySettings,
            ),
            AppSettingsTile(
              title: 'Thông báo & Cảnh báo',
              leadingIcon: AppIcons.notification,
              onTap: onOpenSafetySettings,
            ),
          ],
        ),
        const SizedBox(height: _sectionSpacing),
        const AppSettingsSection(
          title: 'Tài khoản & Hệ thống',
          children: [
            AppSettingsTile(
              title: 'Điều khoản dịch vụ',
              leadingIcon: AppIcons.fileText,
              enabled: false,
            ),
          ],
        ),
        const SizedBox(height: _sectionSpacing),
        AppSettingsTile(
          title: 'Đăng xuất',
          leadingIcon: AppIcons.signOut,
          textColor: destructiveColor,
          leadingIconColor: destructiveColor,
          trailingIconColor: destructiveColor,
          borderColor: destructiveColor.withValues(alpha: 0.42),
          onTap: onLogout,
        ),
      ],
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
