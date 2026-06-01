import 'package:beacon_app/core/widgets/button/button.dart';
import 'package:beacon_app/features/auth/presentation/pages/login/login_page.dart';
import 'package:beacon_app/features/auth/presentation/pages/register/register_page_email.dart';
import 'package:beacon_app/features/auth/presentation/pages/register/register_page_name.dart';
import 'package:beacon_app/features/auth/presentation/pages/register/register_page_password.dart';
import 'package:beacon_app/features/auth/presentation/pages/register/register_page_phone_number.dart';
import 'package:beacon_app/features/auth/presentation/pages/register/register_page_username.dart';
import 'package:beacon_app/features/home/presentation/pages/home_page.dart';
import 'package:beacon_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/register_login_test_user.dart';

class AuthFlowRobot {
  AuthFlowRobot(this.tester);

  final WidgetTester tester;

  Future<void> openLoginFromOnboarding() async {
    await pumpUntilFound(find.byType(OnboardingPage));
    await tapButtonAt(0);
    await pumpUntilFound(find.byType(LoginPage));
    await pumpUntilTextFieldCount(2, timeout: const Duration(seconds: 8));
  }

  Future<void> openRegisterFromOnboarding() async {
    await pumpUntilFound(find.byType(OnboardingPage));
    await tapButtonAt(1);
    await pumpUntilFound(find.byType(RegisterPageEmail));
    await pumpUntilTextFieldCount(1);
  }

  Future<void> submitRegistration(RegisterLoginTestUser user) async {
    await enterTextFieldAt(0, user.email);
    await tapButtonAt(0);
    await pumpUntilFound(
      find.byType(RegisterPagePhoneNumber),
      timeout: const Duration(seconds: 10),
    );
    await pumpUntilTextFieldCount(1);

    await enterTextFieldAt(0, user.phoneNumber);
    await tapButtonAt(0);
    await pumpUntilFound(
      find.byType(RegisterPagePassword),
      timeout: const Duration(seconds: 10),
    );
    await pumpUntilTextFieldCount(2);

    await enterTextFieldAt(0, user.password);
    await enterTextFieldAt(1, user.password);
    await tapButtonAt(0);
    await pumpUntilFound(
      find.byType(RegisterPageName),
      timeout: const Duration(seconds: 10),
    );
    await pumpUntilTextFieldCount(2);

    await enterTextFieldAt(0, user.familyName);
    await enterTextFieldAt(1, user.givenName);
    await tapButtonAt(0);
    await pumpUntilFound(
      find.byType(RegisterPageUsername),
      timeout: const Duration(seconds: 10),
    );
    await pumpUntilTextFieldCount(1);

    await enterTextFieldAt(0, user.username);
    await tapButtonAt(0);
  }

  Future<void> expectLoginVisible() async {
    await pumpUntilFound(find.byType(LoginPage));
    await pumpUntilTextFieldCount(2, timeout: const Duration(seconds: 8));
    expect(find.byType(TextField), findsNWidgets(2));
  }

  Future<void> login(RegisterLoginTestUser user) async {
    await enterTextFieldAt(0, user.username);
    await enterTextFieldAt(1, user.password);
    await tapButtonAt(0);
  }

  Future<void> expectHomeVisible() async {
    await pumpUntilFound(
      find.byType(HomePage),
      timeout: const Duration(seconds: 12),
    );
    expect(find.byType(HomePage), findsOneWidget);
  }

  Future<void> enterTextFieldAt(int index, String text) async {
    await pumpUntilTextFieldCountAtLeast(index + 1);
    final finder = find.byType(TextField).at(index);
    await tester.ensureVisible(finder);
    await tester.enterText(finder, text);
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> tapButtonAt(int index) async {
    await pumpUntilButtonCountAtLeast(index + 1);
    final finder = find.byType(Button).at(index);
    await tester.ensureVisible(finder);
    await tester.tap(finder);
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

  Future<void> pumpUntilTextFieldCountAtLeast(
    int count, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await _pumpUntil(
      () => find.byType(TextField).evaluate().length >= count,
      timeout: timeout,
      failureDescription: 'Expected at least $count text field(s)',
    );
  }

  Future<void> pumpUntilButtonCountAtLeast(
    int count, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await _pumpUntil(
      () => find.byType(Button).evaluate().length >= count,
      timeout: timeout,
      failureDescription: 'Expected at least $count button(s)',
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
}
