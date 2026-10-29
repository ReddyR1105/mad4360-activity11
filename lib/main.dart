import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/welcome_screen.dart';

void main() => runApp(const HauntedMansionApp());

class HauntedMansionApp extends StatelessWidget {
  const HauntedMansionApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'The Haunted Creature Registry',
    debugShowCheckedModeBanner: false,
    theme: appTheme(),
    home: const WelcomeScreen(),
  );
}
