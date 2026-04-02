import 'package:youthfield/features/mypage/domain/entities/player_stats.dart';
import 'package:youthfield/features/player/domain/entities/player_info.dart';

const _zero = PlayerStats(
  appearances: 0,
  goals: 0,
  assists: 0,
  yellowCards: 0,
  redCards: 0,
);

String _bd(int num, int baseYear) {
  final y = baseYear + (num % 3);
  final m = ((num * 3) % 12) + 1;
  final d = ((num * 7) % 28) + 1;
  return "$y.${m.toString().padLeft(2, '0')}.${d.toString().padLeft(2, '0')}";
}

const _loc = '경상북도 김천시';
const _base = 'https://www.gimcheonfc.com';

PlayerInfo _u18(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '김천상무 U-18',
  location: _loc,
  position: pos,
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2008),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/pg/data/syplayer/$imgCode.png',
);

PlayerInfo _u15(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '김천상무 U-15',
  location: _loc,
  position: pos,
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2011),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/pg/data/syplayer/$imgCode.png',
);

PlayerInfo _u12(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '김천상무 U-12',
  location: _loc,
  position: pos,
  ageGroup: 'U-12',
  number: num,
  birthdate: _bd(num, 2014),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/pg/data/syplayer/$imgCode.png',
);

final List<PlayerInfo> gimcheonPlayers = [
  _u18('천민철', 'GK', 1, 'urqNkZ'),
  _u18('이민준', 'GK', 21, 'QuFO0U'),
  _u18('백종훈', 'GK', 31, 'QkXoXX'),
  _u18('안태근', 'DF', 2, 'OSTgCy'),
  _u18('고우진', 'DF', 3, 'gLi5FG'),
  _u18('김호진', 'DF', 5, 'ZLcjKn'),
  _u18('송찬홍', 'DF', 8, 'oyirOi'),
  _u18('박주환', 'DF', 14, 'Pyznab'),
  _u18('김우주', 'DF', 20, 'TROTd7'),
  _u18('한현수', 'DF', 24, 'fvimQe'),
  _u18('정형민', 'DF', 25, 'aDFU2Y'),
  _u18('김광모', 'DF', 29, 'rJprO0'),
  _u18('임윤호', 'DF', 30, 'ITM7fn'),
  _u18('유정현', 'DF', 33, 'POVegw'),
  _u18('조성빈', 'MF', 4, '4aPOCx'),
  _u18('최범준', 'MF', 7, 'liFwKR'),
  _u18('박서준', 'MF', 10, 'fdd0vM'),
  _u18('황재원', 'MF', 11, '5NoNpB'),
  _u18('김승윤', 'MF', 12, 'ziv5sC'),
  _u18('오주영', 'MF', 13, 'LrCf2p'),
  _u18('임재훈', 'MF', 16, '896kK6'),
  _u18('박세민', 'MF', 17, 'cAooE6'),
  _u18('이윤후', 'MF', 19, 'WRrhHz'),
  _u18('정지후', 'MF', 22, 'ZS9EIA'),
  _u18('박지훈', 'MF', 26, 'ZS9EIA'),
  _u18('박주한', 'MF', 28, 'oTOLoA'),
  _u18('손지한', 'MF', 32, 'oTOLoA'),
  _u18('강윤우', 'FW', 9, 'rjnYQf'),
  _u18('우지성', 'FW', 18, '3C2S6j'),
  _u18('김승원', 'FW', 27, 'OIYDuD'),

  _u15('김도욱', 'GK', 12, 'dab0h2'),
  _u15('이주현', 'GK', 21, 'J9oDRT'),
  _u15('엄다온', 'GK', 41, 'fuRl14'),
  _u15('이지호', 'DF', 2, 'mbu3KT'),
  _u15('손서윤', 'DF', 3, 'LoJ3j1'),
  _u15('김한율', 'DF', 5, '6wKDvW'),
  _u15('류서준', 'DF', 6, 'lJGJt6'),
  _u15('오서후', 'DF', 23, 'Lw0JKm'),
  _u15('조예성', 'DF', 25, 'EYjjK6'),
  _u15('서지완', 'DF', 26, 'JAjwW2'),
  _u15('김도현', 'DF', 27, 'Tiys77'),
  _u15('김하온', 'DF', 32, 'wB4u9w'),
  _u15('황지후', 'MF', 4, '6Ld3Ux'),
  _u15('최은동', 'MF', 8, 'rbmenW'),
  _u15('황성민', 'MF', 10, 'aS21D5'),
  _u15('이민기', 'MF', 14, 'chnuNx'),
  _u15('박유건', 'MF', 15, 'Yu5Mtz'),
  _u15('최은혁', 'MF', 19, 'iFy1GU'),
  _u15('김승민', 'MF', 28, 'WfS0nH'),
  _u15('임태균', 'MF', 29, 'GJc204'),
  _u15('장영준', 'MF', 33, '4YzBE0'),
  _u15('신민섭', 'MF', 37, 'qHuGd4'),
  _u15('강태완', 'FW', 7, 'nZBYnw'),
  _u15('이도윤', 'FW', 9, '5ikbL3'),
  _u15('남초윤', 'FW', 11, 'SxJEYU'),
  _u15('정도위', 'FW', 13, 'jLZZn4'),
  _u15('최시현', 'FW', 17, 'miMP0y'),
  _u15('이현서', 'FW', 18, '7JvVOH'),
  _u15('이강재', 'FW', 20, 'OpMCHQ'),
  _u15('이태윤', 'FW', 24, 'StR6rq'),
  _u15('정민준', 'FW', 30, 'wiICS3'),
  _u15('임동인', 'FW', 34, 'Ewd5MW'),
  _u15('이환', 'FW', 35, '6T0OEs'),
  _u15('황승민', 'FW', 36, 'IID1Rx'),

  _u12('최유건', 'GK', 1, 'RWW3Sl'),
  _u12('강마로', 'DF', 4, 'pdAlsZ'),
  _u12('이한준', 'DF', 11, 'C3v87L'),
  _u12('손효섭', 'DF', 13, '6EHPRx'),
  _u12('호영광', 'DF', 14, '5sRWqL'),
  _u12('강우진', 'DF', 20, '3ofSlb'),
  _u12('이지율', 'DF', 24, 'mHnHft'),
  _u12('지성빈', 'MF', 8, 'TEnYAd'),
  _u12('신예강', 'MF', 17, 'nTNwpT'),
  _u12('김주성', 'MF', 18, 'PacHRn'),
  _u12('김경동', 'MF', 21, 'lxXBm7'),
  _u12('김시윤', 'MF', 22, 'xskupu'),
  _u12('박강윤', 'MF', 23, 'mtTPge'),
  _u12('강민준', 'FW', 7, '7e42TT'),
  _u12('김태욱', 'FW', 9, 'sGqZ2v'),
  _u12('김명준', 'FW', 10, 'YaalO4'),
];
