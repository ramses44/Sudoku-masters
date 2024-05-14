// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CellStruct extends BaseStruct {
  CellStruct({
    int? number,
    int? trueNumber,
    bool? initial,
    List<bool>? notes,
    int? setBy,
  })  : _number = number,
        _trueNumber = trueNumber,
        _initial = initial,
        _notes = notes,
        _setBy = setBy;

  // "number" field.
  int? _number;
  int get number => _number ?? 0;
  set number(int? val) => _number = val;
  void incrementNumber(int amount) => _number = number + amount;
  bool hasNumber() => _number != null;

  // "trueNumber" field.
  int? _trueNumber;
  int get trueNumber => _trueNumber ?? 0;
  set trueNumber(int? val) => _trueNumber = val;
  void incrementTrueNumber(int amount) => _trueNumber = trueNumber + amount;
  bool hasTrueNumber() => _trueNumber != null;

  // "initial" field.
  bool? _initial;
  bool get initial => _initial ?? true;
  set initial(bool? val) => _initial = val;
  bool hasInitial() => _initial != null;

  // "notes" field.
  List<bool>? _notes;
  List<bool> get notes => _notes ?? const [];
  set notes(List<bool>? val) => _notes = val;
  void updateNotes(Function(List<bool>) updateFn) => updateFn(_notes ??= []);
  bool hasNotes() => _notes != null;

  // "setBy" field.
  int? _setBy;
  int get setBy => _setBy ?? 0;
  set setBy(int? val) => _setBy = val;
  void incrementSetBy(int amount) => _setBy = setBy + amount;
  bool hasSetBy() => _setBy != null;

  static CellStruct fromMap(Map<String, dynamic> data) => CellStruct(
        number: castToType<int>(data['number']),
        trueNumber: castToType<int>(data['trueNumber']),
        initial: data['initial'] as bool?,
        notes: getDataList(data['notes']),
        setBy: castToType<int>(data['setBy']),
      );

  static CellStruct? maybeFromMap(dynamic data) =>
      data is Map ? CellStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'number': _number,
        'trueNumber': _trueNumber,
        'initial': _initial,
        'notes': _notes,
        'setBy': _setBy,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'number': serializeParam(
          _number,
          ParamType.int,
        ),
        'trueNumber': serializeParam(
          _trueNumber,
          ParamType.int,
        ),
        'initial': serializeParam(
          _initial,
          ParamType.bool,
        ),
        'notes': serializeParam(
          _notes,
          ParamType.bool,
          true,
        ),
        'setBy': serializeParam(
          _setBy,
          ParamType.int,
        ),
      }.withoutNulls;

  static CellStruct fromSerializableMap(Map<String, dynamic> data) =>
      CellStruct(
        number: deserializeParam(
          data['number'],
          ParamType.int,
          false,
        ),
        trueNumber: deserializeParam(
          data['trueNumber'],
          ParamType.int,
          false,
        ),
        initial: deserializeParam(
          data['initial'],
          ParamType.bool,
          false,
        ),
        notes: deserializeParam<bool>(
          data['notes'],
          ParamType.bool,
          true,
        ),
        setBy: deserializeParam(
          data['setBy'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CellStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CellStruct &&
        number == other.number &&
        trueNumber == other.trueNumber &&
        initial == other.initial &&
        listEquality.equals(notes, other.notes) &&
        setBy == other.setBy;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([number, trueNumber, initial, notes, setBy]);
}

CellStruct createCellStruct({
  int? number,
  int? trueNumber,
  bool? initial,
  int? setBy,
}) =>
    CellStruct(
      number: number,
      trueNumber: trueNumber,
      initial: initial,
      setBy: setBy,
    );
