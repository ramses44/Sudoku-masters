// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageStruct extends BaseStruct {
  MessageStruct({
    int? id,
    int? chat,
    MessageType? type,
    String? data,
    String? sendingDatetime,
    UserStruct? sender,
  })  : _id = id,
        _chat = chat,
        _type = type,
        _data = data,
        _sendingDatetime = sendingDatetime,
        _sender = sender;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;
  void incrementId(int amount) => _id = id + amount;
  bool hasId() => _id != null;

  // "chat" field.
  int? _chat;
  int get chat => _chat ?? 0;
  set chat(int? val) => _chat = val;
  void incrementChat(int amount) => _chat = chat + amount;
  bool hasChat() => _chat != null;

  // "type" field.
  MessageType? _type;
  MessageType? get type => _type;
  set type(MessageType? val) => _type = val;
  bool hasType() => _type != null;

  // "data" field.
  String? _data;
  String get data => _data ?? '';
  set data(String? val) => _data = val;
  bool hasData() => _data != null;

  // "sending_datetime" field.
  String? _sendingDatetime;
  String get sendingDatetime => _sendingDatetime ?? '';
  set sendingDatetime(String? val) => _sendingDatetime = val;
  bool hasSendingDatetime() => _sendingDatetime != null;

  // "sender" field.
  UserStruct? _sender;
  UserStruct get sender => _sender ?? UserStruct();
  set sender(UserStruct? val) => _sender = val;
  void updateSender(Function(UserStruct) updateFn) =>
      updateFn(_sender ??= UserStruct());
  bool hasSender() => _sender != null;

  static MessageStruct fromMap(Map<String, dynamic> data) => MessageStruct(
        id: castToType<int>(data['id']),
        chat: castToType<int>(data['chat']),
        type: deserializeEnum<MessageType>(data['type']),
        data: data['data'] as String?,
        sendingDatetime: data['sending_datetime'] as String?,
        sender: UserStruct.maybeFromMap(data['sender']),
      );

  static MessageStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'chat': _chat,
        'type': _type?.serialize(),
        'data': _data,
        'sending_datetime': _sendingDatetime,
        'sender': _sender?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'chat': serializeParam(
          _chat,
          ParamType.int,
        ),
        'type': serializeParam(
          _type,
          ParamType.Enum,
        ),
        'data': serializeParam(
          _data,
          ParamType.String,
        ),
        'sending_datetime': serializeParam(
          _sendingDatetime,
          ParamType.String,
        ),
        'sender': serializeParam(
          _sender,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static MessageStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        chat: deserializeParam(
          data['chat'],
          ParamType.int,
          false,
        ),
        type: deserializeParam<MessageType>(
          data['type'],
          ParamType.Enum,
          false,
        ),
        data: deserializeParam(
          data['data'],
          ParamType.String,
          false,
        ),
        sendingDatetime: deserializeParam(
          data['sending_datetime'],
          ParamType.String,
          false,
        ),
        sender: deserializeStructParam(
          data['sender'],
          ParamType.DataStruct,
          false,
          structBuilder: UserStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'MessageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageStruct &&
        id == other.id &&
        chat == other.chat &&
        type == other.type &&
        data == other.data &&
        sendingDatetime == other.sendingDatetime &&
        sender == other.sender;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, chat, type, data, sendingDatetime, sender]);
}

MessageStruct createMessageStruct({
  int? id,
  int? chat,
  MessageType? type,
  String? data,
  String? sendingDatetime,
  UserStruct? sender,
}) =>
    MessageStruct(
      id: id,
      chat: chat,
      type: type,
      data: data,
      sendingDatetime: sendingDatetime,
      sender: sender ?? UserStruct(),
    );
