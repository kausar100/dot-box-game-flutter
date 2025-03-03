import 'package:flutter/material.dart';

void main() {
  runApp(const DotsAndBoxesGame());
}

class DotsAndBoxesGame extends StatefulWidget {
  const DotsAndBoxesGame({super.key});

  @override
  _DotsAndBoxesGameState createState() => _DotsAndBoxesGameState();
}

class _DotsAndBoxesGameState extends State<DotsAndBoxesGame> {
  static const int gridSize = 4; // 4x4 dot grid (3x3 squares)
  late List<List<bool>> horizontalEdges;
  late List<List<bool>> verticalEdges;
  late List<List<int?>> boxes;
  late List<List<int?>> horizontalEdgeOwners;
  late List<List<int?>> verticalEdgeOwners;
  int currentPlayer = 1;
  List<int> scores = [0, 0];
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    horizontalEdges = List.generate(gridSize + 1, (_) => List.filled(gridSize, false));
    verticalEdges = List.generate(gridSize, (_) => List.filled(gridSize + 1, false));
    boxes = List.generate(gridSize, (_) => List.filled(gridSize, null));
    horizontalEdgeOwners = List.generate(gridSize + 1, (_) => List.filled(gridSize, null));
    verticalEdgeOwners = List.generate(gridSize, (_) => List.filled(gridSize + 1, null));
    currentPlayer = 1;
    scores = [0, 0];
    gameOver = false;
  }

  void toggleEdge(bool isHorizontal, int row, int col) {
    if (gameOver) return; // Prevent moves after game ends
    setState(() {
      // Check if edge is already taken
      if (isHorizontal) {
        if (horizontalEdges[row][col]) return;
        horizontalEdges[row][col] = true;
        horizontalEdgeOwners[row][col] = currentPlayer;
      } else {
        if (verticalEdges[row][col]) return;
        verticalEdges[row][col] = true;
        verticalEdgeOwners[row][col] = currentPlayer;
      }

      // Check for box completion
      bool boxCompleted = checkAndFillBoxes();

      // Switch player only if no box was completed
      if (!boxCompleted) {
        currentPlayer = 3 - currentPlayer; // Switch: 1 -> 2 or 2 -> 1
      }

      // Check game over condition
      if (isGameOver()) {
        gameOver = true;
      }
    });
  }

  bool checkAndFillBoxes() {
    bool boxCompleted = false;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (boxes[i][j] == null &&
            i < gridSize &&
            j < gridSize &&
            horizontalEdges[i][j] &&
            horizontalEdges[i + 1][j] &&
            verticalEdges[i][j] &&
            verticalEdges[i][j + 1]) {
          boxes[i][j] = currentPlayer;
          scores[currentPlayer - 1]++;
          boxCompleted = true;
        }
      }
    }
    return boxCompleted;
  }

  bool isGameOver() {
    return scores[0] + scores[1] == gridSize * gridSize; // 16 squares for 4x4 grid
  }

  void _restartGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dots and Boxes"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _restartGame,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Player 1: ${scores[0]}   Player 2: ${scores[1]}",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Text(
              "Current Turn: Player $currentPlayer",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: currentPlayer == 1 ? Colors.blue : Colors.red,
              ),
            ),
            if (gameOver)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Winner: ${scores[0] > scores[1] ? 'Player 1' : scores[1] > scores[0] ? 'Player 2' : 'Tie'}",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1, // Keep grid square
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(gridSize * 2 + 1, (row) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(gridSize * 2 + 1, (col) {
                          if (row % 2 == 0 && col % 2 == 0) {
                            return _buildDot();
                          } else if (row % 2 == 0) {
                            int edgeRow = row ~/ 2;
                            int edgeCol = col ~/ 2;
                            return _buildEdge(true, edgeRow, edgeCol);
                          } else if (col % 2 == 0) {
                            int edgeRow = row ~/ 2;
                            int edgeCol = col ~/ 2;
                            return _buildEdge(false, edgeRow, edgeCol);
                          } else {
                            int boxRow = row ~/ 2;
                            int boxCol = col ~/ 2;
                            return _buildSquare(boxRow, boxCol);
                          }
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildEdge(bool isHorizontal, int row, int col) {
    Color edgeColor = Colors.grey.shade300; // Unclaimed edge
    if (isHorizontal && horizontalEdgeOwners[row][col] != null) {
      edgeColor = horizontalEdgeOwners[row][col] == 1 ? Colors.blue : Colors.red;
    } else if (!isHorizontal && verticalEdgeOwners[row][col] != null) {
      edgeColor = verticalEdgeOwners[row][col] == 1 ? Colors.blue : Colors.red;
    }

    return GestureDetector(
      onTap: () => toggleEdge(isHorizontal, row, col),
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

  Widget _buildSquare(int row, int col) {
    Color boxColor = Colors.white;
    String boxText = '';
    if (boxes[row][col] != null) {
      boxColor = boxes[row][col] == 1 ? Colors.blue.withOpacity(0.5) : Colors.red.withOpacity(0.5);
      boxText = boxes[row][col] == 1 ? 'P1' : 'P2';
    }

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