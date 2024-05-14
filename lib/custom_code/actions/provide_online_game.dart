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

import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'dart:convert';

Future provideOnlineGame(GameStruct game, String authToken,
    FlagStruct newEventsFlag, int userId) async {
  try {
    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: 'http://sudoku-masters.ddns.net:8080/listen?channel=game.' +
            game.id.toString(),
        header: {
          "Accept": "text/event-stream",
          "Authorization": "Bearer " + authToken
        }).listen(
      (event) async {
        final data = jsonDecode(event.data!);

        switch (event.event) {
          case "start":
            game.startTimestamp = DateTime.parse(data['start-timestamp'] + 'Z');
            break;
          case "finish":
            if (data.containsKey('winner')) game.winnerId = data['winner'];

            game.timer = data['time'];
            newEventsFlag.isSet = true;
            SSEClient.unsubscribeFromSSE();
            break;
          case "mistake":
            if (game.type != GameType.Duel ||
                int.parse(data.entries.first.key) == userId) game.mistakes += 1;
            break;
          case "solve-cell":
            if (game.type == GameType.Duel) break;
            final elem = data.entries.first;
            await setNumber(
                game,
                elem.value[0],
                elem.value[1],
                getCell(game, elem.value[0], elem.value[1]).trueNumber,
                int.parse(elem.key));
        }

        newEventsFlag.isSet = true;
      },
    );
  } catch (e) {
    print(e);
  }
}
