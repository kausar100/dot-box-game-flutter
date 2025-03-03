import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'game_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToGame();
  }

  Future<void> _navigateToGame() async {
    await Future.delayed(const Duration(seconds: 3)); // Show splash for 3 seconds
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Uncomment if you have a logo in assets
              // Image.asset(
              //   'assets/logo.png',
              //   width: 150,
              //   height: 150,
              // ).animate().fadeIn(duration: 1000.ms).scale(curve: Curves.easeInOut),
              Text(
                'Dots & Boxes',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms)
                  .scale(curve: Curves.easeInOut),
              const SizedBox(height: 20),
              Text(
                'A Game of Strategy',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey[700],
                  fontStyle: FontStyle.italic,
                ),
              ).animate().fadeIn(duration: 1200.ms, delay: 200.ms),
              const SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey[900]!),
              ).animate().fadeIn(duration: 1400.ms, delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}