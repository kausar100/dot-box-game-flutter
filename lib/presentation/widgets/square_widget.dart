import 'package:dot_box_game/presentation/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class SquareWidget extends StatelessWidget {
  final int? owner;
  final int row;
  final int col;

  const SquareWidget({
    super.key,
    required this.owner,
    required this.row,
    required this.col,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    Color boxColor = owner == null
        ? Colors.white.withOpacity(0.8)
        : (owner == 1 ? Colors.blue[300]!.withOpacity(0.7) : Colors.red[300]!.withOpacity(0.7));
    String boxText = owner == null ? '' : (owner == 1 ? 'P1' : 'P2');

    bool shouldAnimate = owner != null &&
        provider.lastBoxRow == row &&
        provider.lastBoxCol == col;

    Widget square = Container(
      width: 48,
      height: 48,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
        boxShadow: owner != null
            ? [
          BoxShadow(
            color: boxColor.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        boxText,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: owner == null ? Colors.transparent : Colors.white,
          shadows: const [Shadow(color: Colors.black54, blurRadius: 2)],
        ),
      ),
    );

    if (shouldAnimate) {
      square = square
          .animate()
          .scale(duration: 300.ms, curve: Curves.easeOut)
          .fadeIn(duration: 300.ms);
    }

    return square;
  }
}