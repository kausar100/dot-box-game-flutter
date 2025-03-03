import 'package:dot_box_game/data/models/game_state.dart';

abstract class GameRepository {
  GameState initializeGame(int gridSize);
  GameState toggleEdge(GameState state, bool isHorizontal, int row, int col);
}