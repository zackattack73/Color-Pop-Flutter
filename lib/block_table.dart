import 'package:flutter/material.dart';
import 'dart:math';

class BlockTable {
  int row;
  int col;
  bool isSelected;
  Color color;

  BlockTable(int row, int col) {
    this.row = row;
    this.col = col;
    this.isSelected = false;
    this.color = randomColor();
  }

  Color randomColor() {
    List<Color> gameColors = [Colors.yellow,Colors.green,Colors.blue,Colors.orange,Colors.white,Colors.pinkAccent];
    var rng = new Random();
    int random = rng.nextInt(6);
    return gameColors[random];
  }
}