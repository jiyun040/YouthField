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

const _loc = '경기도 화성시';
const _base = 'https://www.hwaseongfc.com';

PlayerInfo _u18(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '화성FC U-18',
  location: _loc,
  position: pos,
  ageGroup: 'U-18',
  number: num,
  birthdate: _bd(num, 2008),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/uploaded/board/youth/$imgCode.jpg',
);

PlayerInfo _u15(String name, String pos, int num, String imgCode) => PlayerInfo(
  name: name,
  school: '화성FC U-15',
  location: _loc,
  position: pos,
  ageGroup: 'U-15',
  number: num,
  birthdate: _bd(num, 2011),
  seasonStats: _zero,
  nationalStats: _zero,
  imageUrl: '$_base/uploaded/board/youth/$imgCode.jpg',
);

final List<PlayerInfo> hwaseongPlayers = [
  _u18('이은후', 'GK', 1, 'l_81c74fdda5306336a5bed2c8289227760'),
  _u18('이서진', 'GK', 13, 'l_cb86a8dee204d95ec65d79eebf56fa380'),
  _u18('한규원', 'GK', 16, 'l_335e7a15a288184241805f8125d86efb0'),
  _u18('이강민', 'DF', 2, 'l_294b01304f5691203b4154c146d59ab00'),
  _u18('이종화', 'DF', 3, 'l_23ca3fd37ee3c0fb3d105c137e49334d0'),
  _u18('최현민', 'DF', 4, 'l_6b83a533f52e4fa9e3113c47ef9c6ce30'),
  _u18('김재원', 'DF', 5, 'l_2b37627efd788d7eaa158f0e65b297ce0'),
  _u18('송시준', 'DF', 8, 'l_118daf6f92034068ef62dce81ae3f2960'),
  _u18('박지우', 'DF', 14, 'l_d279a618bc2c2d0ef7df89044670f1f50'),
  _u18('김주원', 'DF', 15, 'l_7b806822e689c3c06b9257b4d112cee00'),
  _u18('김민찬', 'DF', 12, 'l_2315ba7df2e877675410b2404f56f08d0'),
  _u18('이은우', 'DF', 2, 'l_294b01304f5691203b4154c146d59ab00'),
  _u18('김채율', 'DF', 22, 'l_ef8f21481398d9167cfffa170'),
  _u18('명시우', 'DF', 24, 'l_a06959b6822a19c36efd4adb803a2b980'),
  _u18('김승환', 'DF', 25, 'l_007fa14ad73e6ffbacff2d4603b2935f0'),
  _u18('최영준', 'DF', 29, 'l_0bca0018dd309805f213d2c00405f46b0'),
  _u18('공찬희', 'MF', 6, 'l_61cbf3a7c62e4543f15afc1f118091570'),
  _u18('지영호', 'MF', 10, 'l_93b4537c789bf567e6a1997b11bc2d1e0'),
  _u18('강민찬', 'MF', 17, 'l_e5668f80ccc93e4a6e8da92ab2c5de720'),
  _u18('이창원', 'MF', 20, 'l_76c91d095492257d739991826d9a08ba0'),
  _u18('신희성', 'MF', 21, 'l_d49dee0bb33f699d08d208c83a160cb10'),
  _u18('김민겸', 'MF', 23, 'l_86215ee3f704ccfe2bb7bff680b55b530'),
  _u18('이재찬', 'MF', 26, 'l_300e00e7ab032e27e6e1836c5a9099be0'),
  _u18('채민교', 'MF', 27, 'l_26c47650de1ac1956f0f24d2207ddc5f0'),
  _u18('이시후', 'MF', 28, 'l_bc7dabcb289382bbeaec5321d9bf799e0'),
  _u18('김진환', 'MF', 30, 'l_821c751905a1244e97a3e792976b21670'),
  _u18('김현서', 'MF', 32, 'l_d5be6c73b173a4fccf75c3b4c4caa3470'),
  _u18('엄지후', 'MF', 33, 'l_35b69314e278e8ca828ec413781c04440'),
  _u18('김도윤', 'MF', 47, 'l_0d8aca4c7ba66fc9d7d9dba2d5840cc50'),
  _u18('박준우', 'MF', 77, 'l_edffd8f9f942c2d7d6730ae471ade87c0'),
  _u18('황현준', 'FW', 7, 'l_e1a4be27781900615c5cefc2ea8ff8f30'),
  _u18('윤기현', 'FW', 9, 'l_a833316e19f1d090afe4fd27c8523efe0'),
  _u18('홍은준', 'FW', 11, 'l_97d56ad08d51d2344f2ba147e390bfc10'),
  _u18('유요한', 'FW', 18, 'l_2522b3d2026f2f9cd2fa8cb749e32edd0'),
  _u18('손건호', 'FW', 99, 'l_15835fdc8819e3dbcceb0b6064a4c3470'),

  _u15('이서원', 'GK', 21, 'l_1ab0908f8879ef74f99a7ccc5fcfd1840'),
  _u15('이태경', 'GK', 30, 'l_8b9ec402eb81573b85de0111015f5f5e0'),
  _u15('이건우', 'GK', 31, 'l_7570ce166baf23a7b51cf28b4f8b79370'),
  _u15('박준성', 'DF', 2, 'l_668a98d8a56036570531b57dab6219070'),
  _u15('류담희', 'DF', 3, 'l_ea9407a87428bfd23a5e5c13fb11f8790'),
  _u15('박재용', 'DF', 4, 'l_dd1223cbc729ce911d1549d297566eb80'),
  _u15('김민구', 'DF', 5, 'l_4aec8962f063308ab46ab47e537831860'),
  _u15('임우현', 'DF', 15, 'l_bd71fa19db2103faecd50b214c9174b90'),
  _u15('이영우', 'DF', 17, 'l_df4ab100e60ccfc64d2cc4a0ecfb44ad0'),
  _u15('한유준', 'DF', 20, 'l_60ce1872ed5c0ae4c590ddfbc742528a0'),
  _u15('정서찬', 'DF', 32, 'l_e4d9930cd2c390afcde34ec4ea260ee80'),
  _u15('김민재', 'DF', 33, 'l_0dbac59bf379a8cdb0f4a8bcef2d68d20'),
  _u15('정윤탁', 'DF', 35, 'l_97c51d9ff1ddcefa8135e252636102f50'),
  _u15('김지호', 'DF', 42, 'l_9fdec24edd5106073c67169358c9e6030'),
  _u15('문정우', 'DF', 43, 'l_8d4122961ddfad58975c9906bf6d4b810'),
  _u15('윤주원', 'DF', 44, 'l_227b956f7457f531ab5cfa6bfe9193990'),
  _u15('최윤재', 'DF', 45, 'l_b2d52b4e89dafb96fcc84eb762a327b10'),
  _u15('김중건', 'MF', 16, 'l_c73be98ba8a7c75821c1bf1c05228c790'),
  _u15('김민중', 'MF', 7, 'l_be76334f0495e7912b3ca1ff764f8c650'),
  _u15('우민혁', 'MF', 8, 'l_77c8cbf4ed66e582c7879fb205182c4b0'),
  _u15('김민찬', 'MF', 36, 'l_132c267d2d96bff8ee63551fe54c687d0'),
  _u15('장서원', 'MF', 37, 'l_32a60a0defc433020fb646c4b9f111d10'),
  _u15('조성호', 'MF', 38, 'l_75208fd0644c72d57640de97f93a38820'),
  _u15('신동은', 'MF', 40, 'l_691414cb9d0bc866d355fbd80d54cf000'),
  _u15('조성윤', 'MF', 46, 'l_57ef672dff3691d68f22ac0deb1e64e80'),
  _u15('권민찬', 'MF', 47, 'l_4f62a3e45e6e7677b1944af16af3c7060'),
  _u15('박준하', 'FW', 18, 'l_a787b32fa3c7c4737bcbeb1b9b7b6a270'),
  _u15('김태현', 'FW', 22, 'l_d3efb84ec33df3c365e6b40b333d9b1c0'),
  _u15('신동은', 'FW', 27, 'l_8d89b0d4d6d217eedaeceb403e90248f0'),
  _u15('강한빛', 'FW', 28, 'l_f6ed44f1687272697b994520bef432040'),
  _u15('김수호', 'FW', 29, 'l_8b364857bef2b7c7d7674ec865b841f30'),
  _u15('이현우', 'FW', 34, 'l_5466c8a301d29e6ecd218d5bfd33b33c0'),
  _u15('한리암', 'FW', 39, 'l_268f2ad9f84144b649992f4edbc9eec20'),
  _u15('김재환', 'FW', 48, 'l_a17ff05a7c85d2674ef40b15c2583e6c0'),
];
