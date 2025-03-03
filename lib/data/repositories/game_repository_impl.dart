import 'package:dot_box_game/data/models/game_state.dart';
import 'package:dot_box_game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  @override
  GameState initializeGame(int gridSize) {
    return GameState(
      gridSize: gridSize,
      horizontalEdges: List.generate(gridSize + 1, (_) => List.filled(gridSize, false)),
      verticalEdges: List.generate(gridSize, (_) => List.filled(gridSize + 1, false)),
      boxes: List.generate(gridSize, (_) => List.filled(gridSize, null)),
      horizontalEdgeOwners: List.generate(gridSize + 1, (_) => List.filled(gridSize, null)),
      verticalEdgeOwners: List.generate(gridSize, (_) => List.filled(gridSize + 1, null)),
      currentPlayer: 1,
      scores: [0, 0],
      gameOver: false,
    );
  }

  @override
  GameState toggleEdge(GameState state, bool isHorizontal, int row, int col) {
    if (state.gameOver) return state;

    List<List> newHorizontalEdges = state.horizontalEdges.map((row) => List.from(row)).toList();
    List<List> newVerticalEdges = state.verticalEdges.map((row) => List.from(row)).toList();
    List<List> newHorizontalEdgeOwners = state.horizontalEdgeOwners.map((row) => List.from(row)).toList();
    List<List> newVerticalEdgeOwners = state.verticalEdgeOwners.map((row) => List.from(row)).toList();
    List<List> newBoxes = state.boxes.map((row) => List.from(row)).toList();
    List<int> newScores = List.from(state.scores);

    if (isHorizontal) {
      if (newHorizontalEdges[row][col]) return state;
      newHorizontalEdges[row][col] = true;
      newHorizontalEdgeOwners[row][col] = state.currentPlayer;
    } else {
      if (newVerticalEdges[row][col]) return state;
      newVerticalEdges[row][col] = true;
      newVerticalEdgeOwners[row][col] = state.currentPlayer;
    }

    bool boxCompleted = false;
    for (int i = 0; i < state.gridSize; i++) {
      for (int j = 0; j < state.gridSize; j++) {
        if (newBoxes[i][j] == null &&
            newHorizontalEdges[i][j] &&
            newHorizontalEdges[i + 1][j] &&
            newVerticalEdges[i][j] &&
            newVerticalEdges[i][j + 1]) {
          newBoxes[i][j] = state.currentPlayer;
          newScores[state.currentPlayer - 1]++;
          boxCompleted = true;
        }
      }
    }

    int newCurrentPlayer = boxCompleted ? state.currentPlayer : 3 - state.currentPlayer;
    bool newGameOver = newScores[0] + newScores[1] == state.gridSize * state.gridSize;

    return state.copyWith(
      horizontalEdges: newHorizontalEdges,
      verticalEdges: newVerticalEdges,
      boxes: newBoxes,
      horizontalEdgeOwners: newHorizontalEdgeOwners,
      verticalEdgeOwners: newVerticalEdgeOwners,
      currentPlayer: newCurrentPlayer,
      scores: newScores,
      gameOver: newGameOver,
    );
  }
}