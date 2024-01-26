import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrabble/api/api_handler.dart';
import 'package:scrabble/data/tiles.dart';
import 'package:scrabble/global.dart';
import '../board/currentTiles.dart';
import '../data/dictionary.dart';
import '../data/points.dart';
import '../data/tiles_bag.dart';

class HomeProvider extends ChangeNotifier {
  int points = 0;
  int remainingTiles = 93;
  int opponentPoints = 0;
  final random = Random();

  bool openingMove = true;

  List<CurrentTiles> currentTiles = [
    CurrentTiles(txt: 'y'),
    CurrentTiles(txt: 't'),
    CurrentTiles(txt: 'o'),
    CurrentTiles(txt: 'j'),
    CurrentTiles(txt: 'k'),
    CurrentTiles(txt: 'e'),
    CurrentTiles(txt: 'o'),
  ];

  // List<CurrentTiles> opponentTiles = [
  //   CurrentTiles(txt: 'a'),
  //   CurrentTiles(txt: 'p'),
  //   CurrentTiles(txt: 'o'),
  //   CurrentTiles(txt: 'i'),
  //   CurrentTiles(txt: 'u'),
  //   CurrentTiles(txt: 'y'),
  //   CurrentTiles(txt: 'r'),
  // ];

  String recentTile = '';

  List<String> addedTilesIndex = [];
  List<int> bottomTilesIndex = [];

  List<int> rows = [];
  List<int> cols = [];

  addTile(int rowIndex, int colIndex, int recentTileIndex) {
    if (recentTile != '') {
      bottomTilesIndex.add(recentTileIndex);
      // print('Empty: ${tiles[rowIndex][colIndex].isEmpty}');
      if (tiles[rowIndex][colIndex].isEmpty == true) {
        tiles[rowIndex][colIndex].txt = recentTile;
        tiles[rowIndex][colIndex].isEmpty = false;
        currentTiles[recentTileIndex].isAdded = true;

        // print('Added: ${currentTiles[recentTileIndex].isAdded}');
        // print('Text: ${tiles[rowIndex][colIndex].txt}');
        // print('recentTile: $recentTile');
        recentTile = '';

        addedTilesIndex.add('$rowIndex,$colIndex');

        notifyListeners();
      }
    }
  }

  submit(BuildContext context) async {
    if (addedTilesIndex.isNotEmpty && myTurn) {
      List<String> word = [];
      bool isValid = false;

      for (String i in addedTilesIndex) {
        rows.add(int.parse(i.split(',')[1]));
        cols.add(int.parse(i.split(',')[0]));
      }

      print(rows);
      print(cols);

      if (rows.first == rows.last) {
        print('Horizontal');

        for (int i = cols.first; i <= cols.last; i++) {
          word.add(tiles[i][rows.first].txt);
        }
      }
      if (cols.first == cols.last) {
        print('Vertical');

        for (int i = rows.first; i <= rows.last; i++) {
          word.add(tiles[cols.first][i].txt);
        }
      }

      if (!words.contains(word)) {
        letterPoints.forEach((key, value) {
          if (word.contains(key.toLowerCase())) {
            points += value;
          }
          print(points);
        });

        isValid = true;
        print('Valid Word');

        //String indexes = generateIndexes(rows, cols);

        for (var i = 0; i < word.length; i++) {
          var res = await ApiHandler.instance.addTurn(
            char: word[i],
            rowIndex: rows[i],
            colIndex: cols[i],
            playerId: userData['username'],
            gameId: gameDetails['id'],
          );
          print(res);
        }

        // if (res == "Move Inserted") {
        // final snackBar = SnackBar(
        //   content: Text('Valid Word'),
        //   duration: Duration(seconds: 2),
        //   behavior: SnackBarBehavior.floating,
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

        for (int i in bottomTilesIndex) {
          var keys = tilesBag.keys.where((key) => tilesBag[key] != 0).toList();
          currentTiles[i] = CurrentTiles(
              txt: keys[random.nextInt(keys.length)], isAdded: false);

          tilesBag[currentTiles[i].txt.toUpperCase()]--;
          remainingTiles--;
        }

        // indexes = "";
        word.clear();
        addedTilesIndex.clear();
        bottomTilesIndex.clear();
        cols.clear();
        rows.clear();
        rowIndex.clear();
        colIndex.clear();
        //}
      } else {
        isValid = false;
        print('Invalid Word');
        final snackBar = SnackBar(
          content: Text('Invalid Word'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    notifyListeners();
  }

  removeTile() {
    notifyListeners();
  }

  String generateIndexes(List<int> rows, List<int> cols) {
    List<String> indexList = [];

    for (int i = 0; i < rows.length && i < cols.length; i++) {
      String indexPair = '(${rows[i]},${cols[i]})';
      indexList.add(indexPair);
    }

    return indexList.join(',');
  }

  undoTiles() {
    for (String i in addedTilesIndex) {
      rows.add(int.parse(i.split(',')[1]));
      cols.add(int.parse(i.split(',')[0]));
    }

    for (int i in bottomTilesIndex) {
      for (int i = 0; i < cols.length; i++) {
        tiles[cols[i]][rows[i]].txt = '';
        tiles[cols[i]][rows[i]].isEmpty = true;
      }
      currentTiles[i].isAdded = false;
    }
    rows = [];
    cols = [];
    addedTilesIndex.clear();
    bottomTilesIndex.clear();
    notifyListeners();
  }

  void getTiles() {
    for (int i = 0; i < 7; i++) {
      var keys = tilesBag.keys.where((key) => tilesBag[key] != 0).toList();
      currentTiles[i] =
          CurrentTiles(txt: keys[random.nextInt(keys.length)], isAdded: false);

      tilesBag[currentTiles[i].txt.toUpperCase()]--;
    }
  }

  bool myTurn = true;
  int timer = 30;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timer > 0) {
        timer--;
        notifyListeners();
      } else {
        myTurn = !myTurn;
        timer = 30;
        notifyListeners();
      }
    });
  }

  void resetTimer() {
    timer = 0;
    myTurn != myTurn;
    notifyListeners();
  }

  List<int> rowIndex = [];
  List<int> colIndex = [];

  void getMoves(Map<String, dynamic> data) {
    // String indexString = data['letter_index'];
    // print(indexString);
    // List<String> characters = data['move'].split('');

    // List<String> moves = indexString.split(RegExp(r'\),\('));

    // for (String pair in moves) {
    //   List<String> coordinates =
    //       pair.replaceAll('(', '').replaceAll(')', '').split(',');

    //   int x = int.parse(coordinates[0]);
    //   int y = int.parse(coordinates[1]);
    //   if (!rowIndex.contains(x) && !colIndex.contains(y)) {
    //     rowIndex.add(x);
    //     colIndex.add(y);
    //   }
    // }
    for (int i = 0; i < data['moves'].length; i++) {
      tiles[data['moves'][i]['colIndex']][data['moves'][i]['rowIndex']].txt =
          data['moves'][i]['char'];
      tiles[data['moves'][i]['colIndex']][data['moves'][i]['rowIndex']]
          .isEmpty = false;
    }

    notifyListeners();
  }

  void clearVariables() {
    points = 0;
    remainingTiles = 100;
    opponentPoints = 0;
    openingMove = true;
    currentTiles.clear();
    recentTile = '';
    addedTilesIndex.clear();
    bottomTilesIndex.clear();
    rows.clear();
    cols.clear();
    resetTimer();
  }
}
