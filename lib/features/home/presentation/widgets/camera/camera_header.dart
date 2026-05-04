import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CameraHeader extends StatelessWidget {
  const CameraHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ],
    );
  }
}
