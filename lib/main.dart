import 'package:dot_box_game/presentation/providers/game_provider.dart';
import 'package:dot_box_game/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/game_repository_impl.dart';
import 'domain/usecases/play_game.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<PlayGame>(
          create: (_) => PlayGame(GameRepositoryImpl()),
        ),
        ChangeNotifierProvider(
          create: (context) => GameProvider(context.read<PlayGame>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dots and Boxes',
      theme: ThemeData.light(),
      home: const SplashScreen(), // Start with splash screen
    );
  }
}