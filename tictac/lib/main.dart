import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: TicTacToeGame(),
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TicTacToeConsole(),
    );
  }
}

class TicTacToeConsole extends StatefulWidget {
  @override
  _TicTacToeConsoleState createState() => _TicTacToeConsoleState();
}

class _TicTacToeConsoleState extends State<TicTacToeConsole> {
  late List<String> board;
  late int currentPlayer;
  late bool gameFinished;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    board = List.filled(9, ' ');
    currentPlayer = 1;
    gameFinished = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Player $currentPlayer's turn", style: TextStyle(fontSize: 20)),
        buildBoard(),
        if (gameFinished)
          Text(
            gameFinished && !checkWin() ? "It's a draw!" : "Player $currentPlayer wins!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              initializeGame();
            });
          },
          child: Text('Reset Game'),
        ),
      ],
    );
  }

  Widget buildBoard() {
    return Column(
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            int index = row * 3 + col;
            return GestureDetector(
              onTap: () {
                if (!gameFinished && isValidMove(index)) {
                  makeMove(index);
                  checkGameStatus();
                }
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Text(
                    board[index],
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  bool isValidMove(int position) {
    return board[position] == ' ';
  }

  void makeMove(int position) {
    setState(() {
      board[position] = currentPlayer == 1 ? 'X' : 'O';
      currentPlayer = 3 - currentPlayer; // Toggle between 1 and 2
    });
  }

  void checkGameStatus() {
    if (checkWin() || isBoardFull()) {
      setState(() {
        gameFinished = true;
      });
    }
  }

  bool checkWin() {
    // Check rows, columns, and diagonals
    return (checkRow(0, 1, 2) ||
        checkRow(3, 4, 5) ||
        checkRow(6, 7, 8) ||
        checkRow(0, 3, 6) ||
        checkRow(1, 4, 7) ||
        checkRow(2, 5, 8) ||
        checkRow(0, 4, 8) ||
        checkRow(2, 4, 6));
  }

  bool checkRow(int a, int b, int c) {
    return (board[a] != ' ' && board[a] == board[b] && board[b] == board[c]);
  }

  bool isBoardFull() {
    return !board.contains(' ');
  }
}
