import 'package:youthfield/features/player/domain/entities/player_info.dart';

import 'ulsan_hd_data.dart';
import 'fc_anyang_data.dart';
import 'incheon_utd_data.dart';
import 'fc_seoul_data.dart';
import 'gimcheon_data.dart';
import 'gyeongnam_data.dart';
import 'hwaseong_data.dart';
import 'chungbuk_data.dart';
import 'chungnam_asan_data.dart';
import 'ansan_greeners_data.dart';
import 'daejeon_data.dart';
import 'suwon_samsung_data.dart';
import 'seoul_eland_data.dart';
import 'gimpo_data.dart';
import 'jeonnam_data.dart';
import 'busan_ipark_data.dart';

final List<PlayerInfo> allClubPlayers = [
  ...ulsanHdPlayers,
  ...fcSeoulPlayers,
  ...daejeonPlayers,
  ...incheonUtdPlayers,
  ...gimcheonPlayers,
  ...fcAnyangPlayers,
  ...gyeongnamPlayers,
  ...hwaseongPlayers,
  ...chungbukPlayers,
  ...chungnamAsanPlayers,
  ...ansanGreenersPlayers,
  ...suwonSamsungPlayers,
  ...seoulElandPlayers,
  ...gimpoPlayers,
  ...jeonnamPlayers,
  ...busanIparkPlayers,
];

final Map<String, List<PlayerInfo>> playersByClub = {
  '울산HD FC': ulsanHdPlayers,
  'FC서울': fcSeoulPlayers,
  '대전하나시티즌': daejeonPlayers,
  '인천유나이티드': incheonUtdPlayers,
  '김천상무FC': gimcheonPlayers,
  'FC안양': fcAnyangPlayers,
  '경남FC': gyeongnamPlayers,
  '화성FC': hwaseongPlayers,
  '충북청주FC': chungbukPlayers,
  '충남아산': chungnamAsanPlayers,
  '안산그리너스': ansanGreenersPlayers,
  '수원삼성': suwonSamsungPlayers,
  '서울이랜드FC': seoulElandPlayers,
  '김포FC': gimpoPlayers,
  '전남드래곤즈': jeonnamPlayers,
  '부산아이파크': busanIparkPlayers,
};

List<PlayerInfo> playersByAgeGroup(String ageGroup) =>
    allClubPlayers.where((p) => p.ageGroup == ageGroup).toList();

List<PlayerInfo> get allU18Players => playersByAgeGroup('U-18');

List<PlayerInfo> get allU15Players => playersByAgeGroup('U-15');

List<PlayerInfo> get allU12Players => playersByAgeGroup('U-12');
