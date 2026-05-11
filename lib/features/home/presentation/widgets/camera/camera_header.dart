import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/icons/app_icon.dart';
import '../../../../../core/theme/icons/app_icons.dart';

class CameraHeader extends StatelessWidget {
  const CameraHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const AppIcon(AppIcons.back),
        ),
      ],
    );
  }
}
