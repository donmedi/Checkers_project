import 'dart:developer';

import 'package:checkers_game/checkers/model/boardModel.dart';
import 'package:checkers_game/checkers/model/cordinateModel.dart';
import 'package:checkers_game/checkers/model/pieceModel.dart';
import 'package:checkers_game/checkers/controller/helpers.dart';
import 'package:flutter/material.dart';

class CheckersHome extends StatefulWidget {
  const CheckersHome({super.key});

  @override
  State<CheckersHome> createState() => _CheckersHomeState();
}

class _CheckersHomeState extends State<CheckersHome> {
  List<List<BoardData>> table = [];
  BoardData? _selectedPiece;
  bool isFirstTurn = true;
  bool _takeMore = false;
  int playerTurn = 1;
  int _canKill = 0;
  int _totalValidMove = 0;

  int checkP2(int index) {
    if (index < 3) {
      return 2;
    } else if (index > 6) {
      return 1;
    } else {
      return 0;
    }
  }

  void _createTable() {
    table = [];
    for (var row = 0; row < 8; row++) {
      List<BoardData> rowTable = [];
      for (var col = 0; col < 8; col++) {
        rowTable.add(BoardData(
          col: col,
          row: row,
          isBrown: (row + col) % 2 == 0 ? true : false,
          piece: (row + col) % 2 == 0 && (_rowCheck(row) || _rowCheck(row))
              ? PieceModel(
                  player: checkP2(row) == 2 ? 2 : 1,
                  cord: Coord(row: row, col: col))
              : null,
        ));
      }
      table.add(rowTable);
    }
  }

  bool _rowCheck(int index) {
    switch (index) {
      case 0:
        return true;
      case 1:
        return true;
      case 2:
        return true;
      case 7:
        return true;
      case 6:
        return true;
      case 5:
        return true;
      default:
        return false;
    }
  }

  bool isKilling = false;

  void _highlightNeighboringCells(BoardData selectedCell) {
    if (selectedCell.piece != null) {
      int player = selectedCell.piece!.player;
      int row = selectedCell.row;
      int col = selectedCell.col;

      // Highlight cells above for Player 1
      if (player == 1) {
        if (row >= 0) {
          if (col >= 0) {
            _checkAndHighlightCell(row - 1, col - 1, player, -1, -1);
            if (selectedCell.piece!.isKing) {
              _checkAndHighlightCell(row + 1, col - 1, player, 1, -1);
            }
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell(row - 1, col + 1, player, -1, 1);
            if (selectedCell.piece!.isKing) {
              _checkAndHighlightCell(row + 1, col + 1, player, 1, 1);
            }
          }
        }
      }
      // Highlight cells below for Player 2
      else if (player == 2) {
        log('logged $row');
        if (row + 1 <= table.length - 1) {
          if (col >= 0) {
            _checkAndHighlightCell(row + 1, col - 1, player, 1, -1);
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell(row + 1, col + 1, player, 1, 1);
          }
        }

        if (selectedCell.piece!.isKing) {
          if (col >= 0) {
            _checkAndHighlightCell(row - 1, col - 1, player, -1, -1);
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell(row - 1, col + 1, player, -1, 1);
          }
        }
        log('logged234');
      }
    }
  }

  void _checkAndHighlightCell(int row, int col, int player, int rw, int cl) {
    if (row >= 0 &&
        row <= table.length - 1 &&
        col >= 0 &&
        col <= table.length - 1) {
      if (table[row][col].piece == null) {
        setState(() {
          table[row][col].haveHighlight = true; // Highlight empty cell
        });
        // Check for enemy piece and highlight the empty cell after it
      } else if (table[row][col].piece != null &&
          table[row][col].piece!.player != player) {
        int enemyRow = row + (row - table[row][col].row);
        int enemyCol = col + (col - table[row][col].col);

        if (enemyRow >= 0 &&
            enemyRow <= table.length - 1 &&
            enemyCol >= 0 &&
            enemyCol <= table.length - 1 &&
            table[enemyRow][enemyCol].piece != null &&
            table[enemyRow][enemyCol].piece!.player != player) {
          int nextRow = enemyRow += rw;
          int nextCol = enemyCol += cl;

          if (nextRow >= 0 &&
              nextRow <= table.length - 1 &&
              nextCol >= 0 &&
              nextCol <= table.length - 1 &&
              table[nextRow][nextCol].piece == null) {
            setState(() {
              table[nextRow][nextCol].haveHighlight = true;
            });
          }
        }
      }
    }
  }

  void _checkPlayerMove(BoardData data) {
    if (data.piece!.player == 1 && data.row == 0) {
      setState(() {
        data.piece!.isKing = true;
      });
    } else if (data.piece!.player == 2 && data.row == table.length - 1) {
      setState(() {
        data.piece!.isKing = true;
      });
    } else {
      log('not king');
    }
  }

  void _resetHighlight() {
    for (var element in table) {
      for (var data in element) {
        setState(() {
          data.haveHighlight = false;
        });
      }
    }
  }

  bool? hasMoves;

  Widget buildColumn(BoardData data, double cellSize) {
    return InkWell(
        onTap: () {
          // log('data loc ${data.row} ${data.col} ${data.piece}');
          if (_canKill < 1) {
            _handleMove(data);
          } else {
            if (data.haveHighlight) {
              _handleMove(data);
            } else {
              log("can't click");
            }
          }
        },
        child: Container(
            width: cellSize * 0.8,
            height: cellSize * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                  color: _selectedPiece?.col == data.col &&
                          _selectedPiece?.row == data.row
                      ? Colors.orangeAccent
                      : Colors.transparent,
                  width: 3),
              color: ((data.row + data.col) % 2 == 0
                  ? const Color(0xffA86464)
                  : Colors.white),
            ),
            child: Center(
                child: !data.haveHighlight
                    ? buildPieceWidget(data.piece, cellSize)
                    : Container(
                        width: cellSize * 0.5,
                        height: cellSize * 0.5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: cellSize * 0.05,
                                color: Color.fromARGB(139, 255, 255, 255))),
                      ))));
  }

  Widget buildRow(List<BoardData> rowData, double cellSize) {
    List<Widget> columns = [];
    for (var data in rowData) {
      columns.add(buildColumn(data, cellSize));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns,
    );
  }

  Widget buildPieceWidget(PieceModel? piece, double cellSize) {
    if (piece == null) {
      return Container();
    } else {
      return piece.isKing
          ? Container(
              width: cellSize * 0.5,
              height: cellSize * 0.5,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: piece.player == 1
                    ? const Color(0xff39A7FF)
                    : const Color(0xffFF6969),
                border:
                    Border.all(color: Colors.yellow, width: cellSize * 0.07),
              ),
              child: Image.asset(
                'assets/crown.png',
                height: 10,
                width: 10,
              ))
          : Container(
              width: cellSize * 0.5,
              height: cellSize * 0.5,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: piece.player == 1
                      ? const Color(0xff39A7FF)
                      : const Color(0xffFF6969),
                  border: Border.all(
                      color: Colors.black87, width: cellSize * 0.08)),
            );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createTable();
  }

  bool isTablet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >
        600; // You can adjust this threshold based on your design
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Container(
            padding: EdgeInsets.all(24),
            child: Text(
              'Next Turn: Player $playerTurn',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            )),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double cellSize = constraints.maxWidth / 8; // Assuming 8 columns

        return Center(
          child: Container(
              margin: !isTablet(context)
                  ? EdgeInsets.all(cellSize * 0.2)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(width: cellSize * 0.2, color: Colors.black)),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: table.map((e) => buildRow(e, cellSize)).toList())),
        );
      }),
    );
  }

  void _handleMove(BoardData data) {
    if (_selectedPiece != null && data.haveHighlight) {
      setState(() {
        data.piece = _selectedPiece!.piece;
        _canKill = 0;
        // table[_selectedPiece!.row][_selectedPiece!.col].piece = null;
      });
      _checkPlayerMove(data);

      int enemyRow = (_selectedPiece!.row + data.row) ~/ 2;
      int enemyCol = (_selectedPiece!.col + data.col) ~/ 2;
      // log('enemy row $enemyRow & col $enemyCol');
      if (table[enemyRow][enemyCol].piece != null &&
          table[enemyRow][enemyCol].piece!.player != data.piece!.player) {
        // Check if the move is a diagonal jump
        if (enemyRow >= 0 &&
            enemyRow < table.length - 1 &&
            enemyCol >= 0 &&
            enemyCol < table[enemyRow].length - 1 &&
            table[enemyRow][enemyCol].piece != null &&
            table[enemyRow][enemyCol].piece!.player !=
                _selectedPiece!.piece!.player) {
          // Capture the enemy piece by setting it to null
          table[enemyRow][enemyCol].piece = null;
          _resetHighlight();
          _highlightNeighboringCells2(data);
          if (_canKill > 0) {
            // _resetHighlight();
            setState(() {
              _selectedPiece!.piece = null;
              _selectedPiece = data;
            });
          }
          // Check for additional captures
        }
      }

      if (_canKill == 0) {
        setState(() {
          _selectedPiece!.piece = null;
          playerTurn = playerTurn == 1 ? 2 : 1;
        });
        // Reset highlights
        _resetHighlight();
        checkWinner(context, table);
        setState(() {
          _selectedPiece = null;
        });

        log('${isNoValidMovesLeft(playerTurn)}');
        if (!isNoValidMovesLeft(playerTurn)) {
          log('player $playerTurn has moves');
        } else {
          showWinnerDialog(context, playerTurn == 1 ? '2' : '1');
          log('player $playerTurn has no moves');
        }
      }
      // Clear the previous cell
    } else {
      // Set the selected piece
      if (data.piece != null && (playerTurn == data.piece!.player)) {
        setState(() {
          _selectedPiece = data;
          _canKill = 0;
        });
        // Reset highlights
        _resetHighlight();
        // Highlight neighboring cells
        _highlightNeighboringCells(data);
      } else {
        _resetHighlight();
        setState(() {
          _selectedPiece = null;
        });
      }
    }
  }

  void _endTurn() {
    // Clear the previous cell
    setState(() {
      _selectedPiece!.piece = null;
      playerTurn = playerTurn == 1 ? 2 : 1;
    });
    // Reset highlights
    _resetHighlight();
    // Check for a winner and reset selected piece
    checkWinner(context, table);
    setState(() {
      _selectedPiece = null;
    });
  }

  void _highlightNeighboringCells2(BoardData selectedCell) {
    // log('called 2nd');
    if (selectedCell.piece != null) {
      int player = selectedCell.piece!.player;
      int row = selectedCell.row;
      int col = selectedCell.col;

      // Highlight cells above for Player 1
      if (player == 1) {
        if (row >= 0) {
          if (col >= 0) {
            _checkAndHighlightCell2(row - 1, col - 1, player, -1, -1);
            if (selectedCell.piece!.isKing) {
              _checkAndHighlightCell2(row + 1, col - 1, player, 1, -1);
            }
          }
          if (col <= table.length - 1) {
            _checkAndHighlightCell2(row - 1, col + 1, player, -1, 1);
            if (selectedCell.piece!.isKing) {
              _checkAndHighlightCell2(row + 1, col + 1, player, 1, 1);
            }
          }
        }
      }
      // Highlight cells below for Player 2
      else if (player == 2) {
        // log('logged $row');
        if (row + 1 <= table.length - 1) {
          if (col >= 0) {
            _checkAndHighlightCell2(row + 1, col - 1, player, 1, -1);
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell2(row + 1, col + 1, player, 1, 1);
          }
        }

        if (selectedCell.piece!.isKing) {
          if (col >= 0) {
            _checkAndHighlightCell2(row - 1, col - 1, player, -1, -1);
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell2(row - 1, col + 1, player, -1, 1);
          }
        }
        // log('log more');
      }
    }
  }

  void _checkAndHighlightCell2(int row, int col, int player, int rw, int cl) {
    if (row >= 0 &&
        row <= table.length - 1 &&
        col >= 0 &&
        col <= table.length - 1) {
      if (table[row][col].piece != null &&
          table[row][col].piece!.player != player) {
        int enemyRow = row + (row - table[row][col].row);
        int enemyCol = col + (col - table[row][col].col);

        if (enemyRow >= 0 &&
            enemyRow <= table.length - 1 &&
            enemyCol >= 0 &&
            enemyCol <= table.length - 1 &&
            table[enemyRow][enemyCol].piece != null &&
            table[enemyRow][enemyCol].piece!.player != player) {
          int nextRow = enemyRow += rw;
          int nextCol = enemyCol += cl;

          if (nextRow >= 0 &&
              nextRow <= table.length - 1 &&
              nextCol >= 0 &&
              nextCol <= table.length - 1 &&
              table[nextRow][nextCol].piece == null) {
            setState(() {
              table[nextRow][nextCol].haveHighlight = true;
              _canKill = 1;
            });
            // _canKill += 1;
          }
        }
      }
    }
    log('take more $_canKill');
  }

  bool isNoValidMovesLeft(int player) {
    setState(() {
      _totalValidMove = 0;
    });
    for (var row in table) {
      for (var data in row) {
        if (data.piece != null && data.piece!.player == player) {
          _highlightNeighboringCells3(data);
        }
      }
    }
    log('available m0ve $_totalValidMove');
    if (_totalValidMove == 0) {
      return true;
    } else {
      return false;
    }
    // No valid moves left
  }

  void _highlightNeighboringCells3(BoardData selectedCell) {
    if (selectedCell.piece != null) {
      int player = selectedCell.piece!.player;
      int row = selectedCell.row;
      int col = selectedCell.col;

      // Highlight cells above for Player 1
      if (player == 1) {
        if (row >= 0) {
          if (col >= 0) {
            _checkAndHighlightCell3(row - 1, col - 1, player, -1, -1);
          }
          if (selectedCell.piece!.isKing) {
            _checkAndHighlightCell3(row + 1, col - 1, player, 1, -1);
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell3(row - 1, col + 1, player, -1, 1);
          }
          if (selectedCell.piece!.isKing) {
            _checkAndHighlightCell3(row + 1, col + 1, player, 1, 1);
          }
        }
      }
      // Highlight cells below for Player 2
      else if (player == 2) {
        if (row + 1 <= table.length - 1) {
          if (col >= 0) {
            _checkAndHighlightCell3(row + 1, col - 1, player, 1, -1);
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell3(row + 1, col + 1, player, 1, 1);
          }
        }

        if (selectedCell.piece!.isKing) {
          if (col >= 0) {
            _checkAndHighlightCell3(row - 1, col - 1, player, -1, -1);
          }
          if (col + 1 <= table.length - 1) {
            _checkAndHighlightCell3(row - 1, col + 1, player, -1, 1);
          }
        }
      }
    }
  }

  void _checkAndHighlightCell3(int row, int col, int player, int rw, int cl) {
    if (row >= 0 &&
        row <= table.length - 1 &&
        col >= 0 &&
        col <= table.length - 1) {
      if (table[row][col].piece == null) {
        setState(() {
          _totalValidMove = _totalValidMove += 1;
        });
        // Check for enemy piece and highlight the empty cell after it
      } else if (table[row][col].piece != null &&
          table[row][col].piece!.player != player) {
        int enemyRow = row + (row - table[row][col].row);
        int enemyCol = col + (col - table[row][col].col);

        if (enemyRow >= 0 &&
            enemyRow <= table.length - 1 &&
            enemyCol >= 0 &&
            enemyCol <= table.length - 1 &&
            table[enemyRow][enemyCol].piece != null &&
            table[enemyRow][enemyCol].piece!.player != player) {
          int nextRow = enemyRow += rw;
          int nextCol = enemyCol += cl;

          if (nextRow >= 0 &&
              nextRow <= table.length - 1 &&
              nextCol >= 0 &&
              nextCol <= table.length - 1 &&
              table[nextRow][nextCol].piece == null) {
            setState(() {
              _totalValidMove = _totalValidMove += 1;
            });
            // setState(() {
            //   table[nextRow][nextCol].haveHighlight = true;
            // });
          }
        }
      }
    }
  }
}
