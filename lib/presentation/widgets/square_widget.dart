import 'package:flutter/material.dart';

class SquareWidget extends StatelessWidget {
  final int? owner;

  const SquareWidget({super.key, required this.owner});

  @override
  Widget build(BuildContext context) {
    Color boxColor = owner == null ? Colors.white : (owner == 1 ? Colors.blue.withOpacity(0.5) : Colors.red.withOpacity(0.5));
    String boxText = owner == null ? '' : (owner == 1 ? 'P1' : 'P2');

    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: boxColor,
        border: Border.all(color: Colors.grey.shade400),
      ),
      alignment: Alignment.center,
      child: Text(
        boxText,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}