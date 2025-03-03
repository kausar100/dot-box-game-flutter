class GameState {
  final int gridSize;
  final List<List> horizontalEdges;
  final List<List> verticalEdges;
  final List<List> boxes;
  final List<List> horizontalEdgeOwners;
  final List<List> verticalEdgeOwners;
  final int currentPlayer;
  final List<int> scores;
  final bool gameOver;

  GameState({
    required this.gridSize,
    required this.horizontalEdges,
    required this.verticalEdges,
    required this.boxes,
    required this.horizontalEdgeOwners,
    required this.verticalEdgeOwners,
    required this.currentPlayer,
    required this.scores,
    required this.gameOver,
  });

  GameState copyWith({
    int? gridSize,
    List<List>? horizontalEdges,
    List<List>? verticalEdges,
    List<List>? boxes,
    List<List>? horizontalEdgeOwners,
    List<List>? verticalEdgeOwners,
    int? currentPlayer,
    List<int>? scores,
    bool? gameOver,
  }) {
    return GameState(
      gridSize: gridSize ?? this.gridSize,
      horizontalEdges: horizontalEdges ?? this.horizontalEdges,
      verticalEdges: verticalEdges ?? this.verticalEdges,
      boxes: boxes ?? this.boxes,
      horizontalEdgeOwners: horizontalEdgeOwners ?? this.horizontalEdgeOwners,
      verticalEdgeOwners: verticalEdgeOwners ?? this.verticalEdgeOwners,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      scores: scores ?? this.scores,
      gameOver: gameOver ?? this.gameOver,
    );
  }
}