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

Future applyGameState(GameStruct game, String jsonData, int selfUserId,
    FlagStruct newEventsFlag) async {
  final dict = jsonDecode(jsonData);

  dict.forEach((userId, data) async {
    if (game.type != GameType.Duel || int.parse(userId) == selfUserId) {
      game.mistakes += data['mistakes'] as int;
      data['solved-cells'].forEach((xy) async {
        await setNumber(game, xy[0], xy[1], null, int.parse(userId));
      });
    }
  });

  newEventsFlag.isSet = true;
}
