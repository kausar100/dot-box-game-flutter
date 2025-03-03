import 'package:dot_box_game/presentation/providers/game_provider.dart';
import 'package:dot_box_game/presentation/widgets/dot_widget.dart';
import 'package:dot_box_game/presentation/widgets/edge_widget.dart';
import 'package:dot_box_game/presentation/widgets/square_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dots and Boxes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<GameProvider>().restartGame(),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          final state = provider.gameState;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Player 1: ${state.scores[0]}   Player 2: ${state.scores[1]}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Text(
                "Current Turn: Player ${state.currentPlayer}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: state.currentPlayer == 1 ? Colors.blue : Colors.red,
                ),
              ),
              if (state.gameOver)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Winner: ${state.scores[0] > state.scores[1] ? 'Player 1' : state.scores[1] > state.scores[0] ? 'Player 2' : 'Tie'}",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(state.gridSize * 2 + 1, (row) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(state.gridSize * 2 + 1, (col) {
                            if (row % 2 == 0 && col % 2 == 0) {
                              return const DotWidget();
                            } else if (row % 2 == 0) {
                              int edgeRow = row ~/ 2;
                              int edgeCol = col ~/ 2;
                              return EdgeWidget(
                                isHorizontal: true,
                                row: edgeRow,
                                col: edgeCol,
                                isDrawn: state.horizontalEdges[edgeRow]
                                    [edgeCol],
                                owner: state.horizontalEdgeOwners[edgeRow]
                                    [edgeCol],
                                onTap: () =>
                                    provider.toggleEdge(true, edgeRow, edgeCol),
                              );
                            } else if (col % 2 == 0) {
                              int edgeRow = row ~/ 2;
                              int edgeCol = col ~/ 2;
                              return EdgeWidget(
                                isHorizontal: false,
                                row: edgeRow,
                                col: edgeCol,
                                isDrawn: state.verticalEdges[edgeRow][edgeCol],
                                owner: state.verticalEdgeOwners[edgeRow]
                                    [edgeCol],
                                onTap: () => provider.toggleEdge(
                                    false, edgeRow, edgeCol),
                              );
                            } else {
                              int boxRow = row ~/ 2;
                              int boxCol = col ~/ 2;
                              return SquareWidget(
                                owner: state.boxes[boxRow][boxCol],
                              );
                            }
                          }),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
