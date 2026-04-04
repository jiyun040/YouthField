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

PlayerInfo _u15(String name, String pos, int num, {String? imageUrl}) => PlayerInfo(
  name: name,
  school: 'FC서울 U-15',
  location: _loc,
  position: pos,
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2011),
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

  _u15('이서준', _pos(1), 1, imageUrl: 'assets/images/players/fc_seoul/u15_1_이서준.jpg'),
  _u15('강재원', _pos(3), 3, imageUrl: 'assets/images/players/fc_seoul/u15_3_강재원.jpg'),
  _u15('손호정', _pos(4), 4, imageUrl: 'assets/images/players/fc_seoul/u15_4_손호정.jpg'),
  _u15('홍근정', _pos(5), 5, imageUrl: 'assets/images/players/fc_seoul/u15_5_홍근정.jpg'),
  _u15('김태호', _pos(6), 6, imageUrl: 'assets/images/players/fc_seoul/u15_6_김태호.jpg'),
  _u15('손정범', _pos(7), 7, imageUrl: 'assets/images/players/fc_seoul/u15_7_손정범.jpg'),
  _u15('고필관', _pos(8), 8, imageUrl: 'assets/images/players/fc_seoul/u15_8_고필관.jpg'),
  _u15('양승현', _pos(9), 9, imageUrl: 'assets/images/players/fc_seoul/u15_9_양승현.jpg'),
  _u15('민태인', _pos(10), 10, imageUrl: 'assets/images/players/fc_seoul/u15_10_민태인.jpg'),
  _u15('김세완', _pos(11), 11, imageUrl: 'assets/images/players/fc_seoul/u15_11_김세완.jpg'),
  _u15('안성빈', _pos(13), 13, imageUrl: 'assets/images/players/fc_seoul/u15_13_안성빈.jpg'),
  _u15('이현승', _pos(14), 14, imageUrl: 'assets/images/players/fc_seoul/u15_14_이현승.jpg'),
  _u15('정현웅', _pos(15), 15, imageUrl: 'assets/images/players/fc_seoul/u15_15_정현웅.jpg'),
  _u15('조민협', _pos(16), 16, imageUrl: 'assets/images/players/fc_seoul/u15_16_조민협.jpg'),
  _u15('이성윤', _pos(17), 17, imageUrl: 'assets/images/players/fc_seoul/u15_17_이성윤.jpg'),
  _u15('박정호', _pos(18), 18, imageUrl: 'assets/images/players/fc_seoul/u15_18_박정호.jpg'),
  _u15('김용혁', _pos(19), 19, imageUrl: 'assets/images/players/fc_seoul/u15_19_김용혁.jpg'),
  _u15('김종현', _pos(20), 20, imageUrl: 'assets/images/players/fc_seoul/u15_20_김종현.jpg'),
  _u15('유진석', _pos(21), 21, imageUrl: 'assets/images/players/fc_seoul/u15_21_유진석.jpg'),
  _u15('김지호', _pos(22), 22, imageUrl: 'assets/images/players/fc_seoul/u15_22_김지호.jpg'),
  _u15('김지성', _pos(23), 23, imageUrl: 'assets/images/players/fc_seoul/u15_23_김지성.jpg'),
  _u15('정연재', _pos(24), 24, imageUrl: 'assets/images/players/fc_seoul/u15_24_정연재.jpg'),
  _u15('황승민', _pos(25), 25, imageUrl: 'assets/images/players/fc_seoul/u15_25_황승민.jpg'),
  _u15('문성민', _pos(26), 26, imageUrl: 'assets/images/players/fc_seoul/u15_26_문성민.jpg'),
  _u15('이서현', _pos(27), 27, imageUrl: 'assets/images/players/fc_seoul/u15_27_이서현.jpg'),
  _u15('김민건', _pos(28), 28, imageUrl: 'assets/images/players/fc_seoul/u15_28_김민건.jpg'),
  _u15('김도윤', _pos(29), 29, imageUrl: 'assets/images/players/fc_seoul/u15_29_김도윤.jpg'),
  _u15('장예건', _pos(30), 30, imageUrl: 'assets/images/players/fc_seoul/u15_30_장예건.jpg'),
  _u15('변준혁', _pos(31), 31, imageUrl: 'assets/images/players/fc_seoul/u15_31_변준혁.jpg'),
  _u15('노시온', _pos(32), 32, imageUrl: 'assets/images/players/fc_seoul/u15_32_노시온.jpg'),
  _u15('권영웅', _pos(33), 33, imageUrl: 'assets/images/players/fc_seoul/u15_33_권영웅.jpg'),
  _u15('김건우', _pos(34), 34, imageUrl: 'assets/images/players/fc_seoul/u15_34_김건우.jpg'),
  _u15('정하원', _pos(35), 35, imageUrl: 'assets/images/players/fc_seoul/u15_35_정하원.jpg'),
  _u15('남건우', _pos(36), 36, imageUrl: 'assets/images/players/fc_seoul/u15_36_남건우.jpg'),
  _u15('심규연', _pos(37), 37, imageUrl: 'assets/images/players/fc_seoul/u15_37_심규연.jpg'),
  _u15('박지후', _pos(38), 38, imageUrl: 'assets/images/players/fc_seoul/u15_38_박지후.jpg'),
  _u15('이승찬', _pos(39), 39, imageUrl: 'assets/images/players/fc_seoul/u15_39_이승찬.jpg'),
  _u15('태윤진', _pos(40), 40, imageUrl: 'assets/images/players/fc_seoul/u15_40_태윤진.jpg'),
  _u15('안제민', _pos(41), 41, imageUrl: 'assets/images/players/fc_seoul/u15_41_안제민.jpg'),
  _u15('김태성', _pos(42), 42, imageUrl: 'assets/images/players/fc_seoul/u15_42_김태성.jpg'),
  _u15('문지환', _pos(43), 43, imageUrl: 'assets/images/players/fc_seoul/u15_43_문지환.jpg'),
  _u15('김교윤', _pos(44), 44, imageUrl: 'assets/images/players/fc_seoul/u15_44_김교윤.jpg'),
];
