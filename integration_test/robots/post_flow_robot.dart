import 'package:beacon_app/core/widgets/button/icon_circle_button.dart';
import 'package:beacon_app/features/home/presentation/pages/camera_screen.dart';
import 'package:beacon_app/features/home/presentation/pages/home_page.dart';
import 'package:beacon_app/features/home/presentation/widgets/camera/camera_capture_button.dart';
import 'package:beacon_app/features/home/presentation/widgets/camera/camera_box.dart';
import 'package:beacon_app/features/home/presentation/widgets/home/home_action_row.dart';
import 'package:beacon_app/features/post_preview/presentation/pages/post_preview_page.dart';
import 'package:beacon_app/features/post_preview/presentation/widgets/post_preview_send_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class PostFlowRobot {
  PostFlowRobot(this.tester);

  final WidgetTester tester;

  Future<void> openCameraFromHome() async {
    await pumpUntilFound(find.byType(HomePage));
    await pumpUntilFound(find.byType(HomeActionRow));

    final cameraButton = find
        .descendant(
          of: find.byType(HomeActionRow),
          matching: find.byType(IconCircleButton),
        )
        .at(1);

    await tester.ensureVisible(cameraButton);
    await tester.tap(cameraButton);
    await tester.pump(const Duration(milliseconds: 100));

    await pumpUntilFound(
      find.byType(CameraScreen),
      timeout: const Duration(seconds: 10),
    );
  }

  Future<void> capturePhoto() async {
    await pumpUntilFound(
      find.byType(SquareCameraPreview),
      timeout: const Duration(seconds: 30),
    );
    await pumpUntilFound(
      find.byType(CameraCaptureButton),
      timeout: const Duration(seconds: 20),
    );

    await tester.tapAt(tester.getCenter(find.byType(CameraCaptureButton)));
    await tester.pump(const Duration(milliseconds: 100));

    await pumpUntilFound(
      find.byType(PostPreviewPage),
      timeout: const Duration(seconds: 45),
    );
  }

  Future<void> enterCaption(String caption) async {
    await pumpUntilFound(find.byType(PostPreviewPage));
    final field = find
        .descendant(
          of: find.byType(PostPreviewPage),
          matching: find.byType(TextField),
        )
        .first;

    await tester.ensureVisible(field);
    await tester.enterText(field, caption);
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> submitPost() async {
    final sendButton = find.byType(PostPreviewSendButton);

    await pumpUntilFound(sendButton);

    // Đóng keyboard trước, vì keyboard đang che nút gửi.
    await tester.testTextInput.receiveAction(TextInputAction.done);
    tester.binding.focusManager.primaryFocus?.unfocus();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.ensureVisible(sendButton);
    await tester.pumpAndSettle();

    final hittableSendButton = sendButton.hitTestable();

    await pumpUntilFound(
      hittableSendButton,
      timeout: const Duration(seconds: 10),
    );

    await tester.tap(hittableSendButton);
    await tester.pump(const Duration(milliseconds: 100));

    await pumpUntilNotFound(
      find.byType(PostPreviewPage),
      timeout: const Duration(seconds: 60),
    );

    await pumpUntilFound(find.byType(CameraScreen));
  }

  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await _pumpUntil(
      () => finder.evaluate().isNotEmpty,
      timeout: timeout,
      failureDescription: 'Could not find $finder',
    );
  }

  Future<void> pumpUntilNotFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await _pumpUntil(
      () => finder.evaluate().isEmpty,
      timeout: timeout,
      failureDescription: 'Still found $finder',
    );
  }

  Future<void> _pumpUntil(
    bool Function() condition, {
    required Duration timeout,
    required String failureDescription,
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (condition()) {
        return;
      }
    }

    fail('$failureDescription within ${timeout.inSeconds}s');
  }
}
