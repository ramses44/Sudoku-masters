import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/components/chats_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'finished_game_page_model.dart';
export 'finished_game_page_model.dart';

class FinishedGamePageWidget extends StatefulWidget {
  const FinishedGamePageWidget({
    super.key,
    required this.game,
  });

  final GameStruct? game;

  @override
  State<FinishedGamePageWidget> createState() => _FinishedGamePageWidgetState();
}

class _FinishedGamePageWidgetState extends State<FinishedGamePageWidget> {
  late FinishedGamePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FinishedGamePageModel());

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
        endDrawer: Drawer(
          elevation: 16.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Builder(
                builder: (context) {
                  final user = widget.game?.players.toList() ?? [];
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(user.length, (userIndex) {
                      final userItem = user[userIndex];
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            10.0, 5.0, 10.0, 5.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              'UserInfoPage',
                              queryParameters: {
                                'userId': serializeParam(
                                  userItem.id,
                                  ParamType.int,
                                ),
                              }.withoutNulls,
                            );
                          },
                          child: Material(
                            color: Colors.transparent,
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.account_circle,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 80.0,
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(-1.0, -1.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  60.0, 10.0, 0.0, 0.0),
                                          child: Container(
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondary,
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              shape: BoxShape.rectangle,
                                            ),
                                            child: Align(
                                              alignment: const AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        6.0, 0.0, 6.0, 0.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    userItem.rating.toString(),
                                                    '0',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 0.0, 0.0, 5.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            userItem.alias,
                                            'ㅤ',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                fontFamily: 'Outfit',
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            20.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            (String username) {
                                              return '@$username';
                                            }(userItem.username),
                                            'ㅤ',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: FlutterFlowTheme.of(context).primary,
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
            widget.game?.winnerId == FFAppState().user.id
                ? 'Win / Победа'
                : 'Lose / Проигрыш',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).transparent,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).transparent,
              icon: Icon(
                Icons.people,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: const AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
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
                      size: 20.0,
                    ),
                    options: FFButtonOptions(
                      height: functions
                          .timerFieldHeight(MediaQuery.sizeOf(context).height),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).lightGrey,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: functions.numberButtonFontSize(
                                    MediaQuery.sizeOf(context).height),
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
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          valueOrDefault<double>(
                            functions.cellSize(MediaQuery.sizeOf(context).width,
                                widget.game!.sudoku.size),
                            0.0,
                          ),
                          0.0,
                          valueOrDefault<double>(
                            functions.cellSize(MediaQuery.sizeOf(context).width,
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
                            children: List.generate(cellX.length, (cellXIndex) {
                              final cellXItem = cellX[cellXIndex];
                              return Builder(
                                builder: (context) {
                                  final cellY = functions
                                      .range(0, widget.game!.sudoku.size)
                                      .toList();
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(cellY.length,
                                        (cellYIndex) {
                                      final cellYItem = cellY[cellYIndex];
                                      return Container(
                                        width: functions.cellSize(
                                            MediaQuery.sizeOf(context).width,
                                            widget.game!.sudoku.size),
                                        height: functions.cellSize(
                                            MediaQuery.sizeOf(context).width,
                                            widget.game!.sudoku.size),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .transparent,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            width: 1.0,
                                          ),
                                        ),
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0),
                                        child: Text(
                                          valueOrDefault<String>(
                                            functions.tableDataFromNum(functions
                                                .getCell(widget.game!,
                                                    cellXItem, cellYItem)
                                                .trueNumber),
                                            '0',
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize:
                                                    functions.tableFontSize(
                                                        MediaQuery.sizeOf(
                                                                context)
                                                            .height,
                                                        widget
                                                            .game!.sudoku.size),
                                                letterSpacing: 0.0,
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
                            color: FlutterFlowTheme.of(context).transparent,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primaryText,
                              width: 4.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          valueOrDefault<double>(
                            functions.cellSize(MediaQuery.sizeOf(context).width,
                                widget.game!.sudoku.size),
                            0.0,
                          ),
                          0.0,
                          valueOrDefault<double>(
                            functions.cellSize(MediaQuery.sizeOf(context).width,
                                widget.game!.sudoku.size),
                            0.0,
                          ),
                          0.0),
                      child: Builder(
                        builder: (context) {
                          final cellX = functions
                              .range(0,
                                  math.sqrt(widget.game!.sudoku.size).toInt())
                              .toList();
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(cellX.length, (cellXIndex) {
                              final cellXItem = cellX[cellXIndex];
                              return Builder(
                                builder: (context) {
                                  final cellY = functions
                                      .range(
                                          0,
                                          math
                                              .sqrt(widget.game!.sudoku.size)
                                              .toInt())
                                      .toList();
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(cellY.length,
                                        (cellYIndex) {
                                      final cellYItem = cellY[cellYIndex];
                                      return Container(
                                        width: functions.cellSize(
                                                MediaQuery.sizeOf(context)
                                                    .width,
                                                widget.game!.sudoku.size) *
                                            math.sqrt(widget.game!.sudoku.size),
                                        height: functions.cellSize(
                                                MediaQuery.sizeOf(context)
                                                    .width,
                                                widget.game!.sudoku.size) *
                                            math.sqrt(widget.game!.sudoku.size),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .transparent,
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            width: 2.0,
                                          ),
                                        ),
                                        alignment:
                                            const AlignmentDirectional(0.0, 0.0),
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
              Align(
                alignment: const AlignmentDirectional(0.0, 1.0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      setState(() {
                        _model.share = !_model.share;
                      });
                    },
                    text: FFLocalizations.of(context).getText(
                      'sn4499x5' /* Поделиться судоку */,
                    ),
                    icon: const Icon(
                      Icons.share,
                      size: 20.0,
                    ),
                    options: FFButtonOptions(
                      height: functions
                          .timerFieldHeight(MediaQuery.sizeOf(context).height),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).alternate,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: functions.numberButtonFontSize(
                                    MediaQuery.sizeOf(context).height),
                                letterSpacing: 0.0,
                              ),
                      elevation: 3.0,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    showLoadingIndicator: false,
                  ),
                ),
              ),
              if (_model.share)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: FutureBuilder<ApiCallResponse>(
                          future: GetChatsCall.call(
                            userId: FFAppState().user.id,
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return const ChatsShimmerWidget();
                            }
                            final listViewGetChatsResponse = snapshot.data!;
                            return Builder(
                              builder: (context) {
                                final chat = (listViewGetChatsResponse.jsonBody
                                            .toList()
                                            .map<ChatStruct?>(
                                                ChatStruct.maybeFromMap)
                                            .toList() as Iterable<ChatStruct?>)
                                        .withoutNulls
                                        .toList() ??
                                    [];
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  itemCount: chat.length,
                                  itemBuilder: (context, chatIndex) {
                                    final chatItem = chat[chatIndex];
                                    return FFButtonWidget(
                                      onPressed: () async {
                                        await MessengerGroup.shareSudokuCall
                                            .call(
                                          chatId: chatItem.id,
                                          authToken: FFAppState().authToken,
                                          data: (int id, int size,
                                                  String difficulty) {
                                            return [id, size, difficulty]
                                                .join(' ');
                                          }(
                                              widget.game!.sudoku.id,
                                              widget.game!.sudoku.size,
                                              widget.game!.sudoku.difficulty!
                                                  .name),
                                        );
                                        if (listViewGetChatsResponse
                                            .succeeded) {
                                          context.pushNamed(
                                            'ChatPage',
                                            queryParameters: {
                                              'chat': serializeParam(
                                                chatItem,
                                                ParamType.DataStruct,
                                              ),
                                            }.withoutNulls,
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  const TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType
                                                        .rightToLeft,
                                              ),
                                            },
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Не удалось отправить сообщение',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                              ),
                                              duration:
                                                  const Duration(milliseconds: 2000),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                          );
                                        }
                                      },
                                      text: valueOrDefault<String>(
                                        chatItem.title,
                                        'ㅤ',
                                      ),
                                      icon: const Icon(
                                        Icons.message_rounded,
                                        size: 24.0,
                                      ),
                                      options: FFButtonOptions(
                                        height: 40.0,
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .transparent,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Outfit',
                                              fontSize: 24.0,
                                              letterSpacing: 0.0,
                                            ),
                                        elevation: 0.0,
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
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
