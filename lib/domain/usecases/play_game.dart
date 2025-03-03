import 'package:dot_box_game/data/models/game_state.dart';
import 'package:dot_box_game/domain/repositories/game_repository.dart';

class PlayGame {
  final GameRepository repository;

  PlayGame(this.repository);

  GameState initialize(int gridSize) {
    return repository.initializeGame(gridSize);
  }

  GameState makeMove(GameState state, bool isHorizontal, int row, int col) {
    return repository.toggleEdge(state, isHorizontal, row, col);
  }
}