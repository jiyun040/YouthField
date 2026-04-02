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

const _loc = '서울특별시 마포구';

PlayerInfo _u18(String name, String pos, int num) => PlayerInfo(
  name: name,
  school: 'FC서울 U-18',
  location: _loc,
  position: pos,
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2007),
  seasonStats: _zero,
  nationalStats: _zero,
);

String _pos(int num) {
  if (num == 1 || num == 21 || num == 31 || num == 41) {
    return 'GK';
  }
  if (num <= 5 ||
      (num >= 12 && num <= 16) ||
      num == 20 ||
      (num >= 22 && num <= 26)) {
    return 'DF';
  }
  if (num == 9 ||
      num == 10 ||
      num == 11 ||
      num == 17 ||
      num == 18 ||
      num == 19 ||
      (num >= 27 && num <= 33)) {
    return 'FW';
  }
  return 'MF';
}

final List<PlayerInfo> fcSeoulPlayers = [
  _u18('강대규', _pos(1), 1),
  _u18('이지석', _pos(3), 3),
  _u18('송준휘', _pos(6), 6),
  _u18('김광원', _pos(7), 7),
  _u18('최준서', _pos(9), 9),
  _u18('김지원', _pos(10), 10),
  _u18('손승범', _pos(11), 11),
  _u18('허동민', _pos(23), 23),
  _u18('이승준', _pos(88), 88),
  _u18('최준영', _pos(5), 5),
  _u18('김전태수', _pos(8), 8),
  _u18('양승민', _pos(13), 13),
  _u18('민지훈', _pos(14), 14),
  _u18('이주환', _pos(16), 16),
  _u18('정건욱', _pos(17), 17),
  _u18('민시영', _pos(18), 18),
  _u18('송준혁', _pos(19), 19),
  _u18('이재민', _pos(20), 20),
  _u18('이정찬', _pos(22), 22),
  _u18('배현서', _pos(24), 24),
  _u18('원서연', _pos(26), 26),
  _u18('김민성', _pos(15), 15),
  _u18('박선욱', 'GK', 21),
  _u18('이주환', _pos(25), 25),
  _u18('서민덕', _pos(30), 30),
  _u18('윤기욱', 'GK', 31),
  _u18('강주혁', _pos(32), 32),
  _u18('이영준', _pos(33), 33),
  _u18('서명식', _pos(35), 35),
  _u18('권서준', _pos(37), 37),
  _u18('박시환', _pos(39), 39),
  _u18('정현수', _pos(47), 47),
  _u18('김유건', _pos(66), 66),
  _u18('사무엘', _pos(79), 79),
];
