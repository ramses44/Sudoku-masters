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

Future storeMessages(
  MessageListStruct msgList,
  String authToken,
  int chatId,
) async {
  try {
    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: 'http://sudoku-masters.ddns.net:8080/listen?channel=message.' +
            chatId.toString(),
        header: {
          "Accept": "text/event-stream",
          "Authorization": "Bearer " + authToken
        }).listen(
      (event) {
        msgList.data.insert(0, MessageStruct.fromMap(json.decode(event.data!)));
        msgList.hasNewFlag = true;
      },
    );
  } catch (e) {
    print(e);
  }
}
