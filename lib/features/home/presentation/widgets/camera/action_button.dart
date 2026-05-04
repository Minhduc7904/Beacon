import 'package:flutter/material.dart';

import 'camera_capture_button.dart';
import 'camera_flash_button.dart';
import 'camera_switch_button.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CameraFlashButton(),
          CameraCaptureButton(),
          CameraSwitchButton(),
        ],
      ),
    );
  }
}
