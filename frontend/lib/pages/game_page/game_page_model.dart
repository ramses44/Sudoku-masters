import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'game_page_widget.dart' show GamePageWidget;
import 'package:flutter/material.dart';

class GamePageModel extends FlutterFlowModel<GamePageWidget> {
  ///  Local state fields for this page.

  int? selectedCellX;

  int? selectedCellY;

  bool? paused = false;

  int? selectedNumber;

  bool eraserMode = false;

  bool pencilMode = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  InstantTimer? instantTimer;
  InstantTimer? saverTimer;
  // Stores action output result for [Custom Action - setNumber] action in Button widget.
  bool? putNumberRes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    instantTimer?.cancel();
    saverTimer?.cancel();
  }
}
