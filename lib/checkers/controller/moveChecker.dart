import 'package:checkers_game/checkers/model/boardModel.dart';

bool hasValidMoves(List<List<BoardData>> table, int player) {
  for (var row in table) {
    for (var cell in row) {
      if (cell.piece?.player == player) {
        // Check if this piece has any valid moves
        if (cell.piece!.isKing) {
          // Logic for king pieces (can move in all directions)
          if (_hasValidMove(table, cell, -1, -1, player) ||
              _hasValidMove(table, cell, -1, 1, player) ||
              _hasValidMove(table, cell, 1, -1, player) ||
              _hasValidMove(table, cell, 1, 1, player)) {
            return true;
          }
        } else {
          // Logic for regular pieces (move forward only based on player)
          int direction = (player == 1) ? 1 : -1;
          if (_hasValidMove(table, cell, direction, -1, player) ||
              _hasValidMove(table, cell, direction, 1, player)) {
            return true;
          }
        }
      }
    }
  }
  return false;
}

bool _hasValidMove(List<List<BoardData>> table, BoardData cell,
    int rowDirection, int colDirection, int player) {
  int newRow = cell.row + rowDirection;
  int newCol = cell.col + colDirection;

  if (newRow >= 0 &&
      newRow < table.length &&
      newCol >= 0 &&
      newCol < table[newRow].length) {
    BoardData targetCell = table[newRow][newCol];

    // Check if the target cell is empty
    if (targetCell.piece == null) {
      return true;
    }
    // Check if the target cell has an opponent's piece and the cell after it is empty
    else if (targetCell.piece!.player != player) {
      int captureRow = newRow + rowDirection;
      int captureCol = newCol + colDirection;

      if (captureRow >= 0 &&
          captureRow < table.length &&
          captureCol >= 0 &&
          captureCol < table[captureRow].length &&
          table[captureRow][captureCol].piece == null) {
        return true;
      }
    }
  }
  return false;
}
