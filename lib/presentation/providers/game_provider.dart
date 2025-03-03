import 'package:dot_box_game/data/models/game_state.dart';
import 'package:dot_box_game/domain/usecases/play_game.dart';
import 'package:flutter/material.dart';


class GameProvider with ChangeNotifier {
  final PlayGame playGame;
  late GameState _gameState;

  GameProvider(this.playGame) {
    _gameState = playGame.initialize(4); // Default 4x4 grid
  }

  GameState get gameState => _gameState;

  void toggleEdge(bool isHorizontal, int row, int col) {
    _gameState = playGame.makeMove(_gameState, isHorizontal, row, col);
    notifyListeners();
  }

  void restartGame() {
    _gameState = playGame.initialize(4);
    notifyListeners();
  }
}