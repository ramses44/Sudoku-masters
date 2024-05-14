// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChatStruct extends BaseStruct {
  ChatStruct({
    int? id,
    String? title,
    bool? isPrivate,
    bool? unread,
    List<UserStruct>? participants,
    bool? joined,
  })  : _id = id,
        _title = title,
        _isPrivate = isPrivate,
        _unread = unread,
        _participants = participants,
        _joined = joined;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;
  void incrementId(int amount) => _id = id + amount;
  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;
  bool hasTitle() => _title != null;

  // "is_private" field.
  bool? _isPrivate;
  bool get isPrivate => _isPrivate ?? false;
  set isPrivate(bool? val) => _isPrivate = val;
  bool hasIsPrivate() => _isPrivate != null;

  // "unread" field.
  bool? _unread;
  bool get unread => _unread ?? false;
  set unread(bool? val) => _unread = val;
  bool hasUnread() => _unread != null;

  // "participants" field.
  List<UserStruct>? _participants;
  List<UserStruct> get participants => _participants ?? const [];
  set participants(List<UserStruct>? val) => _participants = val;
  void updateParticipants(Function(List<UserStruct>) updateFn) =>
      updateFn(_participants ??= []);
  bool hasParticipants() => _participants != null;

  // "joined" field.
  bool? _joined;
  bool get joined => _joined ?? true;
  set joined(bool? val) => _joined = val;
  bool hasJoined() => _joined != null;

  static ChatStruct fromMap(Map<String, dynamic> data) => ChatStruct(
        id: castToType<int>(data['id']),
        title: data['title'] as String?,
        isPrivate: data['is_private'] as bool?,
        unread: data['unread'] as bool?,
        participants: getStructList(
          data['participants'],
          UserStruct.fromMap,
        ),
        joined: data['joined'] as bool?,
      );

  static ChatStruct? maybeFromMap(dynamic data) =>
      data is Map ? ChatStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'is_private': _isPrivate,
        'unread': _unread,
        'participants': _participants?.map((e) => e.toMap()).toList(),
        'joined': _joined,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'is_private': serializeParam(
          _isPrivate,
          ParamType.bool,
        ),
        'unread': serializeParam(
          _unread,
          ParamType.bool,
        ),
        'participants': serializeParam(
          _participants,
          ParamType.DataStruct,
          true,
        ),
        'joined': serializeParam(
          _joined,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ChatStruct fromSerializableMap(Map<String, dynamic> data) =>
      ChatStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        isPrivate: deserializeParam(
          data['is_private'],
          ParamType.bool,
          false,
        ),
        unread: deserializeParam(
          data['unread'],
          ParamType.bool,
          false,
        ),
        participants: deserializeStructParam<UserStruct>(
          data['participants'],
          ParamType.DataStruct,
          true,
          structBuilder: UserStruct.fromSerializableMap,
        ),
        joined: deserializeParam(
          data['joined'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ChatStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ChatStruct &&
        id == other.id &&
        title == other.title &&
        isPrivate == other.isPrivate &&
        unread == other.unread &&
        listEquality.equals(participants, other.participants) &&
        joined == other.joined;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, title, isPrivate, unread, participants, joined]);
}

ChatStruct createChatStruct({
  int? id,
  String? title,
  bool? isPrivate,
  bool? unread,
  bool? joined,
}) =>
    ChatStruct(
      id: id,
      title: title,
      isPrivate: isPrivate,
      unread: unread,
      joined: joined,
    );
