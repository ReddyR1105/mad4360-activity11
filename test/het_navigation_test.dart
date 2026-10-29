import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haunted_registry/main.dart';
import 'package:haunted_registry/screens/signup_screen.dart';
import 'package:haunted_registry/screens/success_screen.dart';

Future<void> tapVisible(WidgetTester t, Finder f) async {
  await t.ensureVisible(f);
  await t.tap(f);
  await t.pump();
}

Future<void> fill(WidgetTester t) async {
  await t.enterText(find.byKey(const Key('name')), 'Demo Het');
  await t.enterText(find.byKey(const Key('email')), 'demo@example.com');
  await t.enterText(find.byKey(const Key('password')), 'secret123');
}

void main() {
  testWidgets('two submissions replace form and Back returns to foyer', (
    t,
  ) async {
    await t.pumpWidget(const HauntedMansionApp());
    for (var round = 0; round < 2; round++) {
      await t.tap(find.text('Enter If You Dare'));
      await t.pumpAndSettle();
      await fill(t);
      await tapVisible(t, find.byKey(const Key('birthday')));
      await t.pumpAndSettle();
      await t.tap(find.text('OK'));
      await t.pumpAndSettle();
      await tapVisible(t, find.byKey(const Key('creature')));
      await t.pumpAndSettle();
      await t.tap(find.text('Ghost').last);
      await t.pumpAndSettle();
      await tapVisible(t, find.byKey(const Key('submit')));

      expect(
        t.widget<FilledButton>(find.byKey(const Key('submit'))).onPressed,
        isNull,
      );
      await t.pump(const Duration(milliseconds: 1900));
      expect(find.byType(SuccessScreen), findsNothing);
      await t.pump(const Duration(milliseconds: 100));
      // Confetti uses wall-clock particle timing; bounded frames test the route
      // transition without waiting for every decorative particle to settle.
      await t.pump(const Duration(seconds: 1));
      await t.pump();
      expect(find.text('Welcome, Demo Het!'), findsOneWidget);
      expect(find.text('Your Ghost companion is registered.'), findsOneWidget);
      expect(find.byType(SignupScreen), findsNothing);
      await t.pageBack();
      await t.pumpAndSettle();
      expect(find.text('Enter If You Dare'), findsOneWidget);
      expect(find.byType(SignupScreen), findsNothing);
    }
    await t.pumpWidget(const SizedBox());
    expect(t.takeException(), isNull);
  });
}
