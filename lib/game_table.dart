import 'package:color_pop/block_table.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GameTable {

  int countRow;
  int countCol;
  List<List<BlockTable>> table;
  int score = 0;
  Color gameColor;

  GameTable(int countRow, int countCol) {
    this.countRow = countRow;
    this.countCol = countCol;
    this.gameColor = randomGameColor();
    init();
  }
  init() {
    table = List();
    for (int row = 0; row < countRow; row++) {
      List<BlockTable> listBlockTable = List();
      for (int col = 0; col < countCol; col++) {
        listBlockTable.add(BlockTable(row,col));
      }
      table.add(listBlockTable);
    }
  }
  BlockTable getBlockTable(int row, int col) {
    return table[row][col];
  }

  Color randomGameColor() {
    List<Color> gameColors = [Colors.yellow,Colors.green,Colors.blue,Colors.orange,Colors.pinkAccent];
    var rng = new Random();
    int random = rng.nextInt(5);
    return gameColors[random];
  }

  blockPressed(int row, int col) {
    table[row][col].isSelected = !table[row][col].isSelected;
  }
  String movement () {
    // This function will verify :
    //    - Nb of selected block > 3
    //    - Selected block same color (or include white)
    //    - Selected block are linked
    //    - Compute score
    //    - Update UI (Another function)
    List<BlockTable> selectedBlocks = List();
    for (int row = 0; row < countRow; row++) {
      for (int col = 0; col < countCol; col++) {
        BlockTable block = getBlockTable(row, col);
        if (block.isSelected) {
          selectedBlocks.add(block);
          print("Block Selected : ${block.row} : ${block.col}");
        }
      }
    }

    if (selectedBlocks.length < 3) {
      return "Veuillez sélectionner 3 cases ou plus";
    }

    Color mainColor;
    bool sameColor = true;
    for (int i = 0; i < selectedBlocks.length; i++) {
      if (selectedBlocks[i].color != Colors.white && mainColor == null) {
        mainColor = selectedBlocks[i].color;
      } else if (selectedBlocks[i].color != Colors.white && mainColor != null) {
        if (mainColor != selectedBlocks[i].color) {
          sameColor = false;
        }
      }
    }
    if (!sameColor) {
      return "Veuillez sélectionner des cases de même couleur";
    }

  }
  updateUI() {
    // This Function will :
    //    - Delete selected blocks
    //    - Deselect blocks
    //    - Move blocks to fit the new empty one
  }
}