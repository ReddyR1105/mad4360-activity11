import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haunted_registry/main.dart';
import 'package:haunted_registry/validators.dart';
import 'package:haunted_registry/widgets/local_tips.dart';

void main() {
  test('original validators reject invalid inputs and accept valid inputs', () {
    expect(validateName('  '), isNotNull);
    expect(validateName('Rohan'), isNull);
    expect(validateEmail(''), isNotNull);
    expect(validateEmail('abc@'), isNotNull);
    expect(validateEmail('demo@example.com'), isNull);
    expect(validatePassword('12345'), isNotNull);
    expect(validatePassword('abc123'), isNull);
  });
  test(
    'offline service is deterministic and recovers from simulated failure',
    () async {
      final service = LocalTipService();
      final tip = await service.getTip();
      expect(tip.length, lessThanOrEqualTo(240));
      expect(await service.getTip(), tip);
      await expectLater(
        service.getTip(simulateFailure: true),
        throwsStateError,
      );
      expect(await service.getTip(), tip);
    },
  );
  testWidgets('empty form displays required validation messages', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const HauntedMansionApp());
    await tester.tap(find.text('Enter If You Dare'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('submit')));
    await tester.pump();
    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter your email address'), findsOneWidget);
    expect(find.text('Use at least 6 characters'), findsOneWidget);
    expect(find.text('Pick your birth date'), findsOneWidget);
    expect(find.text('Choose a creature type'), findsOneWidget);
  });
  testWidgets('tip error and retry produce real UI states', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LocalTips())),
    );
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Retry'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Preset demo tip'), findsOneWidget);
  });
  testWidgets('picker boundaries and rotation preserve owned state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const HauntedMansionApp());
    await tester.tap(find.text('Enter If You Dare'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('name')), 'Rohan');
    await tester.enterText(find.byKey(const Key('password')), 'abc123');
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('birthday')));
    await tester.pumpAndSettle();
    final picker = tester.widget<DatePickerDialog>(
      find.byType(DatePickerDialog),
    );
    expect(picker.firstDate, DateTime(1920));
    expect(picker.lastDate, DateUtils.dateOnly(DateTime.now()));
    expect(picker.lastDate.isAfter(DateTime(1990)), isTrue);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('creature')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ghost').last);
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(2400, 1080);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('name')))
          .controller!
          .text,
      'Rohan',
    );
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.byKey(const Key('password')),
              matching: find.byType(TextField),
            ),
          )
          .obscureText,
      isFalse,
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('birthday')))
          .controller!
          .text,
      '1/1/2008',
    );
    expect(find.text('Ghost'), findsOneWidget);
  });
  testWidgets('replacement navigation returns to foyer and disposes the form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const HauntedMansionApp());
    await tester.tap(find.text('Enter If You Dare'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('name')), 'Rohan');
    await tester.enterText(find.byKey(const Key('email')), 'demo@example.com');
    await tester.enterText(find.byKey(const Key('password')), 'abc123');
    await tester.tap(find.byKey(const Key('birthday')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('creature')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bat').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('submit')));
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byKey(const Key('submit'))).onPressed,
      isNull,
    );
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Welcome, Rohan!'), findsOneWidget);
    expect(find.text('Your Bat companion is registered.'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Enter If You Dare'), findsOneWidget);
    await tester.tap(find.text('Enter If You Dare'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('name')))
          .controller!
          .text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });
}
