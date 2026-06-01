import 'package:beacon_app/core/widgets/emoji/app_emoji_picker_sheet.dart';
import 'package:beacon_app/features/home/presentation/widgets/home/home_action_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  testWidgets('checkins with selected mood when main button is pressed again', (
    tester,
  ) async {
    var checkinCount = 0;
    String? checkedMood;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HomeActionRow(
              isCheckingIn: false,
              canCheckin: true,
              onCheckin: (mood) async {
                checkinCount += 1;
                checkedMood = mood;
                return true;
              },
              onCameraPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.tapAt(tester.getCenter(find.byType(HomeActionRow)));
    await tester.pump();

    const selectedMood = '\u{1F60A}';
    await tester.tap(find.bySemanticsLabel(selectedMood));
    await tester.pump();

    await tester.tapAt(tester.getCenter(find.byType(HomeActionRow)));
    await tester.pump();

    expect(checkinCount, 1);
    expect(checkedMood, selectedMood);
  });

  testWidgets('hides mood picker overlay while emoji sheet is open', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HomeActionRow(
              isCheckingIn: false,
              canCheckin: true,
              onCheckin: (_) async => true,
              onCameraPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.tapAt(tester.getCenter(find.byType(HomeActionRow)));
    await tester.pump();

    final moreMoodButtonIcon = find.byIcon(PhosphorIconsRegular.plus);
    expect(moreMoodButtonIcon, findsOneWidget);

    await tester.tap(moreMoodButtonIcon);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.byType(AppEmojiPickerSheet), findsOneWidget);
    expect(moreMoodButtonIcon, findsNothing);

    Navigator.of(tester.element(find.byType(AppEmojiPickerSheet))).pop();
    await tester.pumpAndSettle();

    expect(moreMoodButtonIcon, findsOneWidget);
  });
}
