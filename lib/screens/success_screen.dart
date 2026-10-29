import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  final String userName;
  final String creatureType;
  const SuccessScreen({
    super.key,
    required this.userName,
    required this.creatureType,
  });
  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));
  @override
  void initState() {
    super.initState();
    _confetti.play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Celebration Ballroom')),
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF352056), Color(0xFF141222), Color(0xFF22382D)],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.celebration_outlined,
                      size: 90,
                      color: Color(0xFFB5E48C),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome, ${widget.userName}!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your ${widget.creatureType} companion is registered.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 21),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'A demo celebration. Your password and profile are not stored.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text('Return to Foyer'),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Color(0xFFB5E48C),
                  Colors.deepOrange,
                  Colors.purple,
                  Colors.white,
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
