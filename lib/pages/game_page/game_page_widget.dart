import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'game_page_model.dart';
export 'game_page_model.dart';

class GamePageWidget extends StatefulWidget {
  const GamePageWidget({
    super.key,
    required this.game,
    required this.globalIndex,
  });

  final GameStruct? game;
  final int? globalIndex;

  @override
  State<GamePageWidget> createState() => _GamePageWidgetState();
}

class _GamePageWidgetState extends State<GamePageWidget> {
  late GamePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GamePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _model.selectedCellX = null;
        _model.selectedCellY = null;
        _model.selectedNumber = null;
      });
      await Future.wait([
        Future(() async {
          _model.instantTimer = InstantTimer.periodic(
            duration: const Duration(milliseconds: 1000),
            callback: (timer) async {
              if (!_model.paused!) {
                await actions.incGameTime(
                  widget.game!,
                );
                setState(() {
                  _model.paused = _model.paused;
                });
              }
            },
            startImmediately: true,
          );
        }),
        Future(() async {
          _model.saverTimer = InstantTimer.periodic(
            duration: const Duration(milliseconds: 5000),
            callback: (timer) async {
              if (!_model.paused!) {
                FFAppState().updateLocalGamesAtIndex(
                  widget.globalIndex!,
                  (_) => widget.game!,
                );
              }
            },
            startImmediately: true,
          );
        }),
      ]);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: FlutterFlowTheme.of(context).primary,
            borderRadius: 20.0,
            borderWidth: 1.0,
            buttonSize: 40.0,
            fillColor: FlutterFlowTheme.of(context).accent1,
            icon: Icon(
              Icons.arrow_back,
              color: FlutterFlowTheme.of(context).info,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              '6oj51nco' /* Игра */,
            ),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).primary,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).accent1,
              icon: Icon(
                Icons.pause,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () async {
                setState(() {
                  _model.paused = !_model.paused!;
                });
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 15.0, 0.0, 15.0),
                              child: FFButtonWidget(
                                onPressed: true
                                    ? null
                                    : () {
                                        print('Button pressed ...');
                                      },
                                text: valueOrDefault<String>(
                                  functions.timerToStr(widget.game!.timer),
                                  '--:--',
                                ),
                                icon: const Icon(
                                  Icons.timer_outlined,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  height: functions.timerFieldHeight(
                                      MediaQuery.sizeOf(context).height),
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).lightGrey,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize:
                                            functions.numberButtonFontSize(
                                                MediaQuery.sizeOf(context)
                                                    .height),
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 0.0,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: valueOrDefault<double>(
                              functions.timerFieldHeight(
                                  MediaQuery.sizeOf(context).height),
                              40.0,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).lightGrey,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).transparent,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'psol6dxe' /* Ошибок:  */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize:
                                              functions.numberButtonFontSize(
                                                  MediaQuery.sizeOf(context)
                                                      .height),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    (int mistakes, int maxMistakes) {
                                      return "$mistakes/$maxMistakes";
                                    }(widget.game!.mistakes,
                                        FFAppConstants.maxMistakes),
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize:
                                              functions.numberButtonFontSize(
                                                  MediaQuery.sizeOf(context)
                                                      .height),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  valueOrDefault<double>(
                                    functions.cellSize(
                                        MediaQuery.sizeOf(context).width,
                                        widget.game!.sudoku.size),
                                    0.0,
                                  ),
                                  0.0,
                                  valueOrDefault<double>(
                                    functions.cellSize(
                                        MediaQuery.sizeOf(context).width,
                                        widget.game!.sudoku.size),
                                    0.0,
                                  ),
                                  0.0),
                              child: Builder(
                                builder: (context) {
                                  final cellX = functions
                                      .range(0, widget.game!.sudoku.size)
                                      .toList();
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(cellX.length,
                                        (cellXIndex) {
                                      final cellXItem = cellX[cellXIndex];
                                      return Builder(
                                        builder: (context) {
                                          final cellY = functions
                                              .range(
                                                  0, widget.game!.sudoku.size)
                                              .toList();
                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                                cellY.length, (cellYIndex) {
                                              final cellYItem =
                                                  cellY[cellYIndex];
                                              return Container(
                                                width: functions.cellSize(
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                    widget.game!.sudoku.size),
                                                height: functions.cellSize(
                                                    MediaQuery.sizeOf(context)
                                                        .width,
                                                    widget.game!.sudoku.size),
                                                decoration: BoxDecoration(
                                                  color: () {
                                                    if (((cellXItem ==
                                                                _model
                                                                    .selectedCellX) &&
                                                            (cellYItem ==
                                                                _model
                                                                    .selectedCellY)) ||
                                                        (functions
                                                                .getCell(
                                                                    widget
                                                                        .game!,
                                                                    cellXItem,
                                                                    cellYItem)
                                                                .number ==
                                                            _model
                                                                .selectedNumber)) {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .grey;
                                                    } else if ((cellXItem ==
                                                            _model
                                                                .selectedCellX) ||
                                                        (cellYItem ==
                                                            _model
                                                                .selectedCellY)) {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .lightGrey;
                                                    } else {
                                                      return FlutterFlowTheme
                                                              .of(context)
                                                          .transparent;
                                                    }
                                                  }(),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                alignment: const AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Builder(
                                                    builder: (context) {
                                                      if (!functions
                                                          .getCell(
                                                              widget.game!,
                                                              cellXItem,
                                                              cellYItem)
                                                          .notes
                                                          .contains(true)) {
                                                        return Text(
                                                          valueOrDefault<
                                                              String>(
                                                            functions.tableDataFromNum(
                                                                functions
                                                                    .getCell(
                                                                        widget
                                                                            .game!,
                                                                        cellXItem,
                                                                        cellYItem)
                                                                    .number),
                                                            '0',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: () {
                                                                  if (functions
                                                                      .getCell(
                                                                          widget
                                                                              .game!,
                                                                          cellXItem,
                                                                          cellYItem)
                                                                      .initial) {
                                                                    return FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryText;
                                                                  } else if (functions.isSetRight(
                                                                      widget
                                                                          .game!,
                                                                      cellXItem,
                                                                      cellYItem)) {
                                                                    return const Color(
                                                                        0xFF53A4FF);
                                                                  } else {
                                                                    return const Color(
                                                                        0xFFFF000F);
                                                                  }
                                                                }(),
                                                                fontSize: functions.tableFontSize(
                                                                    MediaQuery.sizeOf(
                                                                            context)
                                                                        .height,
                                                                    widget
                                                                        .game!
                                                                        .sudoku
                                                                        .size),
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        );
                                                      } else {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      2.0,
                                                                      0.0,
                                                                      2.0,
                                                                      2.0),
                                                          child: Builder(
                                                            builder: (context) {
                                                              final num = functions
                                                                  .range(
                                                                      1,
                                                                      widget.game!.sudoku
                                                                              .size +
                                                                          1)
                                                                  .toList();
                                                              return GridView
                                                                  .builder(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                gridDelegate:
                                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount: math
                                                                      .sqrt(widget
                                                                          .game!
                                                                          .sudoku
                                                                          .size)
                                                                      .toInt(),
                                                                  childAspectRatio:
                                                                      1.0,
                                                                ),
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemCount:
                                                                    num.length,
                                                                itemBuilder:
                                                                    (context,
                                                                        numIndex) {
                                                                  final numItem =
                                                                      num[numIndex];
                                                                  return Visibility(
                                                                    visible: functions
                                                                        .getCell(
                                                                            widget.game!,
                                                                            cellXItem,
                                                                            cellYItem)
                                                                        .notes[numItem],
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          const AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                      child:
                                                                          Container(
                                                                        width: functions.cellSize(MediaQuery.sizeOf(context).width,
                                                                                widget.game!.sudoku.size) /
                                                                            (math.sqrt(widget.game!.sudoku.size)),
                                                                        height: functions.cellSize(MediaQuery.sizeOf(context).width,
                                                                                widget.game!.sudoku.size) /
                                                                            (math.sqrt(widget.game!.sudoku.size)),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: _model.selectedNumber == numItem
                                                                              ? FlutterFlowTheme.of(context).grey
                                                                              : FlutterFlowTheme.of(context).transparent,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            Align(
                                                                          alignment: const AlignmentDirectional(
                                                                              0.0,
                                                                              0.0),
                                                                          child:
                                                                              Text(
                                                                            functions.tableDataFromNum(numItem),
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Readex Pro',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  fontSize: functions.tableFontSize(MediaQuery.sizeOf(context).height, widget.game!.sudoku.size) * 1.2 / math.sqrt(widget.game!.sudoku.size),
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    valueOrDefault<double>(
                                      functions.cellSize(
                                          MediaQuery.sizeOf(context).width,
                                          widget.game!.sudoku.size),
                                      0.0,
                                    ),
                                    0.0,
                                    valueOrDefault<double>(
                                      functions.cellSize(
                                          MediaQuery.sizeOf(context).width,
                                          widget.game!.sudoku.size),
                                      0.0,
                                    ),
                                    0.0),
                                child: Container(
                                  width: double.infinity,
                                  height: widget.game!.sudoku.size *
                                      functions.cellSize(
                                          MediaQuery.sizeOf(context).width,
                                          widget.game!.sudoku.size),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .transparent,
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      width: 4.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  valueOrDefault<double>(
                                    functions.cellSize(
                                        MediaQuery.sizeOf(context).width,
                                        widget.game!.sudoku.size),
                                    0.0,
                                  ),
                                  0.0,
                                  valueOrDefault<double>(
                                    functions.cellSize(
                                        MediaQuery.sizeOf(context).width,
                                        widget.game!.sudoku.size),
                                    0.0,
                                  ),
                                  0.0),
                              child: Builder(
                                builder: (context) {
                                  final cellX = functions
                                      .range(
                                          0,
                                          math
                                              .sqrt(widget.game!.sudoku.size)
                                              .toInt())
                                      .toList();
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(cellX.length,
                                        (cellXIndex) {
                                      final cellXItem = cellX[cellXIndex];
                                      return Builder(
                                        builder: (context) {
                                          final cellY = functions
                                              .range(
                                                  0,
                                                  math
                                                      .sqrt(widget
                                                          .game!.sudoku.size)
                                                      .toInt())
                                              .toList();
                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                                cellY.length, (cellYIndex) {
                                              final cellYItem =
                                                  cellY[cellYIndex];
                                              return Container(
                                                width: functions.cellSize(
                                                        MediaQuery.sizeOf(
                                                                context)
                                                            .width,
                                                        widget.game!.sudoku
                                                            .size) *
                                                    math.sqrt(widget
                                                        .game!.sudoku.size),
                                                height: functions.cellSize(
                                                        MediaQuery.sizeOf(
                                                                context)
                                                            .width,
                                                        widget.game!.sudoku
                                                            .size) *
                                                    math.sqrt(widget
                                                        .game!.sudoku.size),
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .transparent,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                alignment: const AlignmentDirectional(
                                                    0.0, 0.0),
                                              );
                                            }),
                                          );
                                        },
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  valueOrDefault<double>(
                                    functions.cellSize(
                                        MediaQuery.sizeOf(context).width,
                                        widget.game!.sudoku.size),
                                    0.0,
                                  ),
                                  0.0,
                                  valueOrDefault<double>(
                                    functions.cellSize(
                                        MediaQuery.sizeOf(context).width,
                                        widget.game!.sudoku.size),
                                    0.0,
                                  ),
                                  0.0),
                              child: Builder(
                                builder: (context) {
                                  final cellX = functions
                                      .range(0, widget.game!.sudoku.size)
                                      .toList();
                                  return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(cellX.length,
                                        (cellXIndex) {
                                      final cellXItem = cellX[cellXIndex];
                                      return Builder(
                                        builder: (context) {
                                          final cellY = functions
                                              .range(
                                                  0, widget.game!.sudoku.size)
                                              .toList();
                                          return Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                                cellY.length, (cellYIndex) {
                                              final cellYItem =
                                                  cellY[cellYIndex];
                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (_model.eraserMode) {
                                                    await actions.setNumber(
                                                      widget.game!,
                                                      cellXItem,
                                                      cellYItem,
                                                      0,
                                                      FFAppState().user.id,
                                                    );
                                                  }
                                                  if ((cellXItem ==
                                                          _model
                                                              .selectedCellX) &&
                                                      (cellYItem ==
                                                          _model
                                                              .selectedCellY)) {
                                                    setState(() {
                                                      _model.selectedCellX =
                                                          null;
                                                      _model.selectedCellY =
                                                          null;
                                                      _model.selectedNumber =
                                                          null;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _model.selectedCellX =
                                                          cellXItem;
                                                      _model.selectedCellY =
                                                          cellYItem;
                                                      _model
                                                          .selectedNumber = functions
                                                                  .getCell(
                                                                      widget
                                                                          .game!,
                                                                      cellXItem,
                                                                      cellYItem)
                                                                  .number ==
                                                              0
                                                          ? null
                                                          : functions
                                                              .getCell(
                                                                  widget.game!,
                                                                  cellXItem,
                                                                  cellYItem)
                                                              .number;
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  width: functions.cellSize(
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                      widget.game!.sudoku.size),
                                                  height: functions.cellSize(
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                      widget.game!.sudoku.size),
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .transparent,
                                                  ),
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.0, 0.0),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      );
                                    }),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            8.0, 30.0, 8.0, 30.0),
                        child: Builder(
                          builder: (context) {
                            final rowNum = functions
                                .range(
                                    0,
                                    widget.game!.sudoku.size ~/
                                            (math.min(9,
                                                    widget.game!.sudoku.size) +
                                                1) +
                                        1)
                                .toList();
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  List.generate(rowNum.length, (rowNumIndex) {
                                final rowNumItem = rowNum[rowNumIndex];
                                return Builder(
                                  builder: (context) {
                                    final buttonNumber = functions
                                        .range(
                                            math.min(
                                                        9,
                                                        widget.game!.sudoku
                                                            .size) *
                                                    rowNumItem +
                                                1,
                                            math.min(
                                                    math.min(
                                                            9,
                                                            widget.game!.sudoku
                                                                .size) *
                                                        (rowNumItem + 1),
                                                    widget.game!.sudoku.size) +
                                                1)
                                        .toList();
                                    return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          List.generate(buttonNumber.length,
                                              (buttonNumberIndex) {
                                        final buttonNumberItem =
                                            buttonNumber[buttonNumberIndex];
                                        return Align(
                                          alignment:
                                              const AlignmentDirectional(0.0, 0.0),
                                          child: FFButtonWidget(
                                            onPressed: _model.eraserMode
                                                ? null
                                                : () async {
                                                    if ((_model.selectedCellX !=
                                                            null) &&
                                                        (_model.selectedCellY !=
                                                            null)) {
                                                      if (_model.pencilMode) {
                                                        await actions.addNote(
                                                          widget.game!,
                                                          _model.selectedCellX!,
                                                          _model.selectedCellY!,
                                                          buttonNumberItem,
                                                        );
                                                        setState(() {
                                                          _model.selectedNumber =
                                                              _model
                                                                  .selectedNumber;
                                                        });
                                                      } else {
                                                        _model.putNumberRes =
                                                            await actions
                                                                .setNumber(
                                                          widget.game!,
                                                          _model.selectedCellX!,
                                                          _model.selectedCellY!,
                                                          buttonNumberItem,
                                                          FFAppState().user.id,
                                                        );
                                                        if (_model
                                                            .putNumberRes!) {
                                                          setState(() {
                                                            _model.selectedNumber =
                                                                buttonNumberItem;
                                                          });
                                                          if (functions.isSetRight(
                                                              widget.game!,
                                                              _model
                                                                  .selectedCellX!,
                                                              _model
                                                                  .selectedCellY!)) {
                                                            if (functions
                                                                .isSolved(widget
                                                                    .game!
                                                                    .sudoku)) {
                                                              unawaited(
                                                                () async {
                                                                  await GameGroup
                                                                      .winCall
                                                                      .call(
                                                                    gameId: widget
                                                                        .game
                                                                        ?.id,
                                                                    authToken:
                                                                        FFAppState()
                                                                            .authToken,
                                                                    time: widget
                                                                        .game
                                                                        ?.timer,
                                                                    mistakes: widget
                                                                        .game
                                                                        ?.mistakes,
                                                                  );
                                                                }(),
                                                              );
                                                              await actions
                                                                  .setGameWinner(
                                                                widget.game!,
                                                                FFAppState()
                                                                    .user
                                                                    .id,
                                                              );
                                                            }
                                                          } else {
                                                            await actions
                                                                .incMistakesCounter(
                                                              widget.game!,
                                                            );
                                                            setState(() {
                                                              _model.selectedNumber =
                                                                  _model
                                                                      .selectedNumber;
                                                            });
                                                            if (widget.game!
                                                                    .mistakes >=
                                                                valueOrDefault<
                                                                    int>(
                                                                  FFAppConstants
                                                                      .maxMistakes,
                                                                  3,
                                                                )) {
                                                              await actions
                                                                  .setGameWinner(
                                                                widget.game!,
                                                                -1,
                                                              );
                                                              unawaited(
                                                                () async {
                                                                  await GameGroup
                                                                      .loseCall
                                                                      .call(
                                                                    gameId: widget
                                                                        .game
                                                                        ?.id,
                                                                    authToken:
                                                                        FFAppState()
                                                                            .authToken,
                                                                    time: widget
                                                                        .game
                                                                        ?.timer,
                                                                    mistakes: widget
                                                                        .game
                                                                        ?.mistakes,
                                                                  );
                                                                }(),
                                                              );
                                                            }
                                                          }

                                                          if (widget.game
                                                                  ?.winnerId !=
                                                              0) {
                                                            setState(() {
                                                              FFAppState()
                                                                  .removeAtIndexFromLocalGames(
                                                                      widget
                                                                          .globalIndex!);
                                                            });
                                                            if (Navigator.of(
                                                                    context)
                                                                .canPop()) {
                                                              context.pop();
                                                            }
                                                            context.pushNamed(
                                                              'FinishedGamePage',
                                                              queryParameters: {
                                                                'game':
                                                                    serializeParam(
                                                                  widget.game,
                                                                  ParamType
                                                                      .DataStruct,
                                                                ),
                                                              }.withoutNulls,
                                                            );
                                                          }
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'Нельзя изменить эту ячейку',
                                                                style:
                                                                    TextStyle(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                ),
                                                              ),
                                                              duration: const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                              backgroundColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .alternate,
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    } else {
                                                      if (_model
                                                              .selectedNumber !=
                                                          null) {
                                                        setState(() {
                                                          _model.selectedNumber =
                                                              null;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _model.selectedNumber =
                                                              buttonNumberItem;
                                                        });
                                                      }
                                                    }

                                                    setState(() {});
                                                  },
                                            text: functions.tableDataFromNum(
                                                buttonNumberItem),
                                            options: FFButtonOptions(
                                              width: functions.numberButtonSize(
                                                  MediaQuery.sizeOf(context)
                                                      .width,
                                                  widget.game!.sudoku.size),
                                              height:
                                                  functions.numberButtonSize(
                                                          MediaQuery.sizeOf(
                                                                  context)
                                                              .width,
                                                          widget.game!.sudoku
                                                              .size) *
                                                      1.25,
                                              padding: const EdgeInsetsDirectional
                                                  .fromSTEB(2.0, 0.0, 2.0, 0.0),
                                              iconPadding: const EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Readex Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: functions
                                                        .numberButtonFontSize(
                                                            MediaQuery.sizeOf(
                                                                    context)
                                                                .height),
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 3.0,
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        );
                                      }).divide(const SizedBox(width: 8.0)),
                                    );
                                  },
                                );
                              }).divide(const SizedBox(height: 8.0)),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  if (_model.eraserMode) {
                                    return FFButtonWidget(
                                      onPressed: () async {
                                        setState(() {
                                          _model.eraserMode =
                                              !_model.eraserMode;
                                        });
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'ip93paoi' /* Ластик */,
                                      ),
                                      icon: Icon(
                                        Icons.circle,
                                        size: functions.numberButtonFontSize(
                                            MediaQuery.sizeOf(context).height),
                                      ),
                                      options: FFButtonOptions(
                                        height: functions.numberButtonSize(
                                                MediaQuery.sizeOf(context)
                                                    .width,
                                                widget.game!.sudoku.size) *
                                            1.25,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            10.0, 2.0, 10.0, 2.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: functions
                                                  .numberButtonFontSize(
                                                      MediaQuery.sizeOf(context)
                                                          .height),
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 3.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    );
                                  } else {
                                    return FFButtonWidget(
                                      onPressed: () async {
                                        setState(() {
                                          _model.eraserMode =
                                              !_model.eraserMode;
                                        });
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'rl2tfaq6' /* Ластик */,
                                      ),
                                      icon: Icon(
                                        Icons.circle_outlined,
                                        size: functions.numberButtonFontSize(
                                            MediaQuery.sizeOf(context).height),
                                      ),
                                      options: FFButtonOptions(
                                        height: functions.numberButtonSize(
                                                MediaQuery.sizeOf(context)
                                                    .width,
                                                widget.game!.sudoku.size) *
                                            1.25,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: functions
                                                  .numberButtonFontSize(
                                                      MediaQuery.sizeOf(context)
                                                          .height),
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 3.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  if (_model.pencilMode) {
                                    return FFButtonWidget(
                                      onPressed: () async {
                                        setState(() {
                                          _model.pencilMode =
                                              !_model.pencilMode;
                                        });
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'hgh5g3d8' /* Карандаш */,
                                      ),
                                      icon: Icon(
                                        Icons.note_alt,
                                        size: functions.numberButtonFontSize(
                                            MediaQuery.sizeOf(context).height),
                                      ),
                                      options: FFButtonOptions(
                                        height: functions.numberButtonSize(
                                                MediaQuery.sizeOf(context)
                                                    .width,
                                                widget.game!.sudoku.size) *
                                            1.25,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            10.0, 0.0, 10.0, 0.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: functions
                                                  .numberButtonFontSize(
                                                      MediaQuery.sizeOf(context)
                                                          .height),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        elevation: 3.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    );
                                  } else {
                                    return FFButtonWidget(
                                      onPressed: () async {
                                        setState(() {
                                          _model.pencilMode =
                                              !_model.pencilMode;
                                        });
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'rl7k8xfh' /* Карандаш */,
                                      ),
                                      icon: Icon(
                                        Icons.note_alt_outlined,
                                        size: functions.numberButtonFontSize(
                                            MediaQuery.sizeOf(context).height),
                                      ),
                                      options: FFButtonOptions(
                                        height: functions.numberButtonSize(
                                                MediaQuery.sizeOf(context)
                                                    .width,
                                                widget.game!.sudoku.size) *
                                            1.25,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            10.0, 2.0, 10.0, 2.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: functions
                                                  .numberButtonFontSize(
                                                      MediaQuery.sizeOf(context)
                                                          .height),
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 3.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ].divide(const SizedBox(width: 20.0)),
                        ),
                      ),
                    ],
                  ),
                  const Align(
                    alignment: AlignmentDirectional(0.0, 1.0),
                    child: custom_widgets.YandexAdWidget(
                      width: double.infinity,
                      height: 80.0,
                    ),
                  ),
                ],
              ),
              if (_model.paused ?? true)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4.0,
                        sigmaY: 4.0,
                      ),
                      child: Opacity(
                        opacity: 0.6,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            setState(() {
                              _model.paused = false;
                            });
                          },
                          child: Icon(
                            Icons.play_arrow,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 200.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
