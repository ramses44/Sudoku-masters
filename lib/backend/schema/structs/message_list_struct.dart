// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageListStruct extends BaseStruct {
  MessageListStruct({
    List<MessageStruct>? data,
    bool? hasNewFlag,
  })  : _data = data,
        _hasNewFlag = hasNewFlag;

  // "data" field.
  List<MessageStruct>? _data;
  List<MessageStruct> get data => _data ?? const [];
  set data(List<MessageStruct>? val) => _data = val;
  void updateData(Function(List<MessageStruct>) updateFn) =>
      updateFn(_data ??= []);
  bool hasData() => _data != null;

  // "hasNewFlag" field.
  bool? _hasNewFlag;
  bool get hasNewFlag => _hasNewFlag ?? false;
  set hasNewFlag(bool? val) => _hasNewFlag = val;
  bool hasHasNewFlag() => _hasNewFlag != null;

  static MessageListStruct fromMap(Map<String, dynamic> data) =>
      MessageListStruct(
        data: getStructList(
          data['data'],
          MessageStruct.fromMap,
        ),
        hasNewFlag: data['hasNewFlag'] as bool?,
      );

  static MessageListStruct? maybeFromMap(dynamic data) => data is Map
      ? MessageListStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'data': _data?.map((e) => e.toMap()).toList(),
        'hasNewFlag': _hasNewFlag,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'data': serializeParam(
          _data,
          ParamType.DataStruct,
          true,
        ),
        'hasNewFlag': serializeParam(
          _hasNewFlag,
          ParamType.bool,
        ),
      }.withoutNulls;

  static MessageListStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageListStruct(
        data: deserializeStructParam<MessageStruct>(
          data['data'],
          ParamType.DataStruct,
          true,
          structBuilder: MessageStruct.fromSerializableMap,
        ),
        hasNewFlag: deserializeParam(
          data['hasNewFlag'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'MessageListStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MessageListStruct &&
        listEquality.equals(data, other.data) &&
        hasNewFlag == other.hasNewFlag;
  }

  @override
  int get hashCode => const ListEquality().hash([data, hasNewFlag]);
}

MessageListStruct createMessageListStruct({
  bool? hasNewFlag,
}) =>
    MessageListStruct(
      hasNewFlag: hasNewFlag,
    );
