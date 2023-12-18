// ignore_for_file: prefer_initializing_formals

import 'package:checkers_game/checkers/model/cordinateModel.dart';

class PieceModel {
  bool isDead;
  int player;
  bool isKing;
  late Coord cord;

  PieceModel(
      {this.isDead = false,
      required this.player,
      this.isKing = false,
      required Coord cord})
      : cord = cord;
}
