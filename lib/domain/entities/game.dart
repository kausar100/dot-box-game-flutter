class Game {
  final int gridSize;
  final int currentPlayer;
  final List<int> scores;
  final bool gameOver;

  Game({
    required this.gridSize,
    required this.currentPlayer,
    required this.scores,
    required this.gameOver,
  });
}