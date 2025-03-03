import 'package:dot_box_game/presentation/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class EdgeWidget extends StatelessWidget {
  final bool isHorizontal;
  final int row;
  final int col;
  final bool isDrawn;
  final int? owner;
  final VoidCallback onTap;

  const EdgeWidget({
    super.key,
    required this.isHorizontal,
    required this.row,
    required this.col,
    required this.isDrawn,
    required this.owner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    Color edgeColor = isDrawn
        ? (owner == 1 ? Colors.blue[700]! : Colors.red[700]!)
        : Colors.grey[400]!;

    bool shouldAnimate = isDrawn &&
        provider.lastEdgeRow == row &&
        provider.lastEdgeCol == col &&
        provider.lastEdgeIsHorizontal == isHorizontal;

    Widget edge = Container(
      width: isHorizontal ? 50 : 12,
      height: isHorizontal ? 12 : 50,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: edgeColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isDrawn
            ? [
          BoxShadow(
            color: edgeColor.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ]
            : null,
      ),
    );

    if (shouldAnimate) {
      edge = edge
          .animate()
          .scale(duration: 200.ms, curve: Curves.easeInOut)
          .fadeIn(duration: 200.ms);
    }

    return GestureDetector(
      onTap: isDrawn ? null : onTap,
      child: edge,
    );
  }
}