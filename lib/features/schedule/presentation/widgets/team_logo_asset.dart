String _normalizeTeamName(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'[\s\-_]'), '');
}

String _stripAgeGroup(String value) {
  return value.replaceAll(RegExp(r'u\d{2}'), '');
}

const Map<String, String> _logoAssetByTeam = {
  'fc서울': 'assets/images/teams/fc_seoul.png',
  'fc서울u15': 'assets/images/teams/fc_seoul.png',
  'fc서울u18': 'assets/images/teams/fc_seoul.png',
  '서울fc서울': 'assets/images/teams/fc_seoul.png',
  '서울fc서울u15': 'assets/images/teams/fc_seoul.png',
  '부산아이파크': 'assets/images/teams/busan_ipark.png',
  '부산아이파크u15': 'assets/images/teams/busan_ipark.png',
  '부산아이파크u15낙동중': 'assets/images/teams/busan_ipark.png',
  '대전하나시티즌': 'assets/images/teams/daejeon_hana.png',
  '대전하나시티즌u15': 'assets/images/teams/daejeon_hana.png',
  '대전하나시티즌u18': 'assets/images/teams/daejeon_hana.png',
  '서울이랜드fc': 'assets/images/teams/seoul_eland.png',
  '서울이랜드fcu15': 'assets/images/teams/seoul_eland.png',
  '서울이랜드fcu18': 'assets/images/teams/seoul_eland.png',
  '전남드래곤즈': 'assets/images/teams/jeonnam_dragons.jpg',
  '전남드래곤즈u15': 'assets/images/teams/jeonnam_dragons.jpg',
  '전남드래곤즈u18': 'assets/images/teams/jeonnam_dragons.jpg',
  '수원삼성': 'assets/images/teams/suwon_samsung.png',
  '수원삼성블루윙즈': 'assets/images/teams/suwon_samsung.png',
  '수원삼성블루윙즈u15': 'assets/images/teams/suwon_samsung.png',
};

String? resolveTeamLogoAssetPath(String teamName) {
  final normalized = _normalizeTeamName(teamName);
  if (normalized.isEmpty) return null;

  final exact = _logoAssetByTeam[normalized];
  if (exact != null) return exact;

  final withoutAge = _stripAgeGroup(normalized);
  final byWithoutAge = _logoAssetByTeam[withoutAge];
  if (byWithoutAge != null) return byWithoutAge;

  final candidates = _logoAssetByTeam.entries.where((entry) {
    final key = entry.key;
    return normalized.contains(key) ||
        key.contains(normalized) ||
        withoutAge.contains(key) ||
        key.contains(withoutAge);
  }).toList()
    ..sort((a, b) => b.key.length.compareTo(a.key.length));

  return candidates.isNotEmpty ? candidates.first.value : null;
}
