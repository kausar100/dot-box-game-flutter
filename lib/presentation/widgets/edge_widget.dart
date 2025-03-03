import 'package:flutter/material.dart';

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
    Color edgeColor = isDrawn ? (owner == 1 ? Colors.blue : Colors.red) : Colors.grey.shade300;

    return GestureDetector(
      onTap: isDrawn ? null : onTap,
      child: Container(
        width: isHorizontal ? 40 : 10,
        height: isHorizontal ? 10 : 40,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: edgeColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}