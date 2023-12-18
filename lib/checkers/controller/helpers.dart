import 'dart:developer';

import 'package:flutter/material.dart';

void checkWinner(context, List table) {
  int p1 = 0;
  int p2 = 0;

  for (var row in table) {
    for (var cell in row) {
      if (cell.piece != null) {
        if (cell.piece!.player == 1) {
          p1 = p1 += 1;
        } else {
          p2 = p2 += 1;
        }
      }
    }
  }

  if (p1 == 0) {
    showWinnerDialog(context, 'p2 wins');
  } else if (p2 == 0) {
    showWinnerDialog(context, 'p1 wins');
  } else {
    log('remains p1= $p1 p2 = $p2');
  }
}

void showWinnerDialog(context, String winner) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(child: WinnerModalWidget(winner: winner));
    },
  );
}

class WinnerModalWidget extends StatelessWidget {
  String winner;
  WinnerModalWidget({super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Winner!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Player $winner - wins!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}
