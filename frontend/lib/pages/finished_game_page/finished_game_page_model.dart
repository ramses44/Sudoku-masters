import '/flutter_flow/flutter_flow_util.dart';
import 'finished_game_page_widget.dart' show FinishedGamePageWidget;
import 'package:flutter/material.dart';

class FinishedGamePageModel extends FlutterFlowModel<FinishedGamePageWidget> {
  ///  Local state fields for this page.

  bool share = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
