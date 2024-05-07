import 'package:collection/collection.dart';

enum GameType {
  Classic,
  Cooperative,
  Duel,
}

enum Difficulty {
  Easy,
  Medium,
  Hard,
}

enum MessageType {
  TEXT,
  SUDOKU,
  CONTACT,
  CHAT_INVITATION,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (GameType):
      return GameType.values.deserialize(value) as T?;
    case (Difficulty):
      return Difficulty.values.deserialize(value) as T?;
    case (MessageType):
      return MessageType.values.deserialize(value) as T?;
    default:
      return null;
  }
}
