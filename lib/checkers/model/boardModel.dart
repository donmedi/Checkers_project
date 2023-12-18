import 'package:checkers_game/checkers/model/pieceModel.dart';

class BoardData {
  int row;
  int col;
  PieceModel? piece;
  bool isBrown = false;
  bool haveHighlight = false;
  // bool isPlayable = false;

  BoardData(
      {required this.col,
      required this.row,
      required this.piece,
      // required this.isPlayable,
      this.isBrown = false,
      this.haveHighlight = false});
}
