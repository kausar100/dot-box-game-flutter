import 'package:dot_box_game/data/models/game_state.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Consumer<GameProvider>(
            builder: (context, provider, child) {
              final state = provider.gameState;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      _buildHeader(context, state, provider),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      state.gridSize * 2 + 1, (row) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                          state.gridSize * 2 + 1, (col) {
                                        if (row % 2 == 0 && col % 2 == 0) {
                                          return const DotWidget();
                                        } else if (row % 2 == 0) {
                                          int edgeRow = row ~/ 2;
                                          int edgeCol = col ~/ 2;
                                          return EdgeWidget(
                                            isHorizontal: true,
                                            row: edgeRow,
                                            col: edgeCol,
                                            isDrawn:
                                                state.horizontalEdges[edgeRow]
                                                    [edgeCol],
                                            owner: state.horizontalEdgeOwners[
                                                edgeRow][edgeCol],
                                            onTap: () => provider.toggleEdge(
                                                true, edgeRow, edgeCol),
                                          );
                                        } else if (col % 2 == 0) {
                                          int edgeRow = row ~/ 2;
                                          int edgeCol = col ~/ 2;
                                          return EdgeWidget(
                                            isHorizontal: false,
                                            row: edgeRow,
                                            col: edgeCol,
                                            isDrawn:
                                                state.verticalEdges[edgeRow]
                                                    [edgeCol],
                                            owner: state
                                                    .verticalEdgeOwners[edgeRow]
                                                [edgeCol],
                                            onTap: () => provider.toggleEdge(
                                                false, edgeRow, edgeCol),
                                          );
                                        } else {
                                          int boxRow = row ~/ 2;
                                          int boxCol = col ~/ 2;
                                          return SquareWidget(
                                            owner: state.boxes[boxRow][boxCol],
                                            row: boxRow,
                                            col: boxCol,
                                          );
                                        }
                                      }),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state.gameOver)
                    Positioned(
                        bottom: 16,
                        child: _buildGameOverOverlay(context, state, provider)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, GameState state, GameProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Player 1: ${state.scores[0]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              Text(
                "Player 2: ${state.scores[1]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Turn: Player ${state.currentPlayer}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: state.currentPlayer == 1
                      ? Colors.blue[800]
                      : Colors.red[800],
                ),
              ),
              InkWell(
                  onTap: provider.restartGame,
                  child: const Icon(Icons.refresh, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(
      BuildContext context, GameState state, GameProvider provider) {
    String result = state.scores[0] > state.scores[1]
        ? 'Player 1 Wins!'
        : state.scores[1] > state.scores[0]
            ? 'Player 2 Wins!'
            : 'It\'s a Tie!';
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              result,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.restartGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Play Again',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
