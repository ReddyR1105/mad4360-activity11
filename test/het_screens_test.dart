import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:haunted_registry/screens/welcome_screen.dart';
import 'package:haunted_registry/screens/signup_screen.dart';
import 'package:haunted_registry/screens/success_screen.dart';

void main() {
  testWidgets('welcome stays usable at large text scale on a small display', (
    t,
  ) async {
    t.view.physicalSize = const Size(320, 568);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: const WelcomeScreen(),
      ),
    );
    expect(find.byType(AnimatedTextKit), findsOneWidget);
    await t.pumpAndSettle();
    await t.ensureVisible(find.text('Enter If You Dare'));
    await t.tap(find.text('Enter If You Dare'));
    await t.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);
    await t.pageBack();
    await t.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'success receives constructor data, plays and disposes confetti',
    (t) async {
      await t.pumpWidget(
        const MaterialApp(
          home: SuccessScreen(userName: 'Demo Het', creatureType: 'Black Cat'),
        ),
      );
      expect(find.text('Welcome, Demo Het!'), findsOneWidget);
      expect(
        find.text('Your Black Cat companion is registered.'),
        findsOneWidget,
      );
      final controller = t
          .widget<ConfettiWidget>(find.byType(ConfettiWidget))
          .confettiController;
      expect(controller.state, ConfettiControllerState.playing);
      await t.pumpWidget(const SizedBox());
      expect(controller.state, ConfettiControllerState.disposed);
      expect(t.takeException(), isNull);
    },
  );
}
