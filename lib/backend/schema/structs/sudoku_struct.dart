// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SudokuStruct extends BaseStruct {
  SudokuStruct({
    int? id,
    Difficulty? difficulty,
    int? size,
    List<CellStruct>? field,
  })  : _id = id,
        _difficulty = difficulty,
        _size = size,
        _field = field;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;
  void incrementId(int amount) => _id = id + amount;
  bool hasId() => _id != null;

  // "difficulty" field.
  Difficulty? _difficulty;
  Difficulty? get difficulty => _difficulty;
  set difficulty(Difficulty? val) => _difficulty = val;
  bool hasDifficulty() => _difficulty != null;

  // "size" field.
  int? _size;
  int get size => _size ?? 0;
  set size(int? val) => _size = val;
  void incrementSize(int amount) => _size = size + amount;
  bool hasSize() => _size != null;

  // "field" field.
  List<CellStruct>? _field;
  List<CellStruct> get field => _field ?? const [];
  set field(List<CellStruct>? val) => _field = val;
  void updateField(Function(List<CellStruct>) updateFn) =>
      updateFn(_field ??= []);
  bool hasField() => _field != null;

  static SudokuStruct fromMap(Map<String, dynamic> data) => SudokuStruct(
        id: castToType<int>(data['id']),
        difficulty: deserializeEnum<Difficulty>(data['difficulty']),
        size: castToType<int>(data['size']),
        field: getStructList(
          data['field'],
          CellStruct.fromMap,
        ),
      );

  static SudokuStruct? maybeFromMap(dynamic data) =>
      data is Map ? SudokuStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'difficulty': _difficulty?.serialize(),
        'size': _size,
        'field': _field?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'difficulty': serializeParam(
          _difficulty,
          ParamType.Enum,
        ),
        'size': serializeParam(
          _size,
          ParamType.int,
        ),
        'field': serializeParam(
          _field,
          ParamType.DataStruct,
          true,
        ),
      }.withoutNulls;

  static SudokuStruct fromSerializableMap(Map<String, dynamic> data) =>
      SudokuStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        difficulty: deserializeParam<Difficulty>(
          data['difficulty'],
          ParamType.Enum,
          false,
        ),
        size: deserializeParam(
          data['size'],
          ParamType.int,
          false,
        ),
        field: deserializeStructParam<CellStruct>(
          data['field'],
          ParamType.DataStruct,
          true,
          structBuilder: CellStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'SudokuStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SudokuStruct &&
        id == other.id &&
        difficulty == other.difficulty &&
        size == other.size &&
        listEquality.equals(field, other.field);
  }

  @override
  int get hashCode => const ListEquality().hash([id, difficulty, size, field]);
}

SudokuStruct createSudokuStruct({
  int? id,
  Difficulty? difficulty,
  int? size,
}) =>
    SudokuStruct(
      id: id,
      difficulty: difficulty,
      size: size,
    );
