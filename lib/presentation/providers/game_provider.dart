import 'package:dot_box_game/data/models/game_state.dart';
import 'package:dot_box_game/domain/usecases/play_game.dart';
import 'package:flutter/material.dart';


class GameProvider with ChangeNotifier {
  final PlayGame playGame;
  late GameState _gameState;
  int? _lastEdgeRow;
  int? _lastEdgeCol;
  bool? _lastEdgeIsHorizontal;
  int? _lastBoxRow;
  int? _lastBoxCol;

  GameProvider(this.playGame) {
    _gameState = playGame.initialize(4);
  }

  GameState get gameState => _gameState;
  int? get lastEdgeRow => _lastEdgeRow;
  int? get lastEdgeCol => _lastEdgeCol;
  bool? get lastEdgeIsHorizontal => _lastEdgeIsHorizontal;
  int? get lastBoxRow => _lastBoxRow;
  int? get lastBoxCol => _lastBoxCol;

  void toggleEdge(bool isHorizontal, int row, int col) {
    final oldState = _gameState;
    final newState = playGame.makeMove(_gameState, isHorizontal, row, col);
    if (newState != oldState) {
      _lastEdgeRow = row;
      _lastEdgeCol = col;
      _lastEdgeIsHorizontal = isHorizontal;

      // Check if a box was completed by comparing scores
      if (oldState.scores != newState.scores) {
        // Find the newly completed box
        for (int i = 0; i < newState.gridSize; i++) {
          for (int j = 0; j < newState.gridSize; j++) {
            if (newState.boxes[i][j] != null && oldState.boxes[i][j] == null) {
              _lastBoxRow = i;
              _lastBoxCol = j;
              break;
            }
          }
        }
      } else {
        _lastBoxRow = null;
        _lastBoxCol = null;
      }

      _gameState = newState;
      notifyListeners();

      // Reset animation triggers after delay
      Future.delayed(const Duration(milliseconds: 300), () {
        _lastEdgeRow = null;
        _lastEdgeCol = null;
        _lastEdgeIsHorizontal = null;
        _lastBoxRow = null;
        _lastBoxCol = null;
        notifyListeners();
      });
    }
  }

  void restartGame() {
    _gameState = playGame.initialize(4);
    _lastEdgeRow = null;
    _lastEdgeCol = null;
    _lastEdgeIsHorizontal = null;
    _lastBoxRow = null;
    _lastBoxCol = null;
    notifyListeners();
  }
}