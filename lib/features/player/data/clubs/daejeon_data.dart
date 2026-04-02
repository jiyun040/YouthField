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

const _loc = '대전광역시 유성구';
const _base = 'https://www.dhcfc.kr';

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

PlayerInfo _u18(String name, int num) => PlayerInfo(
  name: name,
  school: '대전하나시티즌 U-18',
  location: _loc,
  position: _pos(num),
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2007),
  seasonStats: _zero,
  nationalStats: _zero,
);

PlayerInfo _u15(String name, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '대전하나시티즌 U-15',
  location: _loc,
  position: _pos(num),
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2010),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/data/splayer/$imgCode.jpg',
);

final List<PlayerInfo> daejeonPlayers = [
  _u18('권민성', 1),
  _u18('이승준', 2),
  _u18('김도연', 3),
  _u18('박진수', 4),
  _u18('김태우', 5),
  _u18('유현수', 6),
  _u18('윤남지', 7),
  _u18('박병찬', 8),
  _u18('박서준', 9),
  _u18('김성민', 10),
  _u18('전용재', 11),
  _u18('최주형', 12),
  _u18('서인용', 13),
  _u18('이상혁', 14),
  _u18('최성혁', 15),
  _u18('이지우', 16),
  _u18('구훈민', 17),
  _u18('최규성', 18),
  _u18('김지호', 19),
  _u18('이찬희', 20),
  _u18('천우진', 21),
  _u18('이찬준', 24),
  _u18('박승준', 25),
  _u18('홍유준', 26),
  _u18('한재현', 27),
  _u18('최규용', 28),
  _u18('정지운', 29),
  _u18('권래원', 30),
  _u18('노명종', 31),
  _u18('최현', 32),
  _u18('이시훈', 33),
  _u18('김현진', 34),
  _u18('강몽규', 35),
  _u18('정경식', 36),
  _u18('김원빈', 37),
  _u18('권도현', 38),

  _u15('최지후', 1, 'fAZT15'),
  _u15('길환준', 2, '0z3iYN'),
  _u15('송승현', 3, 'OCQAZK'),
  _u15('김용민', 4, 'jadaqP'),
  _u15('임범준', 5, 'PxOrW9'),
  _u15('이승준', 6, 'n4CY0A'),
  _u15('장준혁', 7, 'G7kDIT'),
  _u15('지윤', 8, 'jRqp60'),
  _u15('김동현', 10, '4itxU8'),
  _u15('한승아', 11, 'EfBy64'),
  _u15('이승현', 13, 'Gkpz4W'),
  _u15('배유찬', 14, 'DmqDJb'),
  _u15('이동호', 15, 'RLazer'),
  _u15('김연후', 16, 'aTSFIt'),
  _u15('조재현', 17, 'swT4Fr'),
  _u15('강민준', 18, 'yBnge9'),
  _u15('오시훈', 19, 'vgNLqJ'),
  _u15('김현중', 20, 'CvtWmO'),
  _u15('이건우', 22, 'fPNFcB'),
  _u15('한지우', 24, 'ucKwu4'),
  _u15('이재율', 26, 'yTEDUO'),
  _u15('한우진', 28, 'M4B4p8'),
  _u15('이서율', 30, 'B69Dn3'),
  _u15('박원철', 32, '63m6E7'),
  _u15('김지호', 33, 'jIS0nu'),
  _u15('고승유', 34, 'FmJ3CO'),
  _u15('이수호', 35, 'pN68c8'),
  _u15('김승민', 36, 'xTuaqO'),
  _u15('박민찬', 37, 'UoBzZ9'),
  _u15('윤성현', 38, 'G0JJK8'),
  _u15('황우준', 39, 'Mdxse7'),
  _u15('장민율', 40, 'OYM8X9'),
  _u15('바넷로건태경', 41, 'W6d4A0'),
  _u15('주민건', 42, 'xSnWbH'),
  _u15('오승유', 43, 'T4HfIm'),
  _u15('김건우', 44, 'lVaQrD'),
  _u15('배성재', 45, 'nXlVoM'),
  _u15('이준호', 46, 'PjCy06'),
  _u15('남윤호', 47, 'HKqYpu'),
  _u15('최태윤', 48, 'aGDwb8'),
  _u15('박서준', 51, 'HKqYpu'),
];
