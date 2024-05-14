import '/backend/api_requests/api_calls.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
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
        drawer: SizedBox(
          width: 250.0,
          child: Drawer(
            elevation: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).transparent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 10.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderColor: FlutterFlowTheme.of(context).transparent,
                          buttonSize: 40.0,
                          fillColor: FlutterFlowTheme.of(context).transparent,
                          icon: Icon(
                            Icons.menu_open,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            if (scaffoldKey.currentState!.isDrawerOpen ||
                                scaffoldKey.currentState!.isEndDrawerOpen) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              30.0, 10.0, 10.0, 0.0),
                          child: Icon(
                            Icons.videogame_asset,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 20.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'y468cb3x' /* Игры */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if ((FFAppState().user != null) &&
                        FFAppState().user.hasId()) {
                      context.goNamed(
                        'MessengerPage',
                        extra: <String, dynamic>{
                          kTransitionInfoKey: const TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    } else {
                      Navigator.pop(context);

                      context.pushNamed('SignPage');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).transparent,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              30.0, 10.0, 10.0, 0.0),
                          child: Icon(
                            Icons.message_sharp,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 20.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'kohgdrns' /* Общение */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ].divide(const SizedBox(height: 5.0)),
            ),
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
              Icons.menu,
              color: FlutterFlowTheme.of(context).info,
              size: 24.0,
            ),
            onPressed: () async {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              '8ytbcpqi' /* Мастера судоку */,
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
                Icons.account_circle,
                color: (FFAppState().user != null) && FFAppState().user.hasId()
                    ? FlutterFlowTheme.of(context).info
                    : FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                if ((FFAppState().user != null) && FFAppState().user.hasId()) {
                  context.pushNamed(
                    'UserInfoPage',
                    queryParameters: {
                      'userId': serializeParam(
                        FFAppState().user.id,
                        ParamType.int,
                      ),
                    }.withoutNulls,
                  );
                } else {
                  context.pushNamed('SignPage');
                }
              },
            ),
            FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).primary,
              borderRadius: 20.0,
              borderWidth: 1.0,
              buttonSize: 40.0,
              fillColor: FlutterFlowTheme.of(context).accent1,
              icon: Icon(
                Icons.settings_sharp,
                color: FlutterFlowTheme.of(context).info,
                size: 24.0,
              ),
              onPressed: () async {
                context.pushNamed('settingsPage');
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Align(
                alignment: const Alignment(0.0, 0),
                child: TabBar(
                  labelColor: FlutterFlowTheme.of(context).primaryText,
                  unselectedLabelColor:
                      FlutterFlowTheme.of(context).secondaryText,
                  labelStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 14.0,
                        letterSpacing: 0.0,
                      ),
                  unselectedLabelStyle: const TextStyle(),
                  indicatorColor: FlutterFlowTheme.of(context).primary,
                  padding: const EdgeInsets.all(4.0),
                  tabs: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                        ),
                        Tab(
                          text: FFLocalizations.of(context).getText(
                            '809jxwcc' /* Создать */,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_circle_right_outlined,
                        ),
                        Tab(
                          text: FFLocalizations.of(context).getText(
                            'smzd7fov' /* Активные */,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.archive_outlined,
                        ),
                        Tab(
                          text: FFLocalizations.of(context).getText(
                            '2iod2mvg' /* Архив */,
                          ),
                        ),
                      ],
                    ),
                  ],
                  controller: _model.tabBarController,
                  onTap: (i) async {
                    [() async {}, () async {}, () async {}][i]();
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _model.tabBarController,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlutterFlowDropDown<GameType>(
                                controller: _model.dropDownValueController1 ??=
                                    FormFieldController<GameType>(null),
                                options: List<GameType>.from(GameType.values),
                                optionLabels: [
                                  FFLocalizations.of(context).getText(
                                    'fxxtoui4' /* Одиночная */,
                                  ),
                                  FFLocalizations.of(context).getText(
                                    'k6nmrdaq' /* Кооперативная */,
                                  ),
                                  FFLocalizations.of(context).getText(
                                    'ro9v4ol7' /* Дуэль */,
                                  )
                                ],
                                onChanged: (val) =>
                                    setState(() => _model.dropDownValue1 = val),
                                width: 300.0,
                                height: 56.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                hintText: FFLocalizations.of(context).getText(
                                  'pvgh1zbf' /* Тип игры */,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isOverButton: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          if ((_model.dropDownValue1 == GameType.Cooperative) ||
                              (_model.dropDownValue1 == GameType.Duel))
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FutureBuilder<ApiCallResponse>(
                                future: UserGroup.getContactsCall.call(
                                  userId: FFAppState().user.id,
                                ),
                                builder: (context, snapshot) {
                                  // Customize what your widget looks like when it's loading.
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  final dropDownGetContactsResponse =
                                      snapshot.data!;
                                  return FlutterFlowDropDown<int>(
                                    controller:
                                        _model.dropDownValueController2 ??=
                                            FormFieldController<int>(
                                      _model.dropDownValue2 ??= null,
                                    ),
                                    options: List<int>.from(
                                        (dropDownGetContactsResponse.jsonBody
                                                    .toList()
                                                    .map<UserStruct?>(
                                                        UserStruct.maybeFromMap)
                                                    .toList()
                                                as Iterable<UserStruct?>)
                                            .withoutNulls
                                            .map((e) => e.id)
                                            .toList()),
                                    optionLabels: (dropDownGetContactsResponse
                                            .jsonBody
                                            .toList()
                                            .map<UserStruct?>(
                                                UserStruct.maybeFromMap)
                                            .toList() as Iterable<UserStruct?>)
                                        .withoutNulls
                                        .map((e) => e.username)
                                        .toList(),
                                    onChanged: (val) => setState(
                                        () => _model.dropDownValue2 = val),
                                    width: 300.0,
                                    height: 56.0,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    hintText:
                                        FFLocalizations.of(context).getText(
                                      'ctnr9qso' /* С кем играть? */,
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 24.0,
                                    ),
                                    fillColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 2.0,
                                    borderColor:
                                        FlutterFlowTheme.of(context).alternate,
                                    borderWidth: 2.0,
                                    borderRadius: 8.0,
                                    margin: const EdgeInsetsDirectional.fromSTEB(
                                        16.0, 4.0, 16.0, 4.0),
                                    hidesUnderline: true,
                                    isOverButton: true,
                                    isSearchable: false,
                                    isMultiSelect: false,
                                  );
                                },
                              ),
                            ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlutterFlowDropDown<Difficulty>(
                                controller: _model.dropDownValueController3 ??=
                                    FormFieldController<Difficulty>(
                                  _model.dropDownValue3 ??= null,
                                ),
                                options:
                                    List<Difficulty>.from(Difficulty.values),
                                optionLabels: [
                                  FFLocalizations.of(context).getText(
                                    'tkn5lfkh' /* Лёгкая */,
                                  ),
                                  FFLocalizations.of(context).getText(
                                    'n0lyvnxc' /* Нормальная */,
                                  ),
                                  FFLocalizations.of(context).getText(
                                    'edimj1j1' /* Сложная */,
                                  )
                                ],
                                onChanged: (val) =>
                                    setState(() => _model.dropDownValue3 = val),
                                width: 300.0,
                                height: 56.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                hintText: FFLocalizations.of(context).getText(
                                  'o0a1hcfi' /* Сложность */,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isOverButton: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FlutterFlowDropDown<int>(
                                controller: _model.dropDownValueController4 ??=
                                    FormFieldController<int>(null),
                                options: List<int>.from([4, 9, 16]),
                                optionLabels: [
                                  FFLocalizations.of(context).getText(
                                    'fb0j87q4' /* 4 ✕ 4 */,
                                  ),
                                  FFLocalizations.of(context).getText(
                                    'inc3vfa2' /* 9 ✕ 9 */,
                                  ),
                                  FFLocalizations.of(context).getText(
                                    'opldd6fi' /* 16 ✕ 16 */,
                                  )
                                ],
                                onChanged: (val) =>
                                    setState(() => _model.dropDownValue4 = val),
                                width: 300.0,
                                height: 56.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .labelLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                hintText: FFLocalizations.of(context).getText(
                                  '8nakyftj' /* Размер */,
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor:
                                    FlutterFlowTheme.of(context).alternate,
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: const EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isOverButton: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Padding(
                                padding: const EdgeInsets.all(45.0),
                                child: FFButtonWidget(
                                  onPressed: (valueOrDefault<bool>(
                                            _model.dropDownValue3 == null,
                                            false,
                                          ) ||
                                          (_model.dropDownValue4 == null) ||
                                          (_model.dropDownValue1 == null))
                                      ? null
                                      : () async {
                                          if (FFAppState().user.hasId() ==
                                              true) {
                                            _model.createGameRes =
                                                await CreateGameCall.call(
                                              gameType:
                                                  _model.dropDownValue1?.name,
                                              difficulty:
                                                  _model.dropDownValue3?.name,
                                              size: _model.dropDownValue4,
                                              authToken: FFAppState().authToken,
                                              playersList: (int? otherPlayerId,
                                                      int userId) {
                                                return otherPlayerId != null
                                                    ? [userId, otherPlayerId]
                                                    : [userId];
                                              }(_model.dropDownValue2,
                                                  FFAppState().user.id),
                                            );
                                            if ((_model
                                                    .createGameRes?.succeeded ??
                                                true)) {
                                              if (_model.dropDownValue1 ==
                                                  GameType.Classic) {
                                                setState(() {
                                                  FFAppState().addToLocalGames(
                                                      GameStruct(
                                                    id: CreateGameCall.id(
                                                      (_model.createGameRes
                                                              ?.jsonBody ??
                                                          ''),
                                                    ),
                                                    type: _model.dropDownValue1,
                                                    sudoku: SudokuStruct(
                                                      id: CreateGameCall
                                                          .sudokuId(
                                                        (_model.createGameRes
                                                                ?.jsonBody ??
                                                            ''),
                                                      ),
                                                      difficulty:
                                                          _model.dropDownValue3,
                                                      size:
                                                          _model.dropDownValue4,
                                                      field: functions
                                                          .fieldFromStr(
                                                              CreateGameCall
                                                                  .sudokuData(
                                                        (_model.createGameRes
                                                                ?.jsonBody ??
                                                            ''),
                                                      ).toString()),
                                                    ),
                                                    players: CreateGameCall
                                                            .players(
                                                      (_model.createGameRes
                                                              ?.jsonBody ??
                                                          ''),
                                                    )
                                                        ?.map((e) => UserStruct
                                                            .maybeFromMap(e))
                                                        .withoutNulls
                                                        .toList(),
                                                  ));
                                                });

                                                context.pushNamed(
                                                  'GamePage',
                                                  queryParameters: {
                                                    'game': serializeParam(
                                                      FFAppState()
                                                          .localGames
                                                          .last,
                                                      ParamType.DataStruct,
                                                    ),
                                                    'globalIndex':
                                                        serializeParam(
                                                      FFAppState()
                                                              .localGames
                                                              .length -
                                                          1,
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              } else {
                                                context.pushNamed(
                                                  'OnlineGamePage',
                                                  queryParameters: {
                                                    'game': serializeParam(
                                                      GameStruct(
                                                        id: CreateGameCall.id(
                                                          (_model.createGameRes
                                                                  ?.jsonBody ??
                                                              ''),
                                                        ),
                                                        type: _model
                                                            .dropDownValue1,
                                                        sudoku: SudokuStruct(
                                                          id: CreateGameCall
                                                              .sudokuId(
                                                            (_model.createGameRes
                                                                    ?.jsonBody ??
                                                                ''),
                                                          ),
                                                          difficulty: _model
                                                              .dropDownValue3,
                                                          size: _model
                                                              .dropDownValue4,
                                                          field: functions
                                                              .fieldFromStr(
                                                                  CreateGameCall
                                                                      .sudokuData(
                                                            (_model.createGameRes
                                                                    ?.jsonBody ??
                                                                ''),
                                                          ).toString()),
                                                        ),
                                                        players: CreateGameCall
                                                                .players(
                                                          (_model.createGameRes
                                                                  ?.jsonBody ??
                                                              ''),
                                                        )
                                                            ?.map((e) =>
                                                                UserStruct
                                                                    .maybeFromMap(
                                                                        e))
                                                            .withoutNulls
                                                            .toList(),
                                                      ),
                                                      ParamType.DataStruct,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              }
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Авторизуйтесь, чтобы создать игру!',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                  ),
                                                ),
                                                duration: const Duration(
                                                    milliseconds: 2000),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .warning,
                                              ),
                                            );
                                          }

                                          setState(() {});
                                        },
                                  text: FFLocalizations.of(context).getText(
                                    'il2cvc6x' /* Создать игру */,
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 54.0,
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          fontFamily: 'Outfit',
                                          letterSpacing: 0.0,
                                        ),
                                    elevation: 3.0,
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        if (FFAppState().user.hasId()) {
                          return FutureBuilder<ApiCallResponse>(
                            future: (_model.apiRequestCompleter1 ??=
                                    Completer<ApiCallResponse>()
                                      ..complete(GetActiveGamesCall.call(
                                        userId: FFAppState().user.id,
                                      )))
                                .future,
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final activeGamesGetActiveGamesResponse =
                                  snapshot.data!;
                              return Builder(
                                builder: (context) {
                                  final game = functions
                                      .gamesFromJson(
                                          activeGamesGetActiveGamesResponse
                                              .bodyText,
                                          FFAppState().user.id)
                                      .toList();
                                  return RefreshIndicator(
                                    key: const Key('RefreshIndicator_ara01h0w'),
                                    onRefresh: () async {
                                      setState(() =>
                                          _model.apiRequestCompleter1 = null);
                                      await _model
                                          .waitForApiRequestCompleted1();
                                    },
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: game.length,
                                      itemBuilder: (context, gameIndex) {
                                        final gameItem = game[gameIndex];
                                        return Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 10.0, 10.0, 1.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (gameItem.type ==
                                                  GameType.Classic) {
                                                context.pushNamed(
                                                  'GamePage',
                                                  queryParameters: {
                                                    'game': serializeParam(
                                                      FFAppState().localGames[
                                                          functions.getGameIndex(
                                                              FFAppState()
                                                                  .localGames
                                                                  .toList(),
                                                              gameItem.id)],
                                                      ParamType.DataStruct,
                                                    ),
                                                    'globalIndex':
                                                        serializeParam(
                                                      functions.getGameIndex(
                                                          FFAppState()
                                                              .localGames
                                                              .toList(),
                                                          gameItem.id),
                                                      ParamType.int,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              } else {
                                                if (!functions.isPlayerInGame(
                                                    gameItem,
                                                    FFAppState().user)) {
                                                  _model.joinGameRes =
                                                      await GameGroup
                                                          .joinGameCall
                                                          .call(
                                                    gameId: gameItem.id,
                                                    authToken:
                                                        FFAppState().authToken,
                                                  );
                                                  if ((_model.joinGameRes
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.refreshGameRes =
                                                        await GameGroup
                                                            .getGameInfoCall
                                                            .call(
                                                      gameId: gameItem.id,
                                                    );
                                                    if ((_model.refreshGameRes
                                                            ?.succeeded ??
                                                        true)) {
                                                      context.pushNamed(
                                                        'OnlineGamePage',
                                                        queryParameters: {
                                                          'game':
                                                              serializeParam(
                                                            functions
                                                                .gamesFromJson(
                                                                    (String
                                                                        body) {
                                                                      return '[$body]';
                                                                    }((_model
                                                                            .refreshGameRes
                                                                            ?.bodyText ??
                                                                        '')),
                                                                    FFAppState()
                                                                        .user
                                                                        .id)
                                                                .first,
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
                                                          'Игра уже началась',
                                                          style: TextStyle(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                          ),
                                                        ),
                                                        duration: const Duration(
                                                            milliseconds: 2000),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                      ),
                                                    );
                                                  }
                                                } else {
                                                  context.pushNamed(
                                                    'OnlineGamePage',
                                                    queryParameters: {
                                                      'game': serializeParam(
                                                        gameItem,
                                                        ParamType.DataStruct,
                                                      ),
                                                    }.withoutNulls,
                                                  );
                                                }
                                              }

                                              setState(() {});
                                            },
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 3.0,
                                              child: Container(
                                                width: double.infinity,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  color: functions
                                                          .isPlayerInGame(
                                                              gameItem,
                                                              FFAppState().user)
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryBackground
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .accent4,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0.0, 0.0),
                                                          child: Text(
                                                            valueOrDefault<
                                                                String>(
                                                              (int size,
                                                                      String dif,
                                                                      String type) {
                                                                return '$size✕$size | $dif | $type';
                                                              }(
                                                                  gameItem
                                                                      .sudoku
                                                                      .size,
                                                                  gameItem
                                                                      .sudoku
                                                                      .difficulty!
                                                                      .name,
                                                                  gameItem.type!
                                                                      .name),
                                                              '---',
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .titleLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                          ),
                                                        ),
                                                        Builder(
                                                          builder: (context) {
                                                            if ((gameItem
                                                                        .type !=
                                                                    GameType
                                                                        .Classic) &&
                                                                (gameItem
                                                                        .players
                                                                        .length ==
                                                                    1)) {
                                                              return Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    functions
                                                                        .joinPlayersAlias(
                                                                            gameItem),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Readex Pro',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'fo8pbbof' /* ищет игроков... */,
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Readex Pro',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ].divide(const SizedBox(
                                                                    width:
                                                                        5.0)),
                                                              );
                                                            } else {
                                                              return Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    FFLocalizations.of(
                                                                            context)
                                                                        .getText(
                                                                      'hbfu13p9' /* Игроки: */,
                                                                    ),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Readex Pro',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                  Text(
                                                                    functions
                                                                        .joinPlayersAlias(
                                                                            gameItem),
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Readex Pro',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).secondaryText,
                                                                          letterSpacing:
                                                                              0.0,
                                                                        ),
                                                                  ),
                                                                ].divide(const SizedBox(
                                                                    width:
                                                                        5.0)),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    if ((gameItem.type !=
                                                            GameType.Classic) &&
                                                        (gameItem.timer == 0))
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                -1.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  10.0),
                                                          child: Icon(
                                                            Icons.hourglass_top,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 45.0,
                                                          ),
                                                        ),
                                                      ),
                                                    if ((gameItem.type !=
                                                            GameType.Classic) &&
                                                        (gameItem.timer == 0) &&
                                                        functions
                                                            .isPlayerInGame(
                                                                gameItem,
                                                                FFAppState()
                                                                    .user))
                                                      Align(
                                                        alignment:
                                                            const AlignmentDirectional(
                                                                1.0, 0.0),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  10.0),
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            hoverColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () async {
                                                              _model.apiResult7so =
                                                                  await GameGroup
                                                                      .cancelGameCall
                                                                      .call(
                                                                gameId:
                                                                    gameItem.id,
                                                                authToken:
                                                                    FFAppState()
                                                                        .authToken,
                                                              );
                                                              setState(() =>
                                                                  _model.apiRequestCompleter2 =
                                                                      null);

                                                              setState(() {});
                                                            },
                                                            child: Icon(
                                                              Icons.close,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              size: 45.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30.0, 0.0, 30.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'bmck1jqk' /* Доступно только авторизованным... */,
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 22.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Builder(
                      builder: (context) {
                        if (FFAppState().user.hasId()) {
                          return FutureBuilder<ApiCallResponse>(
                            future: (_model.apiRequestCompleter2 ??=
                                    Completer<ApiCallResponse>()
                                      ..complete(GetFinishedGamesCall.call(
                                        userId: FFAppState().user.id,
                                      )))
                                .future,
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final arciveGamesGetFinishedGamesResponse =
                                  snapshot.data!;
                              return Builder(
                                builder: (context) {
                                  final game = functions
                                      .gamesFromJson(
                                          arciveGamesGetFinishedGamesResponse
                                              .bodyText,
                                          FFAppState().user.id)
                                      .toList();
                                  return RefreshIndicator(
                                    key: const Key('RefreshIndicator_ppixkbal'),
                                    onRefresh: () async {
                                      setState(() =>
                                          _model.apiRequestCompleter2 = null);
                                      await _model
                                          .waitForApiRequestCompleted2();
                                    },
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: game.length,
                                      itemBuilder: (context, gameIndex) {
                                        final gameItem = game[gameIndex];
                                        return Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 10.0, 10.0, 1.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                'FinishedGamePage',
                                                queryParameters: {
                                                  'game': serializeParam(
                                                    gameItem,
                                                    ParamType.DataStruct,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 3.0,
                                              child: Container(
                                                width: double.infinity,
                                                height: 100.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const AlignmentDirectional(
                                                              0.0, 0.0),
                                                      child: Text(
                                                        valueOrDefault<String>(
                                                          (int size, String dif,
                                                                  String type) {
                                                            return '$size✕$size | $dif | $type';
                                                          }(
                                                              gameItem
                                                                  .sudoku.size,
                                                              gameItem
                                                                  .sudoku
                                                                  .difficulty!
                                                                  .name,
                                                              gameItem
                                                                  .type!.name),
                                                          '---',
                                                        ),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          FFLocalizations.of(
                                                                  context)
                                                              .getText(
                                                            'dzxs0kdf' /* Игроки: */,
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                        Text(
                                                          functions
                                                              .joinPlayersAlias(
                                                                  gameItem),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                letterSpacing:
                                                                    0.0,
                                                              ),
                                                        ),
                                                      ].divide(
                                                          const SizedBox(width: 5.0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return Align(
                            alignment: const AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30.0, 0.0, 30.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'sskf0oq6' /* Доступно только авторизованным... */,
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 22.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
