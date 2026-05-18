import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/providers/providers.dart';
import '../../../../core/widgets/layout/screen_layout.dart';
import '../controllers/post_preview_image_path_provider.dart';
import '../widgets/post_preview_close_button.dart';
import '../widgets/post_preview_caption_input.dart';
import '../widgets/post_preview_header.dart';
import '../widgets/post_preview_image_box.dart';
import '../widgets/post_preview_location_button.dart';
import '../widgets/post_preview_send_button.dart';
import '../widgets/post_preview_status_message.dart';

class PostPreviewPage extends ConsumerStatefulWidget {
  const PostPreviewPage({super.key, required this.filePath});

  final String filePath;

  @override
  ConsumerState<PostPreviewPage> createState() => _PostPreviewPageState();
}

class _PostPreviewPageState extends ConsumerState<PostPreviewPage> {
  late final TextEditingController _captionController;
  double? _latitude;
  double? _longitude;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _toggleLocation() async {
    if (_latitude != null && _longitude != null) {
      setState(() {
        _latitude = null;
        _longitude = null;
      });
      return;
    }

    if (_isLoadingLocation) {
      return;
    }

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        ref
            .read(appMessageProvider.notifier)
            .addWarning('Vui lòng bật dịch vụ vị trí để chia sẻ vị trí.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ref
            .read(appMessageProvider.notifier)
            .addWarning('Bạn chưa cấp quyền vị trí.');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) {
        return;
      }

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (_) {
      ref
          .read(appMessageProvider.notifier)
          .addError('Không thể lấy vị trí hiện tại.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        postPreviewImagePathProvider.overrideWithValue(widget.filePath),
      ],
      child: Scaffold(
        body: SafeArea(
          child: AppScreenLayout(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        const PostPreviewHeader(),
                        const SizedBox(height: 20),
                        const PostPreviewImageBox(),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: PostPreviewCaptionInput(
                            controller: _captionController,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 80,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Positioned(
                                  left: 0,
                                  child: PostPreviewCloseButton(),
                                ),
                                PostPreviewSendButton(
                                  captionController: _captionController,
                                  latitude: _latitude,
                                  longitude: _longitude,
                                ),
                                Positioned(
                                  right: 0,
                                  child: PostPreviewLocationButton(
                                    isEnabled: !ref
                                        .watch(postPreviewNotifierProvider)
                                        .isUploading,
                                    isLoading: _isLoadingLocation,
                                    isSelected:
                                        _latitude != null && _longitude != null,
                                    onPressed: _toggleLocation,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const PostPreviewStatusMessage(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
