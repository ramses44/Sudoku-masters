// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FlagStruct extends BaseStruct {
  FlagStruct({
    bool? isSet,
  }) : _isSet = isSet;

  // "isSet" field.
  bool? _isSet;
  bool get isSet => _isSet ?? false;
  set isSet(bool? val) => _isSet = val;
  bool hasIsSet() => _isSet != null;

  static FlagStruct fromMap(Map<String, dynamic> data) => FlagStruct(
        isSet: data['isSet'] as bool?,
      );

  static FlagStruct? maybeFromMap(dynamic data) =>
      data is Map ? FlagStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'isSet': _isSet,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'isSet': serializeParam(
          _isSet,
          ParamType.bool,
        ),
      }.withoutNulls;

  static FlagStruct fromSerializableMap(Map<String, dynamic> data) =>
      FlagStruct(
        isSet: deserializeParam(
          data['isSet'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'FlagStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FlagStruct && isSet == other.isSet;
  }

  @override
  int get hashCode => const ListEquality().hash([isSet]);
}

FlagStruct createFlagStruct({
  bool? isSet,
}) =>
    FlagStruct(
      isSet: isSet,
    );
