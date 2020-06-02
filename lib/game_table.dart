import 'package:color_pop/block_table.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GameTable {
  int countRow;
  int countCol;
  List<List<BlockTable>> table;
  int score = 0;
  Color gameColor;
  int firstEmptyCol = 10;

  List<BlockTable> tempSelectedBlocks = List();

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
        listBlockTable.add(BlockTable(row, col));
      }
      table.add(listBlockTable);
    }
  }

  BlockTable getBlockTable(int row, int col) {
    return table[row][col];
  }

  Color randomGameColor() {
    List<Color> gameColors = [Colors.yellow, Colors.green, Colors.blue, Colors.orange, Colors.pinkAccent];
    var rng = new Random();
    int random = rng.nextInt(5);
    return gameColors[random];
  }

  blockPressed(int row, int col) {
    if (table[row][col].color != Colors.black) {
      table[row][col].isSelected = !table[row][col].isSelected;
    }
  }

  String movement() {
    // This function will verify :
    //    - Nb of selected block >= 2 [A]
    //    - Selected block same color (or include white) [B]
    //    - Selected block are linked [C]
    //    - Compute score [D]
    //    - Update UI (Another function) [E]

    // [A]
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

    // [B]
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

    // [C]
    tempSelectedBlocks.clear();
    tempSelectedBlocks = selectedBlocks.toList();
    neighbor(tempSelectedBlocks[0], List());
    if (tempSelectedBlocks.isNotEmpty) {
      for (int x = 0; x < tempSelectedBlocks.length; x++) {
        print("NOT EMPTY STILL : (${tempSelectedBlocks[x].row},${tempSelectedBlocks[x].col})");
      }
      return "Veuillez sélectionner des pions adjacents";
    }

    // [E]
    updateUI(selectedBlocks);

    return "score";
  }

  neighbor(BlockTable currentBlock, List<BlockTable> neigh) {
    if (tempSelectedBlocks.length != 0) {
      remove(currentBlock);
      /*print("Length : "+tempSelectedBlocks.length.toString());
      for (int z = 0; z < tempSelectedBlocks.length; z++) {
        print("Block number $z : (${tempSelectedBlocks[z].row},${tempSelectedBlocks[z].col})");
      }*/

      // Neighbors of block X
      //      |     |
      //      |  N2 |
      // _____|_____|_____
      //      |     |
      //   N4 |  X  |  N3
      // _____|_____|_____
      //      |     |
      //      |  N1 |
      //      |     |

      List<BlockTable> neighborList = neigh;
      BlockTable n1 = new BlockTable(currentBlock.row + 1, currentBlock.col);
      BlockTable n2 = new BlockTable(currentBlock.row - 1, currentBlock.col);
      BlockTable n3 = new BlockTable(currentBlock.row, currentBlock.col + 1);
      BlockTable n4 = new BlockTable(currentBlock.row, currentBlock.col - 1);

      print("SELECTED BLOCK : (${currentBlock.row},${currentBlock.col})");

      for (int i = 0; i < tempSelectedBlocks.length; i++) {
        /*print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n1.row},${n1.col}) ?? THEN N1 NEIGHBOR");
        print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n2.row},${n2.col}) ?? THEN N2 NEIGHBOR");
        print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n3.row},${n3.col}) ?? THEN N3 NEIGHBOR");
        print("Selected : (${tempSelectedBlocks[i].row},${tempSelectedBlocks[i].col}) == (${n4.row},${n4.col}) ?? THEN N4 NEIGHBOR");*/
        if (tempSelectedBlocks[i].row == n1.row && tempSelectedBlocks[i].col == n1.col) {
          //print("N1 NEIGHBOR");
          neighborList.add(n1);
        } else if (tempSelectedBlocks[i].row == n2.row && tempSelectedBlocks[i].col == n2.col) {
          //print("N2 NEIGHBOR");
          neighborList.add(n2);
        } else if (tempSelectedBlocks[i].row == n3.row && tempSelectedBlocks[i].col == n3.col) {
          //print("N3 NEIGHBOR");
          neighborList.add(n3);
        } else if (tempSelectedBlocks[i].row == n4.row && tempSelectedBlocks[i].col == n4.col) {
          //print("N4 NEIGHBOR");
          neighborList.add(n4);
        }
      }
      if (neighborList.isNotEmpty && neighborList != null && neighborList.length == 1) {
        neighbor(neighborList[0], List());
      } else if (neighborList.isNotEmpty && neighborList != null && neighborList.length > 1) {
        List<BlockTable> tempNeighborList = List();
        BlockTable block = (neighborList[0]);
        neighborList.removeAt(0);
        for (int j = 0; j < neighborList.length; j++) {
          tempNeighborList.add(neighborList[j]);
        }
        neighbor(block, tempNeighborList);
      }
    }
  }

  remove(BlockTable currentBlock) {
    for (int i = 0; i < tempSelectedBlocks.length; i++) {
      if (currentBlock.row == tempSelectedBlocks[i].row && currentBlock.col == tempSelectedBlocks[i].col) {
        tempSelectedBlocks.removeAt(i);
      }
    }
  }

  updateUI(List<BlockTable> selectedBlocks) {
    // This Function will :
    //    - Delete selected blocks [1]
    //    - Deselect blocks [2]
    //    - Move blocks to fit the new empty one [3]
    //    - Move columns if one is empty [4]

    // [1] & [2]
    for (int i = 0; i < selectedBlocks.length; i++) {
      table[selectedBlocks[i].row][selectedBlocks[i].col].isSelected = !table[selectedBlocks[i].row][selectedBlocks[i].col].isSelected;
      table[selectedBlocks[i].row][selectedBlocks[i].col].color = Colors.black;
      moveUpperNeighbor(selectedBlocks[i]);
    }

    moveColumns();
  }

  // [3]
  moveUpperNeighbor(BlockTable currentBlock) {
    // TODO ADD ANIMATION ?
    if (currentBlock.row - 1 >= 0) {
      BlockTable n2 = getBlockTable(currentBlock.row - 1, currentBlock.col);
      if (n2.color != Colors.black) {
        table[currentBlock.row][currentBlock.col].color = n2.color;
        table[n2.row][n2.col].color = Colors.black;
        moveUpperNeighbor(n2);
      } else {
        table[currentBlock.row][currentBlock.col].color = Colors.black;
      }
    }
    // INFINITE VERSION BELOW
    /* BlockTable n2 = new BlockTable(currentBlock.row - 1, currentBlock.col);
    if (n2.row >= 0 && n2.color != Colors.black) {
      table[currentBlock.row][currentBlock.col].color = n2.color;
      moveUpperNeighbor(n2);
    } */
  }

  // [4]
  moveColumns() {
    List<int> emptyColNumber = List();
    for (int col = 0; col < countCol; col++) {
      for (int row = 0; row < countRow;) {
        if (table[row][col].color != Colors.black) {
          row = countRow;
        } else if (row + 1 == countRow) {
          emptyColNumber.add(col);
          print("EMPTY COLUMN ADDED : $col");
          row++;
        } else {
          row++;
        }
      }
    }

    emptyColNumber.sort();
    /*emptyColNumber.forEach((column) {
      if (column < 9) {
        for (int row = 0; row < countRow;) {
          table[row][column].color = table[row][column+1].color;
        }
      }
    });*/
  }
}
