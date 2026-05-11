import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/theme/icons/app_icon.dart';
import '../../../../core/theme/icons/app_icons.dart';
import '../controllers/post_preview_image_path_provider.dart';

class PostPreviewDownloadButton extends ConsumerStatefulWidget {
  const PostPreviewDownloadButton({super.key});

  @override
  ConsumerState<PostPreviewDownloadButton> createState() =>
      _PostPreviewDownloadButtonState();
}

class _PostPreviewDownloadButtonState
    extends ConsumerState<PostPreviewDownloadButton> {
  bool _showSuccessIcon = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final isUploading = ref.watch(
      postPreviewNotifierProvider.select((value) => value.isUploading),
    );

    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: AppColors.sky100,
        shape: const CircleBorder(),
        child: IconButton(
          padding: EdgeInsets.zero,
          tooltip: 'Tải xuống',
          onPressed: (isUploading || _isSaving) ? null : _onDownloadPressed,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: _showSuccessIcon
                ? const AppIcon(
                    AppIcons.check,
                    key: ValueKey('download_success'),
                    size: 24,
                    color: AppColors.ink600,
                  )
                : const AppIcon(
                    AppIcons.download,
                    key: ValueKey('download_default'),
                    size: 24,
                    color: AppColors.ink600,
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _onDownloadPressed() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final isSuccess = await _downloadImage();
    if (!mounted) {
      return;
    }

    if (isSuccess) {
      setState(() {
        _showSuccessIcon = true;
      });
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (!mounted) {
        return;
      }
      setState(() {
        _showSuccessIcon = false;
      });
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isSaving = false;
    });
  }

  Future<bool> _downloadImage() async {
    final filePath = ref.read(postPreviewImagePathProvider);
    final messageNotifier = ref.read(appMessageProvider.notifier);

    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          messageNotifier.addWarning('Bạn chưa cấp quyền lưu ảnh');
          return false;
        }
      }

      final file = File(filePath);
      if (!await file.exists()) {
        messageNotifier.addError('Không tìm thấy ảnh để tải xuống');
        return false;
      }

      await Gal.putImage(filePath, album: 'Beacon');
      messageNotifier.addSuccess('Đã tải ảnh xuống máy');
      return true;
    } catch (error) {
      final rawError = error.toString();
      if (rawError.contains('ACCESS_DENIED')) {
        messageNotifier.addWarning('Bạn chưa cấp quyền lưu ảnh');
      } else if (rawError.contains('NOT_ENOUGH_SPACE')) {
        messageNotifier.addError('Thiết bị không đủ dung lượng lưu ảnh');
      } else {
        messageNotifier.addError('Tải ảnh thất bại. Vui lòng thử lại');
      }
      return false;
    }
  }
}
