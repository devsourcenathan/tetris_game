import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/piece.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';

/*

GAME BOARD
This is a 2x2 grid with null representing an empty space.
A non empty space will have the color to represent the landed pieces

*/

//create game board
List<List<Tetromino?>> gameBoard = List.generate(
  columnLength,
  (i) => List.generate(rowLength, (j) => null),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //current tetris piece
  Piece currentPiece = Piece(type: Tetromino.S);

  @override
  void initState() {
    super.initState();

    //start a game
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    //frame refresh rate

    Duration frameRate = const Duration(milliseconds: 700);
    gameLoop(frameRate);
  }

//game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        //check landing
        checkLanding();
        //move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  //collision detection
  bool checkCollision(Direction direction) {
    //loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calculate the row and the column of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      //adjust row and column based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      //check if the piece is out of the bounds (either too low or too far to the left or right)
      if (row >= columnLength || col < 0 || col >= rowLength) {
        return true;
      }
    }

    //if no collision are detected, return false
    return false;
  }

  void checkLanding() {
    //if going down is occupied
    if (checkCollision(Direction.down)) {
      //mark position as o in th game board
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  void createNewPiece() {
    //create a random object to generate random tetromino types
    Random random = Random();

    //create a piece with a random type
    Tetromino randomType =
        Tetromino.values[random.nextInt(Tetromino.values.length)];

    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
          itemCount: rowLength * columnLength,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: rowLength,
          ),
          itemBuilder: (context, index) {
            int row = (index / rowLength).floor();
            int col = index % rowLength;
            if (currentPiece.position.contains(index)) {
              return Pixel(
                color: Colors.green,
                child: index.toString(),
              );
            } else if (gameBoard[row][col] != null) {
              return Pixel(
                color: Colors.red,
                child: '',
              );
            } else {
              return Pixel(
                color: Colors.grey[900],
                child: index.toString(),
              );
            }
          }),
    );
  }
}
