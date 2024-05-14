// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GameStruct extends BaseStruct {
  GameStruct({
    int? id,
    GameType? type,
    SudokuStruct? sudoku,
    int? timer,
    List<UserStruct>? players,
    DateTime? startTimestamp,
    int? winnerId,
    int? mistakes,
  })  : _id = id,
        _type = type,
        _sudoku = sudoku,
        _timer = timer,
        _players = players,
        _startTimestamp = startTimestamp,
        _winnerId = winnerId,
        _mistakes = mistakes;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;
  void incrementId(int amount) => _id = id + amount;
  bool hasId() => _id != null;

  // "type" field.
  GameType? _type;
  GameType? get type => _type;
  set type(GameType? val) => _type = val;
  bool hasType() => _type != null;

  // "sudoku" field.
  SudokuStruct? _sudoku;
  SudokuStruct get sudoku => _sudoku ?? SudokuStruct();
  set sudoku(SudokuStruct? val) => _sudoku = val;
  void updateSudoku(Function(SudokuStruct) updateFn) =>
      updateFn(_sudoku ??= SudokuStruct());
  bool hasSudoku() => _sudoku != null;

  // "timer" field.
  int? _timer;
  int get timer => _timer ?? 0;
  set timer(int? val) => _timer = val;
  void incrementTimer(int amount) => _timer = timer + amount;
  bool hasTimer() => _timer != null;

  // "players" field.
  List<UserStruct>? _players;
  List<UserStruct> get players => _players ?? const [];
  set players(List<UserStruct>? val) => _players = val;
  void updatePlayers(Function(List<UserStruct>) updateFn) =>
      updateFn(_players ??= []);
  bool hasPlayers() => _players != null;

  // "startTimestamp" field.
  DateTime? _startTimestamp;
  DateTime? get startTimestamp => _startTimestamp;
  set startTimestamp(DateTime? val) => _startTimestamp = val;
  bool hasStartTimestamp() => _startTimestamp != null;

  // "winnerId" field.
  int? _winnerId;
  int get winnerId => _winnerId ?? 0;
  set winnerId(int? val) => _winnerId = val;
  void incrementWinnerId(int amount) => _winnerId = winnerId + amount;
  bool hasWinnerId() => _winnerId != null;

  // "mistakes" field.
  int? _mistakes;
  int get mistakes => _mistakes ?? 0;
  set mistakes(int? val) => _mistakes = val;
  void incrementMistakes(int amount) => _mistakes = mistakes + amount;
  bool hasMistakes() => _mistakes != null;

  static GameStruct fromMap(Map<String, dynamic> data) => GameStruct(
        id: castToType<int>(data['id']),
        type: deserializeEnum<GameType>(data['type']),
        sudoku: SudokuStruct.maybeFromMap(data['sudoku']),
        timer: castToType<int>(data['timer']),
        players: getStructList(
          data['players'],
          UserStruct.fromMap,
        ),
        startTimestamp: data['startTimestamp'] as DateTime?,
        winnerId: castToType<int>(data['winnerId']),
        mistakes: castToType<int>(data['mistakes']),
      );

  static GameStruct? maybeFromMap(dynamic data) =>
      data is Map ? GameStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'type': _type?.serialize(),
        'sudoku': _sudoku?.toMap(),
        'timer': _timer,
        'players': _players?.map((e) => e.toMap()).toList(),
        'startTimestamp': _startTimestamp,
        'winnerId': _winnerId,
        'mistakes': _mistakes,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'type': serializeParam(
          _type,
          ParamType.Enum,
        ),
        'sudoku': serializeParam(
          _sudoku,
          ParamType.DataStruct,
        ),
        'timer': serializeParam(
          _timer,
          ParamType.int,
        ),
        'players': serializeParam(
          _players,
          ParamType.DataStruct,
          true,
        ),
        'startTimestamp': serializeParam(
          _startTimestamp,
          ParamType.DateTime,
        ),
        'winnerId': serializeParam(
          _winnerId,
          ParamType.int,
        ),
        'mistakes': serializeParam(
          _mistakes,
          ParamType.int,
        ),
      }.withoutNulls;

  static GameStruct fromSerializableMap(Map<String, dynamic> data) =>
      GameStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        type: deserializeParam<GameType>(
          data['type'],
          ParamType.Enum,
          false,
        ),
        sudoku: deserializeStructParam(
          data['sudoku'],
          ParamType.DataStruct,
          false,
          structBuilder: SudokuStruct.fromSerializableMap,
        ),
        timer: deserializeParam(
          data['timer'],
          ParamType.int,
          false,
        ),
        players: deserializeStructParam<UserStruct>(
          data['players'],
          ParamType.DataStruct,
          true,
          structBuilder: UserStruct.fromSerializableMap,
        ),
        startTimestamp: deserializeParam(
          data['startTimestamp'],
          ParamType.DateTime,
          false,
        ),
        winnerId: deserializeParam(
          data['winnerId'],
          ParamType.int,
          false,
        ),
        mistakes: deserializeParam(
          data['mistakes'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'GameStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is GameStruct &&
        id == other.id &&
        type == other.type &&
        sudoku == other.sudoku &&
        timer == other.timer &&
        listEquality.equals(players, other.players) &&
        startTimestamp == other.startTimestamp &&
        winnerId == other.winnerId &&
        mistakes == other.mistakes;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [id, type, sudoku, timer, players, startTimestamp, winnerId, mistakes]);
}

GameStruct createGameStruct({
  int? id,
  GameType? type,
  SudokuStruct? sudoku,
  int? timer,
  DateTime? startTimestamp,
  int? winnerId,
  int? mistakes,
}) =>
    GameStruct(
      id: id,
      type: type,
      sudoku: sudoku ?? SudokuStruct(),
      timer: timer,
      startTimestamp: startTimestamp,
      winnerId: winnerId,
      mistakes: mistakes,
    );
