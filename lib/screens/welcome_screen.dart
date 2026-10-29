import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF352056), Color(0xFF141222), Color(0xFF22382D)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  const Icon(
                    Icons.nightlight_round,
                    size: 96,
                    color: Color(0xFFB5E48C),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'THE MIDNIGHT MENAGERIE',
                    style: TextStyle(
                      letterSpacing: 3,
                      color: Color(0xFFB5E48C),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 130,
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'The Haunted Creature Registry',
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          speed: const Duration(milliseconds: 65),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Every creature deserves a companion. Yours is waiting beyond the foyer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const SignupScreen(),
                      ),
                    ),
                    child: const Text('Enter If You Dare'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'FOYER  /  LABORATORY  /  BALLROOM',
                    style: TextStyle(fontSize: 11, letterSpacing: 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
