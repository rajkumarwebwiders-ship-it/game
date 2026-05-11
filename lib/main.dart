import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game/firebase_options.dart';

import 'screens/create_game_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coach Game Tracker',
      debugShowCheckedModeBanner: false,

      // Using the decoupled theme from AppTheme class
      theme: AppTheme.lightTheme,

      home: const CreateGameScreen(),
    );
  }
}
