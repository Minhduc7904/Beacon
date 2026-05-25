import 'package:beacon_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/register_login_test_user.dart';

class AuthFlowRobot {
  AuthFlowRobot(this.tester);

  final WidgetTester tester;

  Future<void> openRegisterFromOnboarding() async {
    await pumpUntilFound(
      _textAny(const ['Dang ki', 'Dang ky', 'Đăng kí', 'Đăng ký']),
    );
    await tapAnyText(const ['Dang ki', 'Dang ky', 'Đăng kí', 'Đăng ký']);
    await pumpUntilFound(find.byType(TextField));
  }

  Future<void> submitRegistration(RegisterLoginTestUser user) async {
    await enterTextFieldAt(0, user.email);
    await tapAnyText(const ['Tiep theo', 'Tiếp theo']);
    await pumpUntilTextFieldCount(1);

    await enterTextFieldAt(0, user.phoneNumber);
    await tapAnyText(const ['Tiep theo', 'Tiếp theo']);
    await pumpUntilTextFieldCount(2);

    await enterTextFieldAt(0, user.password);
    await enterTextFieldAt(1, user.password);
    await tapAnyText(const ['Tiep theo', 'Tiếp theo']);
    await pumpUntilTextFieldCount(2);

    await enterTextFieldAt(0, user.familyName);
    await enterTextFieldAt(1, user.givenName);
    await tapAnyText(const ['Tiep theo', 'Tiếp theo']);
    await pumpUntilTextFieldCount(1);

    await enterTextFieldAt(0, user.username);
    await tapAnyText(const ['Hoan tat', 'Hoàn tất']);
  }

  Future<void> expectLoginVisible() async {
    await pumpUntilFound(_textAny(const ['Dang nhap', 'Đăng nhập']));
    await pumpUntilTextFieldCount(2, timeout: const Duration(seconds: 8));
    expect(find.byType(TextField), findsNWidgets(2));
  }

  Future<void> login(RegisterLoginTestUser user) async {
    await enterTextFieldAt(0, user.username);
    await enterTextFieldAt(1, user.password);
    await tapAnyText(const ['Dang nhap', 'Đăng nhập']);
  }

  Future<void> expectHomeVisible() async {
    await pumpUntilFound(
      find.byType(HomePage),
      timeout: const Duration(seconds: 12),
    );
    expect(find.byType(HomePage), findsOneWidget);
  }

  Future<void> enterTextFieldAt(int index, String text) async {
    final finder = find.byType(TextField).at(index);
    await tester.ensureVisible(finder);
    await tester.enterText(finder, text);
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> tapAnyText(List<String> labels) async {
    final finder = _textAny(labels);
    await pumpUntilFound(finder);
    await tester.ensureVisible(finder.first);
    await tester.tap(finder.first);
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> pumpUntilTextFieldCount(
    int count, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await _pumpUntil(
      () => find.byType(TextField).evaluate().length == count,
      timeout: timeout,
      failureDescription: 'Expected $count text field(s)',
    );
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

  Finder _textAny(List<String> labels) {
    return find.byWidgetPredicate((widget) {
      if (widget is Text) {
        final data = widget.data;
        if (data != null && labels.contains(data)) {
          return true;
        }
      }

      if (widget is RichText) {
        return labels.contains(widget.text.toPlainText());
      }

      return false;
    });
  }
}
