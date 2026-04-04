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

const _loc = '경기도 안산시 단원구';
const _base = 'https://www.greenersfc.com';

String _pos18(int num) {
  if (num == 1 || num == 21 || num == 31) return 'GK';
  return 'MF';
}

PlayerInfo _u18(String name, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '안산그리너스 U-18',
  location: _loc,
  position: _pos18(num),
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2008),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/upload/player/$imgCode.jpg',
);

PlayerInfo _u15(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '안산그리너스 U-15',
  location: _loc,
  position: pos,
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2011),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/upload/player/$imgCode.jpg',
);

final List<PlayerInfo> ansanGreenersPlayers = [
  _u18('윤세영', 1, '3cONf2'),
  _u18('박준민', 3, '4OxBwD'),
  _u18('김한결', 4, 'US0XdB'),
  _u18('양지율', 5, 'OsGANm'),
  _u18('고재윤', 6, '2jYKO1'),
  _u18('연경모', 7, 'mkZ5bE'),
  _u18('문지수', 8, 'eYanhl'),
  _u18('김영광', 10, 'VGOVnq'),
  _u18('최예준', 11, 'ryzFp2'),
  _u18('홍영빈', 12, 'QORGSm'),
  _u18('정성철', 13, 'Itnt6C'),
  _u18('박지후', 14, '6yiJ8K'),
  _u18('전효성', 16, 'KAymgl'),
  _u18('고예성', 18, 'XiNAWP'),
  _u18('강새한', 19, 'LMDqp6'),
  _u18('김중현', 20, 'mvXnAo'),
  _u18('한재훈', 21, 'f6Kza7'),
  _u18('심우성', 22, 'mkZ5bE'),
  _u18('송민제', 23, 'LQiOu4'),
  _u18('윤시우', 24, 'ONuJs5'),
  _u18('이성현', 25, 'VQpvvq'),
  _u18('채우민', 26, 'PdFNN3'),
  _u18('박준현', 27, 'AuGHzc'),
  _u18('김하백', 28, 'Z6qDLg'),
  _u18('강이삭', 29, 'LiaXb6'),
  _u18('김우혁', 30, 'eAyty3'),
  _u18('유승우', 31, 'OMGvyX'),
  _u18('전민건', 32, '8P5v00'),
  _u18('임윤조', 33, 'sVOaBb'),
  _u18('김주원', 34, 'p61R6s'),
  _u18('윤서혁', 35, 'JvVqoq'),
  _u18('박지우', 36, 'LiaXb6'),
  _u18('정재성', 37, '7lpsGa'),
  _u18('승준영', 38, 'jWhzL2'),
  _u18('박데니스', 39, 'tfmDdV'),
  _u18('이민준', 40, 'b6anSQ'),
  _u18('김하율', 42, 'BWAZLw'),
  _u18('손재륜', 43, 'XfaF3O'),
  _u18('사진호', 44, '4tqCNw'),
  _u18('이준서', 45, 'MvhGUf'),
  _u18('김세준', 46, 'kKgimD'),
  _u18('류강민', 47, 'WDUQWV'),
  _u18('황우석', 48, 'kQk6d4'),
  _u18('김도원', 55, 'BA0lbK'),

  _u15('정다윗', 'GK', 1, 'UOYZSM'),
  _u15('김상우', 'DF', 2, 'ZXNddg'),
  _u15('민진후', 'DF', 3, 'tgEpoT'),
  _u15('경시훈', 'DF', 4, 'LvfcLd'),
  _u15('최현성', 'DF', 5, 'i1kSRq'),
  _u15('황연우', 'MF', 7, 'hFqSBt'),
  _u15('송대현', 'MF', 8, 'icbC8W'),
  _u15('임강혁', 'MF', 10, 'r3zW1Q'),
  _u15('유지석', 'MF', 11, 'ILLgGq'),
  _u15('김찬희', 'DF', 12, 'icbC8W'),
  _u15('조승유', 'FW', 9, 'Wo35YW'),
];
