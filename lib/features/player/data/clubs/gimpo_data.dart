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

const _loc = '경기도 김포시';

String _fieldPos(int num) {
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

PlayerInfo _u18(String name, String pos, int num) => PlayerInfo(
  name: name,
  school: '김포FC U-18',
  location: _loc,
  position: pos,
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2007),
  seasonStats: _zero,
  nationalStats: _zero,
);

PlayerInfo _u15(String name, String pos, int num) => PlayerInfo(
  name: name,
  school: '김포FC U-15',
  location: _loc,
  position: pos,
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2010),
  seasonStats: _zero,
  nationalStats: _zero,
);

PlayerInfo _u12(String name, String pos, int num) => PlayerInfo(
  name: name,
  school: '김포FC U-12',
  location: _loc,
  position: pos,
  ageGroup: 'U-12',
  number: num,
  birthdate: _bd(num, 2013),
  seasonStats: _zero,
  nationalStats: _zero,
);

final List<PlayerInfo> gimpoPlayers = [
  _u18('송상헌', 'GK', 1),
  _u18('이은찬', 'GK', 21),
  _u18('김우진', 'GK', 25),
  _u18('이시원', 'GK', 67),
  _u18('최민규', _fieldPos(2), 2),
  _u18('최준수', _fieldPos(3), 3),
  _u18('김지민', _fieldPos(4), 4),
  _u18('양도경', _fieldPos(5), 5),
  _u18('김수호', _fieldPos(6), 6),
  _u18('임희수', _fieldPos(7), 7),
  _u18('문채환', _fieldPos(8), 8),
  _u18('심하원', _fieldPos(9), 9),
  _u18('김재원', _fieldPos(10), 10),
  _u18('김준서', _fieldPos(11), 11),
  _u18('이유빈', _fieldPos(12), 12),
  _u18('최유빈', _fieldPos(13), 13),
  _u18('손해성', _fieldPos(14), 14),
  _u18('오재혁', _fieldPos(16), 16),
  _u18('김민성', _fieldPos(17), 17),
  _u18('박시윤', _fieldPos(18), 18),
  _u18('김연빈', _fieldPos(19), 19),
  _u18('김민상', _fieldPos(20), 20),
  _u18('유은호', _fieldPos(22), 22),
  _u18('문지수', _fieldPos(23), 23),
  _u18('이현석', _fieldPos(27), 27),
  _u18('조정일', _fieldPos(37), 37),
  _u18('양건', _fieldPos(40), 40),
  _u18('박건호', _fieldPos(41), 41),
  _u18('이서준', _fieldPos(66), 66),
  _u18('김민석', _fieldPos(77), 77),
  _u18('박승우', _fieldPos(88), 88),
  _u18('강민혁', _fieldPos(99), 99),

  _u15('이민기', 'GK', 1),
  _u15('황정인', 'GK', 21),
  _u15('홍석진', 'GK', 31),
  _u15('박수민', 'GK', 41),
  _u15('이주언', _fieldPos(2), 2),
  _u15('최우수', _fieldPos(3), 3),
  _u15('황주원', _fieldPos(4), 4),
  _u15('한재원', _fieldPos(5), 5),
  _u15('김태욱', _fieldPos(6), 6),
  _u15('곽승우', _fieldPos(7), 7),
  _u15('강윤성', _fieldPos(8), 8),
  _u15('김랑희', _fieldPos(9), 9),
  _u15('이준혁', _fieldPos(10), 10),
  _u15('김한울', _fieldPos(11), 11),
  _u15('김재원', _fieldPos(12), 12),
  _u15('박홍규', _fieldPos(13), 13),
  _u15('최진호', _fieldPos(14), 14),
  _u15('채지후', _fieldPos(15), 15),
  _u15('최원준', _fieldPos(16), 16),
  _u15('김현서', _fieldPos(17), 17),
  _u15('손아준', _fieldPos(18), 18),
  _u15('하승준', _fieldPos(19), 19),
  _u15('정우빈', _fieldPos(20), 20),
  _u15('변시윤', _fieldPos(22), 22),
  _u15('김주원', _fieldPos(23), 23),
  _u15('강윤재', _fieldPos(24), 24),
  _u15('천승우', _fieldPos(25), 25),
  _u15('김준섭', _fieldPos(26), 26),
  _u15('박상우', _fieldPos(27), 27),
  _u15('이준효', _fieldPos(28), 28),
  _u15('이윤호', _fieldPos(29), 29),
  _u15('장우진', _fieldPos(30), 30),
  _u15('홍석진', _fieldPos(31), 31),
  _u15('이하율', _fieldPos(32), 32),
  _u15('박민성', _fieldPos(33), 33),
  _u15('성태인', _fieldPos(34), 34),
  _u15('김승원', _fieldPos(35), 35),
  _u15('지윤호', _fieldPos(36), 36),
  _u15('유재빈', _fieldPos(37), 37),
  _u15('최서율', _fieldPos(38), 38),
  _u15('김규헌', _fieldPos(39), 39),
  _u15('강보성', _fieldPos(40), 40),
  _u15('박수민', _fieldPos(41), 41),
  _u15('강지원', _fieldPos(42), 42),
  _u15('김보승', _fieldPos(43), 43),
  _u15('신승철', _fieldPos(44), 44),
  _u15('마효성', _fieldPos(45), 45),

  _u12('김도윤', 'GK', 1),
  _u12('양수빈', 'GK', 21),
  _u12('서민찬', 'GK', 31),
  _u12('김율', _fieldPos(2), 2),
  _u12('김민재', _fieldPos(3), 3),
  _u12('조하준', _fieldPos(4), 4),
  _u12('박정후', _fieldPos(5), 5),
  _u12('석우찬', _fieldPos(6), 6),
  _u12('이서진', _fieldPos(7), 7),
  _u12('김지후', _fieldPos(8), 8),
  _u12('이서준', _fieldPos(9), 9),
  _u12('심예린', _fieldPos(10), 10),
  _u12('조예준', _fieldPos(11), 11),
  _u12('이서준', _fieldPos(12), 12),
  _u12('김승민', _fieldPos(13), 13),
  _u12('유선민', _fieldPos(14), 14),
  _u12('최서준', _fieldPos(15), 15),
  _u12('권은찬', _fieldPos(16), 16),
  _u12('이하준', _fieldPos(17), 17),
  _u12('곽승우', _fieldPos(18), 18),
  _u12('이한결', _fieldPos(19), 19),
  _u12('박하준', _fieldPos(20), 20),
  _u12('신로이', _fieldPos(22), 22),
  _u12('김한울', _fieldPos(23), 23),
  _u12('김유찬', _fieldPos(24), 24),
  _u12('김주원', _fieldPos(25), 25),
  _u12('권윤우', _fieldPos(26), 26),
  _u12('이수현', _fieldPos(27), 27),
  _u12('김현규', _fieldPos(28), 28),
  _u12('장민찬', _fieldPos(29), 29),
  _u12('김한결', _fieldPos(30), 30),
  _u12('박지훈', _fieldPos(32), 32),
  _u12('정지안', _fieldPos(33), 33),
  _u12('박선우', _fieldPos(34), 34),
  _u12('신하늘', _fieldPos(35), 35),
  _u12('조예성', _fieldPos(36), 36),
  _u12('곽지안', _fieldPos(37), 37),
  _u12('조해민', _fieldPos(38), 38),
];
