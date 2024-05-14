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

Future setGameTimer(GameStruct game) async {
  if (game.winnerId != null && game.winnerId != 0) return;
  if (game.startTimestamp != null)
    game.timer =
        DateTime.now().toUtc().difference(game.startTimestamp!).inSeconds;
  else
    game.timer = 0;
}
