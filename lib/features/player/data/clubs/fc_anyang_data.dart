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

const _loc = '경기도 안양시 만안구';
const _base = 'https://www.fc-anyang.com';

PlayerInfo _u18(String name, String pos, int num, {String? img}) => PlayerInfo(
  name: name,
  school: 'FC안양 U-18',
  location: _loc,
  position: pos,
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2007),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: img,
);

PlayerInfo _u15(String name, String pos, int num, {String? img}) => PlayerInfo(
  name: name,
  school: 'FC안양 U-15',
  location: _loc,
  position: pos,
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2010),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: img,
);

PlayerInfo _u12(String name, String pos, int num, {String? img}) => PlayerInfo(
  name: name,
  school: 'FC안양 U-12',
  location: _loc,
  position: pos,
  ageGroup: 'U-12',
  number: num,
  birthdate: _bd(num, 2013),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: img,
);

String _img18(int num) =>
    '$_base/images/youth/2025/u18_player_${num.toString().padLeft(2, '0')}.jpg';

String _img15(int num) =>
    '$_base/images/youth/2025/u15_player_${num.toString().padLeft(2, '0')}.jpg';

String _img12(int num) =>
    '$_base/images/youth/2025/u12_player_${num.toString().padLeft(2, '0')}.jpg';

final List<PlayerInfo> fcAnyangPlayers = [
  _u18('정민재', 'GK', 13, img: _img18(13)),
  _u18('이은우', 'DF', 2, img: _img18(2)),
  _u18('심현서', 'DF', 3, img: _img18(3)),
  _u18('김민성', 'DF', 4, img: _img18(4)),
  _u18('길예준', 'DF', 6, img: _img18(6)),
  _u18('노승환', 'DF', 7, img: _img18(7)),
  _u18('신무진', 'DF', 37, img: _img18(37)),
  _u18('김재윤', 'DF', 32, img: _img18(32)),
  _u18('조정윤', 'DF', 34, img: _img18(34)),
  _u18('유성', 'DF', 28, img: _img18(28)),
  _u18('박민건', 'MF', 8, img: _img18(8)),
  _u18('김지후', 'MF', 12, img: _img18(12)),
  _u18('이찬영', 'MF', 15, img: _img18(15)),
  _u18('이도현', 'MF', 16, img: _img18(16)),
  _u18('임채민', 'MF', 17, img: _img18(17)),
  _u18('안재용', 'MF', 19, img: _img18(19)),
  _u18('이호진', 'MF', 23, img: _img18(23)),
  _u18('김민재', 'MF', 29, img: _img18(29)),
  _u18('손지한', 'MF', 32, img: _img18(32)),
  _u18('오형준', 'FW', 10, img: _img18(10)),
  _u18('윤수빈', 'FW', 11, img: _img18(11)),
  _u18('이도현', 'FW', 18, img: _img18(18)),
  _u18('장유찬', 'FW', 27, img: _img18(27)),

  _u15('위은우', 'GK', 1, img: _img15(1)),
  _u15('조원제', 'GK', 21, img: _img15(21)),
  _u15('박도윤', 'GK', 25, img: _img15(25)),
  _u15('변지수', 'GK', 31, img: _img15(31)),
  _u15('김하랑', 'DF', 3, img: _img15(3)),
  _u15('이세종', 'DF', 15, img: _img15(15)),
  _u15('채도진', 'DF', 19, img: _img15(19)),
  _u15('홍예준', 'DF', 20, img: _img15(20)),
  _u15('이제준', 'DF', 30, img: _img15(30)),
  _u15('남궁윤', 'DF', 38, img: _img15(38)),
  _u15('유지환', 'DF', 39, img: _img15(39)),
  _u15('최서준', 'DF', 34, img: _img15(34)),
  _u15('오재원', 'MF', 4, img: _img15(4)),
  _u15('조정훈', 'MF', 5, img: _img15(5)),
  _u15('홍선우', 'MF', 6, img: _img15(6)),
  _u15('김민준', 'MF', 8, img: _img15(8)),
  _u15('윤호재', 'MF', 12, img: _img15(12)),
  _u15('이지온', 'MF', 14, img: _img15(14)),
  _u15('김동건', 'MF', 16, img: _img15(16)),
  _u15('김동현', 'MF', 22, img: _img15(22)),
  _u15('박재원', 'MF', 29, img: _img15(29)),
  _u15('김동연', 'MF', 32, img: _img15(32)),
  _u15('황인서', 'MF', 35, img: _img15(35)),
  _u15('여상호', 'FW', 13, img: _img15(13)),
  _u15('박지호', 'FW', 14, img: _img15(14)),
  _u15('윤건희', 'FW', 17, img: _img15(17)),
  _u15('심지후', 'FW', 27, img: _img15(27)),
  _u15('조서빈', 'FW', 28, img: _img15(28)),
  _u15('김재율', 'FW', 36, img: _img15(36)),
  _u15('김태양', 'FW', 37, img: _img15(37)),

  _u12('김주원', 'GK', 1, img: _img12(1)),
  _u12('서경현', 'GK', 21, img: _img12(21)),
  _u12('박주원', 'DF', 5, img: _img12(5)),
  _u12('김현태', 'DF', 6, img: _img12(6)),
  _u12('최주원', 'DF', 8, img: _img12(8)),
  _u12('마성우', 'DF', 9, img: _img12(9)),
  _u12('신동하', 'DF', 22, img: _img12(22)),
  _u12('이현기', 'DF', 19, img: _img12(19)),
  _u12('태유찬', 'MF', 10, img: _img12(10)),
  _u12('조여준', 'MF', 11, img: _img12(11)),
  _u12('김시우', 'MF', 13, img: _img12(13)),
  _u12('김주원', 'MF', 15, img: _img12(15)),
  _u12('조민준', 'MF', 17, img: _img12(17)),
  _u12('유주완', 'FW', 2, img: _img12(2)),
  _u12('최지욱', 'FW', 4, img: _img12(4)),
  _u12('오석민', 'FW', 12, img: _img12(12)),
  _u12('박서준', 'FW', 16, img: _img12(16)),
  _u12('정유찬', 'FW', 18, img: _img12(18)),
  _u12('이주찬', 'FW', 20, img: _img12(20)),
];
