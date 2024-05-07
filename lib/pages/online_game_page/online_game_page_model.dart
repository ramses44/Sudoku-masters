import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'online_game_page_widget.dart' show OnlineGamePageWidget;
import 'package:flutter/material.dart';

class OnlineGamePageModel extends FlutterFlowModel<OnlineGamePageWidget> {
  ///  Local state fields for this page.

  int? selectedCellX;

  int? selectedCellY;

  int? selectedNumber;

  bool eraserMode = false;

  bool pencilMode = false;

  FlagStruct? newEventsFlag;
  void updateNewEventsFlagStruct(Function(FlagStruct) updateFn) =>
      updateFn(newEventsFlag ??= FlagStruct());

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (getGameState)] action in OnlineGamePage widget.
  ApiCallResponse? gameStateRes;
  InstantTimer? instantTimer;
  InstantTimer? timeTimer;
  // Stores action output result for [Custom Action - addNote] action in Button widget.
  bool? putNoteRes;
  // Stores action output result for [Custom Action - setNumber] action in Button widget.
  bool? putNumberRes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    instantTimer?.cancel();
    timeTimer?.cancel();
  }
}
