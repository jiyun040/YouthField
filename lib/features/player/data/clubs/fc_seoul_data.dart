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

PlayerInfo _u18(String name, String pos, int num, {String? imageUrl}) => PlayerInfo(
  name: name,
  school: 'FC서울 U-18',
  location: _loc,
  position: pos,
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2008),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: imageUrl,
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
  _u18('강대규', _pos(1), 1, imageUrl: 'assets/images/players/fc_seoul/u18_1_강대규.jpg'),
  _u18('이지석', _pos(3), 3, imageUrl: 'assets/images/players/fc_seoul/u18_3_이지석.jpg'),
  _u18('송준휘', _pos(6), 6, imageUrl: 'assets/images/players/fc_seoul/u18_6_송준휘.jpg'),
  _u18('김광원', _pos(7), 7, imageUrl: 'assets/images/players/fc_seoul/u18_7_김강원.jpg'),
  _u18('최준서', _pos(9), 9, imageUrl: 'assets/images/players/fc_seoul/u18_9_최준서.jpg'),
  _u18('김지원', _pos(10), 10, imageUrl: 'assets/images/players/fc_seoul/u18_10_김지원.jpg'),
  _u18('손승범', _pos(11), 11, imageUrl: 'assets/images/players/fc_seoul/u18_11_손승범.jpg'),
  _u18('허동민', _pos(23), 23, imageUrl: 'assets/images/players/fc_seoul/u18_23_허동민.jpg'),
  _u18('이승준', _pos(88), 88, imageUrl: 'assets/images/players/fc_seoul/u18_88_이승준.jpg'),
  _u18('최준영', _pos(5), 5, imageUrl: 'assets/images/players/fc_seoul/u18_5_최준영.jpg'),
  _u18('김전태수', _pos(8), 8, imageUrl: 'assets/images/players/fc_seoul/u18_8_김전태수.jpg'),
  _u18('양승민', _pos(13), 13, imageUrl: 'assets/images/players/fc_seoul/u18_13_양승민.jpg'),
  _u18('민지훈', _pos(14), 14, imageUrl: 'assets/images/players/fc_seoul/u18_14_민지훈.jpg'),
  _u18('이주환', _pos(16), 16, imageUrl: 'assets/images/players/fc_seoul/u18_16_이주환.jpg'),
  _u18('정건욱', _pos(17), 17, imageUrl: 'assets/images/players/fc_seoul/u18_17_정건욱.jpg'),
  _u18('민시영', _pos(18), 18, imageUrl: 'assets/images/players/fc_seoul/u18_18_민시영.jpg'),
  _u18('송준혁', _pos(19), 19, imageUrl: 'assets/images/players/fc_seoul/u18_19_송준혁.jpg'),
  _u18('이재민', _pos(20), 20, imageUrl: 'assets/images/players/fc_seoul/u18_20_이재민.jpg'),
  _u18('이정찬', _pos(22), 22, imageUrl: 'assets/images/players/fc_seoul/u18_22_이정찬.jpg'),
  _u18('배현서', _pos(24), 24, imageUrl: 'assets/images/players/fc_seoul/u18_24_배현서.jpg'),
  _u18('원서연', _pos(26), 26, imageUrl: 'assets/images/players/fc_seoul/u18_26_원서연.jpg'),
  _u18('김민성', _pos(15), 15, imageUrl: 'assets/images/players/fc_seoul/u18_15_김민성.jpg'),
  _u18('박선욱', 'GK', 21, imageUrl: 'assets/images/players/fc_seoul/u18_21_박선욱.jpg'),
  _u18('이주환', _pos(25), 25, imageUrl: 'assets/images/players/fc_seoul/u18_25_이주환.jpg'),
  _u18('서민덕', _pos(30), 30, imageUrl: 'assets/images/players/fc_seoul/u18_30_서민덕.jpg'),
  _u18('윤기욱', 'GK', 31, imageUrl: 'assets/images/players/fc_seoul/u18_31_윤기욱.jpg'),
  _u18('강주혁', _pos(32), 32, imageUrl: 'assets/images/players/fc_seoul/u18_32_강주혁.jpg'),
  _u18('이영준', _pos(33), 33, imageUrl: 'assets/images/players/fc_seoul/u18_33_이영준.jpg'),
  _u18('서명식', _pos(35), 35, imageUrl: 'assets/images/players/fc_seoul/u18_35_서명식.jpg'),
  _u18('권서준', _pos(37), 37, imageUrl: 'assets/images/players/fc_seoul/u18_37_권서준.jpg'),
  _u18('박시환', _pos(39), 39, imageUrl: 'assets/images/players/fc_seoul/u18_39_박시환.jpg'),
  _u18('정현수', _pos(47), 47, imageUrl: 'assets/images/players/fc_seoul/u18_47_정현수.jpg'),
  _u18('김유건', _pos(66), 66, imageUrl: 'assets/images/players/fc_seoul/u18_66_김유건.jpg'),
  _u18('사무엘', _pos(79), 79, imageUrl: 'assets/images/players/fc_seoul/u18_79_사무엘.jpg'),
];
