import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      if (prefs.containsKey('ff_user')) {
        try {
          final serializedData = prefs.getString('ff_user') ?? '{}';
          _user = UserStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _localGames = prefs
              .getStringList('ff_localGames')
              ?.map((x) {
                try {
                  return GameStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _localGames;
    });
    _safeInit(() {
      _authToken = prefs.getString('ff_authToken') ?? _authToken;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  UserStruct _user = UserStruct();
  UserStruct get user => _user;
  set user(UserStruct value) {
    _user = value;
    prefs.setString('ff_user', value.serialize());
  }

  void updateUserStruct(Function(UserStruct) updateFn) {
    updateFn(_user);
    prefs.setString('ff_user', _user.serialize());
  }

  List<GameStruct> _localGames = [];
  List<GameStruct> get localGames => _localGames;
  set localGames(List<GameStruct> value) {
    _localGames = value;
    prefs.setStringList(
        'ff_localGames', value.map((x) => x.serialize()).toList());
  }

  void addToLocalGames(GameStruct value) {
    _localGames.add(value);
    prefs.setStringList(
        'ff_localGames', _localGames.map((x) => x.serialize()).toList());
  }

  void removeFromLocalGames(GameStruct value) {
    _localGames.remove(value);
    prefs.setStringList(
        'ff_localGames', _localGames.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromLocalGames(int index) {
    _localGames.removeAt(index);
    prefs.setStringList(
        'ff_localGames', _localGames.map((x) => x.serialize()).toList());
  }

  void updateLocalGamesAtIndex(
    int index,
    GameStruct Function(GameStruct) updateFn,
  ) {
    _localGames[index] = updateFn(_localGames[index]);
    prefs.setStringList(
        'ff_localGames', _localGames.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInLocalGames(int index, GameStruct value) {
    _localGames.insert(index, value);
    prefs.setStringList(
        'ff_localGames', _localGames.map((x) => x.serialize()).toList());
  }

  String _authToken = '';
  String get authToken => _authToken;
  set authToken(String value) {
    _authToken = value;
    prefs.setString('ff_authToken', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
