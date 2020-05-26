import 'package:color_pop/block_table.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GameTable {

  int countRow;
  int countCol;
  List<List<BlockTable>> table;
  int score = 0;
  Color gameColor;

  List<BlockTable> tempSelectedBlocks = List();
  bool firstCall;

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
    //    - Nb of selected block >= 2
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

    if (selectedBlocks.length < 2) {
      return "Veuillez sélectionner 2 pions ou plus";
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
      return "Veuillez sélectionner des pions de même couleur";
    }

    tempSelectedBlocks.clear();
    tempSelectedBlocks = selectedBlocks;
    firstCall = true;
    neighbor(tempSelectedBlocks[0],List());
    if (tempSelectedBlocks.isEmpty) {
      return "OKKKKK";
    } else {
      for (int x = 0; x < tempSelectedBlocks.length; x++) {
        print("NOT EMPTY STILL : (${tempSelectedBlocks[x].row},${tempSelectedBlocks[x].col})");
      }
      return "NOT OKKKK";
    }



  }

  neighbor(BlockTable currentBlock, List<BlockTable> neigh) {
    // n1 - n4 are the 4 neighbor
    List<BlockTable> neighborList = neigh;
    BlockTable n1 = new BlockTable(currentBlock.row + 1, currentBlock.col);
    BlockTable n2 = new BlockTable(currentBlock.row - 1, currentBlock.col);
    BlockTable n3 = new BlockTable(currentBlock.row, currentBlock.col + 1);
    BlockTable n4 = new BlockTable(currentBlock.row, currentBlock.col - 1);

    print("SELECTED BLOCK : (${currentBlock.row},${currentBlock.col})");

    for (int i = 0; i < tempSelectedBlocks.length; i++) {
      print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n1.row},${n1.col}) ?? THEN N1 NEIGHBOR");
      print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n2.row},${n2.col}) ?? THEN N2 NEIGHBOR");
      print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n3.row},${n3.col}) ?? THEN N3 NEIGHBOR");
      print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n4.row},${n4.col}) ?? THEN N4 NEIGHBOR");
      if (tempSelectedBlocks[i].row == n1.row && tempSelectedBlocks[i].col == n1.col) {
        print("N1 NEIGHBOR");
        neighborList.add(n1);
      } else if (tempSelectedBlocks[i].row == n2.row && tempSelectedBlocks[i].col == n2.col) {
        print("N2 NEIGHBOR");
        neighborList.add(n2);
      } else if (tempSelectedBlocks[i].row == n3.row && tempSelectedBlocks[i].col == n3.col) {
        print("N3 NEIGHBOR");
        neighborList.add(n3);
      } else if (tempSelectedBlocks[i].row == n4.row && tempSelectedBlocks[i].col == n4.col) {
        print("N4 NEIGHBOR");
        neighborList.add(n4);
      } else if (!firstCall) {
        print("NO NEIGHBOR");
        remove(currentBlock);
      }
    }
    if (neighborList.isNotEmpty && neighborList != null && neighborList.length == 1) {
      firstCall = false;
      remove(currentBlock);
      neighbor(neighborList[0],List());
    } else if (neighborList.isNotEmpty && neighborList != null && neighborList.length > 1) {
      List<BlockTable> tempNeighborList = List();
      BlockTable block = (neighborList[0]);
      neighborList.removeAt(0);
      firstCall = false;
      for (int j = 0; j < neighborList.length; j++) {
        tempNeighborList.add(neighborList[j]);
      }
      remove(currentBlock);
      neighbor(block,tempNeighborList);
    }
  }
  remove(BlockTable currentBlock) { // TODO FIX WRONG REMOVE
    for (int i = 0; i < tempSelectedBlocks.length; i++) {
      if (currentBlock.row == tempSelectedBlocks[i].row && currentBlock.col == tempSelectedBlocks[i].col) {
        tempSelectedBlocks.removeAt(i);
      }
    }


  }
  updateUI() {
    // This Function will :
    //    - Delete selected blocks
    //    - Deselect blocks
    //    - Move blocks to fit the new empty one
    //    - Move columns if one is empty
  }
}