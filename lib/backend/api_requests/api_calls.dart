import 'dart:convert';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start user Group Code

class UserGroup {
  static String baseUrl = 'http://sudoku-masters.ddns.net:8080/user';
  static Map<String, String> headers = {};
  static SignInCall signInCall = SignInCall();
  static SignUpCall signUpCall = SignUpCall();
  static SearchUserCall searchUserCall = SearchUserCall();
  static DeleteContactCall deleteContactCall = DeleteContactCall();
  static GetUserStatCall getUserStatCall = GetUserStatCall();
  static GetUserInfoCall getUserInfoCall = GetUserInfoCall();
  static GetContactsCall getContactsCall = GetContactsCall();
  static AddContactCall addContactCall = AddContactCall();
}

class SignInCall {
  Future<ApiCallResponse> call({
    String? username = '',
    String? password = '',
    int? userId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "username": "$username",
  "password": "$password"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'signIn',
      apiUrl: '${UserGroup.baseUrl}/signin',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  String? authToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$["auth-token"]''',
      ));
}

class SignUpCall {
  Future<ApiCallResponse> call({
    String? alias = '',
    String? username = '',
    String? password = '',
    int? userId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "username": "$username",
  "password": "$password",
  "alias": "$alias"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'signUp',
      apiUrl: '${UserGroup.baseUrl}/signup',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  String? authToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$["auth-token"]''',
      ));
}

class SearchUserCall {
  Future<ApiCallResponse> call({
    String? query = '',
    int? userId,
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'searchUser',
      apiUrl: '${UserGroup.baseUrl}/search-for-users/$query',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteContactCall {
  Future<ApiCallResponse> call({
    int? userId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deleteContact',
      apiUrl: '${UserGroup.baseUrl}/delete-contact/$userId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserStatCall {
  Future<ApiCallResponse> call({
    int? userId,
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getUserStat',
      apiUrl: '${UserGroup.baseUrl}/get-user-stat/$userId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  int? allCount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.All.count''',
      ));
  double? allMistakes(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.All.mistakes''',
      ));
  double? duelWinrate(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.Duel.winrate''',
      ));
  double? duelTime(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.Duel.time''',
      ));
  double? duelMistakes(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.Duel.mistakes''',
      ));
  int? duelCount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.Duel.count''',
      ));
  double? coopWinrate(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.Cooperative.winrate''',
      ));
  double? coopTime(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.Cooperative.time''',
      ));
  double? coopMistakes(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.Cooperative.mistakes''',
      ));
  int? coopCount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.Cooperative.count''',
      ));
  int? classicCount(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.Classic.count''',
      ));
  double? allWinrate(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.All.winrate''',
      ));
  double? allTime(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.All.time''',
      ));
  dynamic classicTime(dynamic response) => getJsonField(
        response,
        r'''$.Classic.time''',
      );
  dynamic classicWinrate(dynamic response) => getJsonField(
        response,
        r'''$.Classic.winrate''',
      );
  dynamic classicMistakes(dynamic response) => getJsonField(
        response,
        r'''$.Classic.mistakes''',
      );
}

class GetUserInfoCall {
  Future<ApiCallResponse> call({
    int? userId,
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getUserInfo',
      apiUrl: '${UserGroup.baseUrl}/get-user-info/$userId',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetContactsCall {
  Future<ApiCallResponse> call({
    int? userId,
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getContacts',
      apiUrl: '${UserGroup.baseUrl}/get-contacts/$userId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class AddContactCall {
  Future<ApiCallResponse> call({
    int? userId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addContact',
      apiUrl: '${UserGroup.baseUrl}/add-contact/$userId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

/// End user Group Code

/// Start messenger Group Code

class MessengerGroup {
  static String baseUrl = 'http://sudoku-masters.ddns.net:8080/messenger';
  static Map<String, String> headers = {};
  static SendMessageCall sendMessageCall = SendMessageCall();
  static ShareSudokuCall shareSudokuCall = ShareSudokuCall();
  static JoinChatCall joinChatCall = JoinChatCall();
  static ShareContactCall shareContactCall = ShareContactCall();
}

class SendMessageCall {
  Future<ApiCallResponse> call({
    String? msgType = '',
    String? msgData = '',
    int? chatId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "msg-type": "$msgType",
  "msg-data": "$msgData",
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendMessage',
      apiUrl: '${MessengerGroup.baseUrl}/send-message/$chatId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class ShareSudokuCall {
  Future<ApiCallResponse> call({
    String? data = '',
    int? chatId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "msg-type": "SUDOKU",
  "msg-data": "$data",
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'shareSudoku',
      apiUrl: '${MessengerGroup.baseUrl}/send-message/$chatId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class JoinChatCall {
  Future<ApiCallResponse> call({
    int? chatId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'joinChat',
      apiUrl: '${MessengerGroup.baseUrl}/join-chat/$chatId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class ShareContactCall {
  Future<ApiCallResponse> call({
    String? contactData = '',
    int? chatId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken",
  "msg-type": "CONTACT",
  "msg-data": "$contactData"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'shareContact',
      apiUrl: '${MessengerGroup.baseUrl}/send-message/$chatId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

/// End messenger Group Code

/// Start game Group Code

class GameGroup {
  static String baseUrl = 'http://sudoku-masters.ddns.net:8080/game';
  static Map<String, String> headers = {};
  static JoinGameCall joinGameCall = JoinGameCall();
  static CancelGameCall cancelGameCall = CancelGameCall();
  static MistakeCall mistakeCall = MistakeCall();
  static SolveCellCall solveCellCall = SolveCellCall();
  static LoseCall loseCall = LoseCall();
  static WinCall winCall = WinCall();
  static GetGameStateCall getGameStateCall = GetGameStateCall();
  static GameFromSudokuCall gameFromSudokuCall = GameFromSudokuCall();
  static GetGameInfoCall getGameInfoCall = GetGameInfoCall();
}

class JoinGameCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    int? gameId,
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'joinGame',
      apiUrl: '${GameGroup.baseUrl}/join-game/$gameId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class CancelGameCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    int? gameId,
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'cancelGame',
      apiUrl: '${GameGroup.baseUrl}/cancel-game/$gameId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class MistakeCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    int? gameId,
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'mistake',
      apiUrl: '${GameGroup.baseUrl}/mistake/$gameId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class SolveCellCall {
  Future<ApiCallResponse> call({
    int? x,
    int? y,
    String? authToken = '',
    int? gameId,
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'solveCell',
      apiUrl: '${GameGroup.baseUrl}/solve-cell/$gameId/$x/$y',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class LoseCall {
  Future<ApiCallResponse> call({
    int? time,
    int? mistakes,
    String? authToken = '',
    int? gameId,
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken",
  "time": $time,
  "mistakes": $mistakes
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'lose',
      apiUrl: '${GameGroup.baseUrl}/lose/$gameId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class WinCall {
  Future<ApiCallResponse> call({
    int? time,
    int? mistakes,
    String? authToken = '',
    int? gameId,
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken",
  "time": $time,
  "mistakes": $mistakes
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'win',
      apiUrl: '${GameGroup.baseUrl}/win/$gameId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetGameStateCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    int? gameId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getGameState',
      apiUrl: '${GameGroup.baseUrl}/get-game-state/$gameId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GameFromSudokuCall {
  Future<ApiCallResponse> call({
    int? sudokuId,
    String? authToken = '',
    int? gameId,
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'gameFromSudoku',
      apiUrl: '${GameGroup.baseUrl}/game-from-sudoku/$sudokuId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  dynamic id(dynamic response) => getJsonField(
        response,
        r'''$.id''',
      );
  dynamic type(dynamic response) => getJsonField(
        response,
        r'''$.type''',
      );
  dynamic start(dynamic response) => getJsonField(
        response,
        r'''$.start''',
      );
  dynamic players(dynamic response) => getJsonField(
        response,
        r'''$.players''',
      );
  dynamic sudokuId(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.id''',
      );
  dynamic sudokuDifficulty(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.difficulty''',
      );
  dynamic sudokuSize(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.size''',
      );
  dynamic sudokuData(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.data''',
      );
}

class GetGameInfoCall {
  Future<ApiCallResponse> call({
    String? authToken = '',
    int? gameId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getGameInfo',
      apiUrl: '${GameGroup.baseUrl}/get-game-info/$gameId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  int? id(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.id''',
      ));
  String? type(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.type''',
      ));
  String? start(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.start''',
      ));
  List? players(dynamic response) => getJsonField(
        response,
        r'''$.players''',
        true,
      ) as List?;
  int? sudokuId(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.sudoku.id''',
      ));
  String? sudokuDifficulty(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.sudoku.difficulty''',
      ));
  int? sudokuSize(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.sudoku.size''',
      ));
  String? sudokuData(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.sudoku.data''',
      ));
}

/// End game Group Code

class StoreMessagesCall {
  static Future<ApiCallResponse> call({
    int? chatId,
    int? beforeMessage = 0,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken",
  "chat-id": $chatId,
  "before-message": $beforeMessage
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'storeMessages',
      apiUrl:
          'http://sudoku-masters.ddns.net:8080/messenger/store-messages/$chatId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetChatsCall {
  static Future<ApiCallResponse> call({
    int? userId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getChats',
      apiUrl:
          'http://sudoku-masters.ddns.net:8080/messenger/get-chats/$userId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class SearchForChatsCall {
  static Future<ApiCallResponse> call({
    String? query = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'searchForChats',
      apiUrl:
          'http://sudoku-masters.ddns.net:8080/messenger/search-for-chats/$query',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer $authToken',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadMessageCall {
  static Future<ApiCallResponse> call({
    int? chatId,
    int? msgId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'readMessage',
      apiUrl:
          'http://sudoku-masters.ddns.net:8080/messenger/read-message/$chatId/$msgId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class AddToChatCall {
  static Future<ApiCallResponse> call({
    int? chatId,
    int? userId,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addToChat',
      apiUrl:
          'http://sudoku-masters.ddns.net:8080/messenger/add-to-chat/$chatId/$userId',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateChatCall {
  static Future<ApiCallResponse> call({
    String? chatTitle = '',
    List<int>? participantsList,
    bool? isPrivate,
    String? authToken = '',
  }) async {
    final participants = _serializeList(participantsList);

    final ffApiRequestBody = '''
{
  "chat-title": "$chatTitle",
  "participants": $participants,
  "is-private": $isPrivate,
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createChat',
      apiUrl: 'http://sudoku-masters.ddns.net:8080/messenger/create-chat',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateGameCall {
  static Future<ApiCallResponse> call({
    String? gameType = '',
    String? difficulty = '',
    int? size,
    List<int>? playersList,
    String? authToken = '',
  }) async {
    final players = _serializeList(playersList);

    final ffApiRequestBody = '''
{
  "game-type": "$gameType",
  "sudoku-size": $size,
  "sudoku-difficulty": "$difficulty",
  "players": $players,
  "auth-token": "$authToken"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createGame',
      apiUrl: 'http://sudoku-masters.ddns.net:8080/game/create-game',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic id(dynamic response) => getJsonField(
        response,
        r'''$.id''',
      );
  static dynamic type(dynamic response) => getJsonField(
        response,
        r'''$.type''',
      );
  static dynamic start(dynamic response) => getJsonField(
        response,
        r'''$.start''',
      );
  static List? players(dynamic response) => getJsonField(
        response,
        r'''$.players''',
        true,
      ) as List?;
  static dynamic sudokuId(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.id''',
      );
  static dynamic sudokuDifficulty(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.difficulty''',
      );
  static dynamic sudokuSize(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.size''',
      );
  static dynamic sudokuData(dynamic response) => getJsonField(
        response,
        r'''$.sudoku.data''',
      );
}

class GetActiveGamesCall {
  static Future<ApiCallResponse> call({
    int? userId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getActiveGames',
      apiUrl:
          'http://sudoku-masters.ddns.net:8080/game/get-active-games/$userId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic games(dynamic response) => getJsonField(
        response,
        r'''$[:]''',
      );
}

class GetFinishedGamesCall {
  static Future<ApiCallResponse> call({
    int? userId,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getFinishedGames',
      apiUrl:
          'http://sudoku-masters.ddns.net:8080/game/get-finished-games/$userId',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic games(dynamic response) => getJsonField(
        response,
        r'''$[:]''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
