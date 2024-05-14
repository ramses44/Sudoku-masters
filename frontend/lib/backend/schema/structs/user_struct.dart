// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    int? id,
    String? username,
    String? alias,
    int? rating,
    bool? isContact,
  })  : _id = id,
        _username = username,
        _alias = alias,
        _rating = rating,
        _isContact = isContact;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;
  void incrementId(int amount) => _id = id + amount;
  bool hasId() => _id != null;

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  set username(String? val) => _username = val;
  bool hasUsername() => _username != null;

  // "alias" field.
  String? _alias;
  String get alias => _alias ?? '';
  set alias(String? val) => _alias = val;
  bool hasAlias() => _alias != null;

  // "rating" field.
  int? _rating;
  int get rating => _rating ?? 0;
  set rating(int? val) => _rating = val;
  void incrementRating(int amount) => _rating = rating + amount;
  bool hasRating() => _rating != null;

  // "is_contact" field.
  bool? _isContact;
  bool get isContact => _isContact ?? false;
  set isContact(bool? val) => _isContact = val;
  bool hasIsContact() => _isContact != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        id: castToType<int>(data['id']),
        username: data['username'] as String?,
        alias: data['alias'] as String?,
        rating: castToType<int>(data['rating']),
        isContact: data['is_contact'] as bool?,
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'username': _username,
        'alias': _alias,
        'rating': _rating,
        'is_contact': _isContact,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'username': serializeParam(
          _username,
          ParamType.String,
        ),
        'alias': serializeParam(
          _alias,
          ParamType.String,
        ),
        'rating': serializeParam(
          _rating,
          ParamType.int,
        ),
        'is_contact': serializeParam(
          _isContact,
          ParamType.bool,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        username: deserializeParam(
          data['username'],
          ParamType.String,
          false,
        ),
        alias: deserializeParam(
          data['alias'],
          ParamType.String,
          false,
        ),
        rating: deserializeParam(
          data['rating'],
          ParamType.int,
          false,
        ),
        isContact: deserializeParam(
          data['is_contact'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserStruct &&
        id == other.id &&
        username == other.username &&
        alias == other.alias &&
        rating == other.rating &&
        isContact == other.isContact;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, username, alias, rating, isContact]);
}

UserStruct createUserStruct({
  int? id,
  String? username,
  String? alias,
  int? rating,
  bool? isContact,
}) =>
    UserStruct(
      id: id,
      username: username,
      alias: alias,
      rating: rating,
      isContact: isContact,
    );
