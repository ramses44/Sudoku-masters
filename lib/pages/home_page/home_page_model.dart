import '/backend/api_requests/api_calls.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:async';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for type widget.
  GameType? typeValue;
  FormFieldController<GameType>? typeValueController;
  // State field(s) for player widget.
  int? playerValue;
  FormFieldController<int>? playerValueController;
  // State field(s) for difficulty widget.
  Difficulty? difficultyValue;
  FormFieldController<Difficulty>? difficultyValueController;
  // State field(s) for size widget.
  int? sizeValue;
  FormFieldController<int>? sizeValueController;
  // Stores action output result for [Backend Call - API (createGame)] action in Button widget.
  ApiCallResponse? createGameRes;
  // Stores action output result for [Backend Call - API (getSudoku)] action in Button widget.
  ApiCallResponse? getSudokuRes;
  // Stores action output result for [Custom Action - generateSudoku] action in Button widget.
  SudokuStruct? generatedSudoku;
  Completer<ApiCallResponse>? apiRequestCompleter1;
  // Stores action output result for [Backend Call - API (joinGame)] action in Container widget.
  ApiCallResponse? joinGameRes;
  // Stores action output result for [Backend Call - API (getGameInfo)] action in Container widget.
  ApiCallResponse? refreshGameRes;
  // Stores action output result for [Backend Call - API (cancelGame)] action in Icon widget.
  ApiCallResponse? apiResult7so;
  Completer<ApiCallResponse>? apiRequestCompleter2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted1({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter1?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }

  Future waitForApiRequestCompleted2({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter2?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
