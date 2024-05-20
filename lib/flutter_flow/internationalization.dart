import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['ru', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? ruText = '',
    String? enText = '',
  }) =>
      [ruText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return FFLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    '8ytbcpqi': {
      'ru': 'Мастера судоку',
      'en': 'Sudoku Masters',
    },
    '809jxwcc': {
      'ru': 'Создать',
      'en': 'Create',
    },
    'fxxtoui4': {
      'ru': 'Одиночная',
      'en': 'Single',
    },
    'k6nmrdaq': {
      'ru': 'Кооперативная',
      'en': 'Cooperative',
    },
    'ro9v4ol7': {
      'ru': 'Дуэль',
      'en': 'Duel',
    },
    'pvgh1zbf': {
      'ru': 'Тип игры',
      'en': 'Game type',
    },
    '16oie1s0': {
      'ru': 'Search for an item...',
      'en': '',
    },
    'ctnr9qso': {
      'ru': 'С кем играть?',
      'en': 'Who to play with?',
    },
    'r5m06pvw': {
      'ru': 'Search for an item...',
      'en': '',
    },
    'tkn5lfkh': {
      'ru': 'Лёгкая',
      'en': 'Easy',
    },
    'n0lyvnxc': {
      'ru': 'Нормальная',
      'en': 'Medium',
    },
    'edimj1j1': {
      'ru': 'Сложная',
      'en': 'Hard',
    },
    'o0a1hcfi': {
      'ru': 'Сложность',
      'en': 'Difficulty',
    },
    'p550j8um': {
      'ru': 'Search for an item...',
      'en': '',
    },
    'fb0j87q4': {
      'ru': '4 ✕ 4',
      'en': '4 ✕ 4',
    },
    'inc3vfa2': {
      'ru': '9 ✕ 9',
      'en': '9 ✕ 9',
    },
    'opldd6fi': {
      'ru': '16 ✕ 16',
      'en': '16 ✕ 16',
    },
    '8nakyftj': {
      'ru': 'Размер',
      'en': 'Size',
    },
    'e2buwbc3': {
      'ru': 'Search for an item...',
      'en': '',
    },
    'il2cvc6x': {
      'ru': 'Создать игру',
      'en': 'Create game',
    },
    'smzd7fov': {
      'ru': 'Активные',
      'en': 'Active',
    },
    'fo8pbbof': {
      'ru': 'ищет игроков...',
      'en': 'looking for players...',
    },
    'hbfu13p9': {
      'ru': 'Игроки:',
      'en': 'Players:',
    },
    'kklm20t3': {
      'ru': 'Локальная игра',
      'en': 'Local game',
    },
    '2iod2mvg': {
      'ru': 'Архив',
      'en': 'Archive',
    },
    'dzxs0kdf': {
      'ru': 'Игроки:',
      'en': 'Players:',
    },
    '95e3z0p4': {
      'ru': 'Локальная игра',
      'en': 'Local game',
    },
    'y468cb3x': {
      'ru': 'Игры',
      'en': 'Games',
    },
    'kohgdrns': {
      'ru': 'Общение',
      'en': 'Communication',
    },
    'fsftu0ut': {
      'ru': 'Home',
      'en': '',
    },
  },
  // SignPage
  {
    '0kll4937': {
      'ru': 'Аккаунт',
      'en': 'Account',
    },
    'udkixp0u': {
      'ru': 'Вход',
      'en': 'Sign in',
    },
    'e16ta11f': {
      'ru': 'Авторизуйтесь, используя свой логин и пароль',
      'en': 'Log in using your username and password',
    },
    'r0cidzst': {
      'ru': 'Имя пользователя',
      'en': 'Username',
    },
    'emwvkf24': {
      'ru': 'Пароль',
      'en': 'Password',
    },
    'sg66znzh': {
      'ru': 'Войти',
      'en': 'Sign in',
    },
    'm3zaawmr': {
      'ru': 'Регистрация',
      'en': 'Sign up',
    },
    'byzen1u4': {
      'ru':
          'Создайте аккаунт, чтобы получить доступ к онлайн режимам и общаться с другими игроками',
      'en':
          'Create an account to access online modes and chat with other players',
    },
    'o2djbjwl': {
      'ru': 'Имя пользователя',
      'en': 'Username',
    },
    'cwrfxz6z': {
      'ru': 'Отображаемое имя (псевдоним)',
      'en': 'Display name (alias)',
    },
    'rv191hj2': {
      'ru': 'Пароль',
      'en': 'Password',
    },
    'wp2he9qc': {
      'ru': 'Создать аккаунт',
      'en': 'Create account',
    },
    't1x6dpa4': {
      'ru': 'Home',
      'en': '',
    },
  },
  // UserInfoPage
  {
    'd9x5gljq': {
      'ru': 'Аккаунт',
      'en': 'Account',
    },
    '6xcpodd7': {
      'ru': 'Статистика',
      'en': 'Statistics',
    },
    's0zdrt1o': {
      'ru': 'Все типы игр',
      'en': 'All game types',
    },
    'qmi6qqzh': {
      'ru': 'Одиночная',
      'en': 'Single',
    },
    'e2h6bsox': {
      'ru': 'Дуэль',
      'en': 'Duel',
    },
    'h6ujhm0v': {
      'ru': 'Кооператив',
      'en': 'Cooperative',
    },
    'aqklm2go': {
      'ru': '',
      'en': '',
    },
    'zk5o147s': {
      'ru': 'Search for an item...',
      'en': '',
    },
    'ef1yl8im': {
      'ru': 'Игр сыграно:',
      'en': 'Games played:',
    },
    'dz155n40': {
      'ru': 'Из них судоку решены в:',
      'en': 'Of these, sudokus are solved in:',
    },
    'd7seo4i8': {
      'ru': 'Среднее время:',
      'en': 'Average time:',
    },
    'byhpjwlf': {
      'ru': 'В среднем ошибок:',
      'en': 'Average mistakes:',
    },
    'kckthmrv': {
      'ru': 'Игр сыграно:',
      'en': 'Games played:',
    },
    'o3hnr7j4': {
      'ru': 'Из них судоку решены в:',
      'en': 'Of these, sudokus are solved in:',
    },
    's98f9oja': {
      'ru': 'Среднее время:',
      'en': 'Average time:',
    },
    'jfq8030p': {
      'ru': 'В среднем ошибок:',
      'en': 'Average mistakes:',
    },
    'ohg8npbr': {
      'ru': 'Игр сыграно:',
      'en': 'Games played:',
    },
    'a94zxzsc': {
      'ru': 'Из них судоку решены в:',
      'en': 'Of these, sudokus are solved in:',
    },
    'j8ac9deb': {
      'ru': 'Среднее время:',
      'en': 'Average time:',
    },
    'mzfn1o3d': {
      'ru': 'В среднем ошибок:',
      'en': 'Average mistakes:',
    },
    'i7sjcmxc': {
      'ru': 'Игр сыграно:',
      'en': 'Games played:',
    },
    '5ogzo8j9': {
      'ru': 'Из них судоку решены в:',
      'en': 'Of these, sudokus are solved in:',
    },
    'yzn5u96s': {
      'ru': 'Среднее время:',
      'en': 'Average time:',
    },
    '431kvvuw': {
      'ru': 'В среднем ошибок:',
      'en': 'Average mistakes:',
    },
    'fsjf14rm': {
      'ru': 'Home',
      'en': '',
    },
  },
  // MessengerPage
  {
    'b4s8ggmz': {
      'ru': 'Мастера судоку',
      'en': 'Sudoku masters',
    },
    'oab811za': {
      'ru': 'Игры',
      'en': 'Games',
    },
    '0g9gr3as': {
      'ru': 'Общение',
      'en': 'Communication',
    },
    '0okxjh8x': {
      'ru': 'Чаты',
      'en': 'Chats',
    },
    '6f2gkqu7': {
      'ru': 'Создать чат',
      'en': 'Create chat',
    },
    'hxlgcxcf': {
      'ru': 'Поиск',
      'en': 'Search',
    },
    '1es7bfct': {
      'ru': 'Создание чата',
      'en': 'Create a chat',
    },
    'pcnksm4c': {
      'ru': 'Название чата',
      'en': 'Chat title',
    },
    'z0o3okbk': {
      'ru': 'Добавить участников...',
      'en': 'Add members...',
    },
    'qqvevydq': {
      'ru': 'Search for an item...',
      'en': '',
    },
    '69jz8k75': {
      'ru': 'Приватный чат',
      'en': 'Private chat',
    },
    'j12vuipw': {
      'ru': 'Поиск чатов',
      'en': 'Search chats',
    },
    'pbdb2pww': {
      'ru': 'Поиск...',
      'en': 'Search...',
    },
    'nlga530d': {
      'ru': 'Контакты',
      'en': 'Contacts',
    },
    '4hnc68kp': {
      'ru': 'Поиск',
      'en': 'Search',
    },
    'i6h2tag4': {
      'ru': 'Поиск игроков',
      'en': 'Search for players',
    },
    '3rl0m5gs': {
      'ru': 'Поиск...',
      'en': 'Search',
    },
    '1nt56om2': {
      'ru': 'Home',
      'en': '',
    },
  },
  // ChatPage
  {
    '9j20p4xj': {
      'ru': 'Судоку',
      'en': '',
    },
    '3npfim3i': {
      'ru': 'Решить',
      'en': '',
    },
    'bf5d5ckm': {
      'ru': 'Контакт',
      'en': '',
    },
    'nieqetx6': {
      'ru': 'Unsupported message data. Please update application',
      'en': '',
    },
    '9ifla6gj': {
      'ru': 'Судоку',
      'en': 'Sudoku',
    },
    '19tid3vy': {
      'ru': 'Решить',
      'en': '',
    },
    '71tq953q': {
      'ru': 'Контакт',
      'en': 'Contact',
    },
    'svbptldj': {
      'ru': 'Unsupported message data. Please update application',
      'en': '',
    },
    '0trf3gwe': {
      'ru': 'Введите текст сообщения...',
      'en': 'Enter your message...',
    },
    'txtmnsf9': {
      'ru': 'Список участников',
      'en': 'List of participants',
    },
    '47q4ggqs': {
      'ru': 'Добавить пользователя...',
      'en': 'Add user...',
    },
    'ave166fn': {
      'ru': 'Search for an item...',
      'en': '',
    },
    '5f126xgw': {
      'ru': 'Home',
      'en': '',
    },
  },
  // GamePage
  {
    '6oj51nco': {
      'ru': 'Игра',
      'en': 'Game',
    },
    'psol6dxe': {
      'ru': 'Ошибок: ',
      'en': 'Mistakes: ',
    },
    'ip93paoi': {
      'ru': 'Ластик',
      'en': '',
    },
    'rl2tfaq6': {
      'ru': 'Ластик',
      'en': 'Eraser',
    },
    'hgh5g3d8': {
      'ru': 'Карандаш',
      'en': 'Pencil',
    },
    'rl7k8xfh': {
      'ru': 'Карандаш',
      'en': '',
    },
    '600qdeph': {
      'ru': 'Home',
      'en': '',
    },
  },
  // OnlineGamePage
  {
    'n1jyzn8i': {
      'ru': 'Ошибок: ',
      'en': 'Mistakes: ',
    },
    'actjhlr7': {
      'ru': 'Ластик',
      'en': '',
    },
    'j8fn09vx': {
      'ru': 'Ластик',
      'en': 'Eraser',
    },
    '0araynjm': {
      'ru': 'Карандаш',
      'en': 'Pencil',
    },
    '86h9wir8': {
      'ru': 'Карандаш',
      'en': '',
    },
    '6cid4dwo': {
      'ru': 'Ожидание игроков...',
      'en': 'Waiting for players...',
    },
    'ypbsentw': {
      'ru': 'Сдаться',
      'en': 'Give up',
    },
    '7zbz47ck': {
      'ru': 'Home',
      'en': '',
    },
  },
  // FinishedGamePage
  {
    'sn4499x5': {
      'ru': 'Поделиться судоку',
      'en': 'Share Sudoku',
    },
    '0ug5khqf': {
      'ru': 'Home',
      'en': '',
    },
  },
  // settingsPage
  {
    'vajhm0kx': {
      'ru': 'Настройки',
      'en': 'Settings',
    },
    'bxs2m7dt': {
      'ru': 'Тёмная тема',
      'en': 'Dark theme',
    },
    '4bv6ejva': {
      'ru': 'Язык',
      'en': 'Language',
    },
    'l2wunw1r': {
      'ru': 'Русский',
      'en': 'Русский',
    },
    '2lt4tndz': {
      'ru': 'English',
      'en': 'English',
    },
    'f4q0rq04': {
      'ru': 'Home',
      'en': '',
    },
  },
  // Miscellaneous
  {
    'b5q1kh7t': {
      'ru': '',
      'en': '',
    },
    '8wkvfecj': {
      'ru': '',
      'en': '',
    },
    '3849j56u': {
      'ru': '',
      'en': '',
    },
    'bltal2l2': {
      'ru': '',
      'en': '',
    },
    'dqbg32xu': {
      'ru': '',
      'en': '',
    },
    'aiu8e95v': {
      'ru': '',
      'en': '',
    },
    '592niij5': {
      'ru': '',
      'en': '',
    },
    'kfhedu9f': {
      'ru': '',
      'en': '',
    },
    '8mc706g6': {
      'ru': '',
      'en': '',
    },
    'k32zvphx': {
      'ru': '',
      'en': '',
    },
    '7vv7ifp8': {
      'ru': '',
      'en': '',
    },
    '3teq8v20': {
      'ru': '',
      'en': '',
    },
    'rzq20u0m': {
      'ru': '',
      'en': '',
    },
    '5rue28d4': {
      'ru': '',
      'en': '',
    },
    'fnm8pw43': {
      'ru': '',
      'en': '',
    },
    'we11wtu9': {
      'ru': '',
      'en': '',
    },
    'bjv9irsm': {
      'ru': '',
      'en': '',
    },
    'uczt8uca': {
      'ru': '',
      'en': '',
    },
    'bc5y1qm7': {
      'ru': '',
      'en': '',
    },
    'wime7ogl': {
      'ru': '',
      'en': '',
    },
    '0l12kl2l': {
      'ru': '',
      'en': '',
    },
    'wkutgeln': {
      'ru': '',
      'en': '',
    },
    '1n5qhn5e': {
      'ru': '',
      'en': '',
    },
    '9ski16kc': {
      'ru': '',
      'en': '',
    },
    'fx4114k2': {
      'ru': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
