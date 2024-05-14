// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<bool> addNote(
  GameStruct game,
  int x,
  int y,
  int number,
) async {
  final cell = getCell(game, x, y);
  if (cell.number == cell.trueNumber) return false;

  cell.notes[number] = !cell.notes[number];

  return true;
}
