import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';

String timerToStr(int timer) {
  int sec = timer % 60;
  int min = timer ~/ 60;
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}

double cellSize(
  double windowWidth,
  int sudokuSize,
) {
  return windowWidth / (sudokuSize + 2);
}

GameType? gameTypeFromStr(String typeStr) {
  switch (typeStr) {
    case 'Classic':
      return GameType.Classic;
    case 'Cooperative':
      return GameType.Cooperative;
    case 'Duel':
      return GameType.Duel;
  }
}

double tableFontSize(
  double windowHeight,
  int sudokuSize,
) {
  return windowHeight / 13 / math.sqrt(sudokuSize);
}

String tableDataFromNum(int? value) {
  const alph = 'abcdefghijklmnopqrstuvwxyz';

  if (value == null || value == 0) {
    return " ";
  }
  if (value < 10) {
    return value.toString();
  }

  return alph[value - 10];
}

List<bool> getCellNotes(
  GameStruct game,
  int x,
  int y,
) {
  return game.sudoku.field[x * game.sudoku.size + y].notes;
}

int sudokuSize(GameStruct game) {
  return game.sudoku.size;
}

bool isSetRight(
  GameStruct game,
  int x,
  int y,
) {
  return game.sudoku.field[x * game.sudoku.size + y].number ==
      game.sudoku.field[x * game.sudoku.size + y].trueNumber;
}

double numberButtonFontSize(double windowHeight) {
  return windowHeight / 38;
}

double timerFieldHeight(double windowHeight) {
  return windowHeight / 16;
}

List<CellStruct> fieldFromStr(String sudokuStr) {
  final fields = sudokuStr.split('\n\n').map((e) {
    final eNew = e.replaceAll('\n', '').split(' ');
    eNew.removeLast();
    return eNew.map(int.parse).toList();
  }).toList();

  return List.generate(
      fields[0].length,
      (i) => CellStruct(
          number: fields[0][i],
          trueNumber: fields[1][i],
          initial: fields[0][i] != 0,
          notes: List.generate(
              math.sqrt(fields[0].length).toInt() + 1, (i) => false)));
}

List<int> range(
  int start,
  int end,
) {
  return List.generate(end - start, (i) => i + start);
}

double numberButtonSize(
  double widnowWidth,
  int buttonsCount,
) {
  return (widnowWidth - 16) / 9 - 8;
}

Difficulty? difficultyFromStr(String difStr) {
  switch (difStr) {
    case 'easy':
      return Difficulty.Easy;
    case 'medium':
      return Difficulty.Medium;
    case 'hard':
      return Difficulty.Hard;
  }
}

bool isSolved(SudokuStruct sudoku) {
  return sudoku.field.where((cell) => cell.number != cell.trueNumber).length ==
      0;
}

CellStruct getCell(
  GameStruct game,
  int x,
  int y,
) {
  return game.sudoku.field[x * game.sudoku.size + y];
}

List<GameStruct> gamesFromJson(
  String jsonStr,
  int userId,
) {
  final games = json.decode(jsonStr);

  return List.generate(games.length, (i) {
    final dict = games[i];
    final game = GameStruct(
        id: dict['id'],
        type: gameTypeFromStr(dict['type']),
        players: List.generate(
            dict['players'].length,
            (i) => ((dct) => UserStruct(
                id: dct['id'],
                username: dct['username'],
                alias: dct['alias'],
                rating: dct['rating']))(dict['players'][i])),
        timer: dict['time'],
        winnerId: dict['winner'],
        sudoku: SudokuStruct(
            id: dict['sudoku']['id'],
            difficulty: difficultyFromStr(dict['sudoku']['difficulty']),
            size: dict['sudoku']['size'],
            field: fieldFromStr(dict['sudoku']['data'])));
    if (dict['start'] != null)
      game.startTimestamp = DateTime.parse(dict['start'] + 'Z');

    return game;
  }).toList();
}

String joinPlayersAlias(GameStruct game) {
  return game.players.map((e) => e.alias).join(', ');
}

int getGameIndex(
  List<GameStruct> games,
  int gameId,
) {
  for (int i = 0; i < games.length; ++i) if (games[i].id == gameId) return i;
  return -1;
}

bool isPlayerInGame(
  GameStruct game,
  UserStruct user,
) {
  return game.players.where((e) => e.id == user.id).length != 0;
}
