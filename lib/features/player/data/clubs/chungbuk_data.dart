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

const _loc = '충청북도 청주시 서원구';
const _base = 'https://www.chfc.kr';

PlayerInfo _u18(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '충북청주FC U-18',
  location: _loc,
  position: pos,
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2008),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/upload/syplayer/$imgCode',
);

PlayerInfo _u15(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '충북청주FC U-15',
  location: _loc,
  position: pos,
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2011),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/upload/syplayer/$imgCode',
);

final List<PlayerInfo> chungbukPlayers = [
  _u18('공태윤', 'GK', 1, 'MU8KFn.png'),
  _u18('심은우', 'GK', 31, '4X06ar.png'),
  _u18('김희승', 'GK', 99, 'rZzbXd.png'),
  _u18('민경서', 'DF', 2, '60rJep.png'),
  _u18('서태지', 'DF', 4, 'jUWKf3.png'),
  _u18('이은교', 'DF', 20, 'eM6dpq.png'),
  _u18('연현수', 'DF', 24, 'ZAceO2.png'),
  _u18('임준모', 'DF', 30, 'TgW9Qp.png'),
  _u18('이시우', 'DF', 33, 'zslI3o.png'),
  _u18('최지후', 'DF', 55, 'Qr8fuq.png'),
  _u18('석윤환', 'DF', 57, 'SzmkP5.png'),
  _u18('허예범', 'DF', 66, 'LOFAp5.png'),
  _u18('박준형', 'DF', 88, 'SzmkP5.png'),
  _u18('장지웅', 'MF', 5, 'iQfd2n.png'),
  _u18('윤원준', 'MF', 6, 'CF3nlr.png'),
  _u18('이호제', 'MF', 7, 'feeLr4.png'),
  _u18('허태웅', 'MF', 8, 'GMhFCn.png'),
  _u18('정권', 'MF', 10, 'oGflqq.png'),
  _u18('염지황', 'MF', 15, 'URs4xi.png'),
  _u18('남유찬', 'MF', 17, 'v6xGIg.png'),
  _u18('천주호', 'MF', 29, 'Hh660q.png'),
  _u18('이스칸', 'MF', 45, 'pXKe6p.png'),
  _u18('김도윤', 'MF', 77, 'lq2yoe.png'),
  _u18('김다현', 'FW', 9, 'Njv6Qo.png'),
  _u18('채영찬', 'FW', 11, 'LIe9i2.png'),
  _u18('유현수', 'FW', 19, 'Dir1Po.png'),
  _u18('이지우', 'FW', 27, 'MDBUr6.png'),
  _u18('정윤찬', 'FW', 43, 'VgvCp4.png'),
  _u18('이준상', 'FW', 47, 'nBhSpq.png'),
  _u18('박율기', 'FW', 71, 'epJoRo.png'),
  _u18('하정우', 'FW', 97, 'Fhw1nc.png'),

  _u15('송영찬', 'GK', 1, '9NubSg.jpg'),
  _u15('윤지훈', 'GK', 21, 'N2kRmk.jpg'),
  _u15('정재범', 'GK', 31, 'LZwbzl.jpg'),
  _u15('홍시율', 'GK', 40, '8Sm8Ld.jpg'),
  _u15('박성재', 'GK', 41, 'Aehwta.jpg'),
  _u15('알렉산더', 'GK', 51, 'Jlc2nh.jpg'),
  _u15('최원호', 'DF', 2, 'QtbTdd.jpg'),
  _u15('김예찬', 'DF', 4, 'NeCs7f.jpg'),
  _u15('정우성', 'DF', 5, 'V0m7ve.jpg'),
  _u15('유영호', 'DF', 6, 'OvTAph.jpg'),
  _u15('안휘찬', 'DF', 15, '6Z9eLh.jpg'),
  _u15('복경민', 'DF', 20, 'Yyra2d.jpg'),
  _u15('서민준', 'DF', 24, '71vaeb.jpg'),
  _u15('류한렬', 'DF', 25, '4cpuZb.jpg'),
  _u15('황지섭', 'DF', 26, 'Pv0xyd.jpg'),
  _u15('황찬빈', 'DF', 33, 'DRStwd.jpg'),
  _u15('김제곤', 'DF', 80, 'FlV1ud.jpg'),
  _u15('박준영', 'MF', 3, 'WeOKWb.jpg'),
  _u15('유성민', 'MF', 7, 'LoiUpe.jpg'),
  _u15('오선욱', 'MF', 8, '9JEQEj.jpg'),
  _u15('염세준', 'MF', 13, 'yhjgOk.jpg'),
  _u15('백서준', 'MF', 16, '06NDTb.jpg'),
  _u15('이태우', 'MF', 18, 'hTfILb.jpg'),
  _u15('이지석', 'MF', 19, 'cC8vCd.jpg'),
  _u15('박진서', 'MF', 22, 'GPsloh.jpg'),
  _u15('백도하', 'MF', 23, 'JZ8Afi.jpg'),
  _u15('박경태', 'MF', 28, 'Adqygk.jpg'),
  _u15('황성준', 'MF', 30, '74BP0d.jpg'),
  _u15('오선제', 'MF', 55, 'PW03bi.jpg'),
  _u15('신민혁', 'MF', 66, 'FZw83i.jpg'),
  _u15('김지용', 'FW', 9, 'WNKLIj.jpg'),
  _u15('기현호', 'FW', 10, 'OUPtCh.jpg'),
  _u15('권우주', 'FW', 11, 'uCZmde.jpg'),
  _u15('이승규', 'FW', 14, 'zgIgrd.jpg'),
  _u15('임지용', 'FW', 17, 'T8PZFf.jpg'),
  _u15('신지성', 'FW', 27, '8pFMGi.jpg'),
  _u15('조강현', 'FW', 29, 'Y5Yj4c.jpg'),
  _u15('한민규', 'FW', 32, 'INV34h.jpg'),
  _u15('김민석', 'FW', 34, '2MidZg.jpg'),
  _u15('엄도건', 'FW', 35, 'l5xfPi.jpg'),
  _u15('윤유승', 'FW', 37, 'HLluVj.jpg'),
  _u15('이용우', 'FW', 39, 'W54uie.jpg'),
  _u15('피재윤', 'FW', 47, 'ROVS4d.jpg'),
  _u15('장준혁', 'FW', 77, 'ROVS4d.jpg'),
  _u15('최성민', 'FW', 99, 'ENj93d.jpg'),
];
