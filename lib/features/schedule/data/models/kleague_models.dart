import 'package:youthfield/features/schedule/domain/entities/schedule.dart';

String _normalizeTeamName(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'[\s\-_]'), '');
}

String _stripAgeGroup(String value) {
  return value.replaceAll(RegExp(r'u\d{2}'), '');
}

const String _emblemProxyBase = 'https://youthfield.vercel.app/api/emblem';

String _e(String code) => '$_emblemProxyBase?code=$code';

const Map<String, String> _kleagueCdnEmblems = {
  '울산': 'K01',
  '울산hd': 'K01',
  '울산현대': 'K01',
  '수원': 'K02',
  '수원삼성': 'K02',
  '수원삼성블루윙즈': 'K02',
  '포항': 'K03',
  '포항스틸러스': 'K03',
  '제주': 'K04',
  '제주유나이티드': 'K04',
  '전북': 'K05',
  '전북현대': 'K05',
  '전북현대모터스': 'K05',
  '부산': 'K06',
  '부산아이파크': 'K06',
  '전남': 'K07',
  '전남드래곤즈': 'K07',
  '성남': 'K08',
  '성남fc': 'K08',
  '서울': 'K09',
  'fc서울': 'K09',
  '서울fc서울': 'K09',
  '대전': 'K10',
  '대전하나': 'K10',
  '대전하나시티즌': 'K10',
  '대구': 'K17',
  '대구fc': 'K17',
  '인천': 'K18',
  '인천유나이티드': 'K18',
  '경남': 'K20',
  '경남fc': 'K20',
  '강원': 'K21',
  '강원fc': 'K21',
  '광주': 'K22',
  '광주fc': 'K22',
  '부천': 'K26',
  '부천fc': 'K26',
  '부천fc1995': 'K26',
  '안양': 'K27',
  'fc안양': 'K27',
  '수원fc': 'K29',
  '이랜드': 'K31',
  '서울e': 'K31',
  '서울이랜드': 'K31',
  '서울이랜드fc': 'K31',
  '안산': 'K32',
  '안산그리너스': 'K32',
  '충남아산': 'K34',
  '충남아산fc': 'K34',
  '김천': 'K35',
  '김천상무': 'K35',
  '김포': 'K36',
  '김포fc': 'K36',
  '충북청주': 'K37',
  '충북청주fc': 'K37',
  '청주': 'K37',
  '청주fc': 'K37',
  '천안': 'K38',
  '천안시티': 'K38',
  '천안시티fc': 'K38',
  '화성': 'K39',
  '경기화성fc': 'K39',
  '화성fc': 'K39',
  '파주': 'K40',
  '파주fc': 'K40',
  '김해': 'K41',
  '김해fc': 'K41',
  '용인': 'K42',
  '용인fc': 'K42',
};

const Map<String, String> _displayNameByShortName = {
  '울산': '울산HD',
  '수원': '수원삼성블루윙즈',
  '포항': '포항스틸러스',
  '제주': '제주유나이티드',
  '전북': '전북현대모터스',
  '부산': '부산아이파크',
  '전남': '전남드래곤즈',
  '성남': '성남FC',
  '서울': 'FC서울',
  '대전': '대전하나시티즌',
  '대구': '대구FC',
  '인천': '인천유나이티드',
  '경남': '경남FC',
  '강원': '강원FC',
  '광주': '광주FC',
  '부천': '부천FC 1995',
  '안양': 'FC안양',
  '이랜드': '서울이랜드FC',
  '서울e': '서울이랜드FC',
  '안산': '안산그리너스',
  '충남아산': '충남아산FC',
  '김천': '김천상무',
  '김포': '김포FC',
  '충북청주': '충북청주FC',
  '천안': '천안시티FC',
  '화성': '화성FC',
  '파주': '파주FC',
  '김해': '김해FC',
  '용인': '용인FC',
  '청주': '충북청주FC',
};

const Map<String, List<String>> _shortNameExpansions = {
  '전북': ['전북현대모터스', '전북현대'],
  '전남': ['전남드래곤즈', '전남'],
  '수원': ['수원삼성블루윙즈', '수원삼성'],
  '대전': ['대전하나시티즌', '대전하나'],
  '대구': ['대구fc', '대구'],
  '안양': ['fc안양', '안양'],
  '부산': ['부산아이파크', '부산'],
  '인천': ['인천유나이티드', '인천'],
  '울산': ['울산hd', '울산현대', '울산'],
  '포항': ['포항스틸러스', '포항'],
  '광주': ['광주fc', '광주'],
  '성남': ['성남fc', '성남'],
  '강원': ['강원fc', '강원'],
  '제주': ['제주유나이티드', '제주'],
  '김천': ['김천상무', '김천'],
  '서울': ['fc서울', '서울fc서울'],
  '이랜드': ['서울이랜드fc', '서울이랜드'],
  '서울e': ['서울이랜드fc', '서울이랜드'],
  '화성': ['경기화성fc', '화성fc'],
  '청주': ['청주fc', '청주'],
  '충남아산': ['충남아산fc', '충남아산'],
  '충북청주': ['충북청주fc', '충북청주'],
  '김포': ['김포fc', '김포'],
  '안산': ['안산그리너스', '안산'],
  '경남': ['경남fc', '경남'],
  '전북현대': ['전북현대모터스'],
  '부천': ['부천fc', '부천fc1995'],
  '천안': ['천안시티fc', '천안시티'],
};

Set<String> _teamAliases(String normalizedTeam) {
  final aliases = <String>{normalizedTeam};
  final withoutAge = _stripAgeGroup(normalizedTeam);
  if (withoutAge.isNotEmpty) aliases.add(withoutAge);

  final expanded = _shortNameExpansions[withoutAge] ?? _shortNameExpansions[normalizedTeam];
  if (expanded != null) aliases.addAll(expanded);

  for (final entry in _shortNameExpansions.entries) {
    if (entry.value.any((v) => normalizedTeam.contains(v) || withoutAge.contains(v))) {
      aliases.add(entry.key);
      aliases.addAll(entry.value);
    }
  }

  if (withoutAge.isNotEmpty) {
    aliases.add('${withoutAge}u15');
    aliases.add('${withoutAge}u18');
  }

  return aliases;
}

String _resolveTeamLogoUrl(
  String teamName,
  Map<String, String>? emblemByTeam,
) {
  final normalizedTeam = _normalizeTeamName(teamName);
  if (normalizedTeam.isEmpty) return '';

  if (emblemByTeam != null && emblemByTeam.isNotEmpty) {
    for (final alias in _teamAliases(normalizedTeam)) {
      final exact = emblemByTeam[alias];
      if (exact != null && exact.isNotEmpty) return exact;
    }

    final normalizedWithoutAge = _stripAgeGroup(normalizedTeam);
    final candidates = emblemByTeam.entries.where((entry) {
      final key = entry.key;
      if (key.isEmpty || entry.value.isEmpty) return false;
      final aliasMatched = _teamAliases(normalizedTeam).contains(key);
      if (aliasMatched) return true;
      final keyWithoutAge = _stripAgeGroup(key);
      return normalizedWithoutAge.isNotEmpty &&
          keyWithoutAge.isNotEmpty &&
          (normalizedWithoutAge.contains(keyWithoutAge) ||
              keyWithoutAge.contains(normalizedWithoutAge));
    }).toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    if (candidates.isNotEmpty) return candidates.first.value;
  }

  for (final alias in _teamAliases(normalizedTeam)) {
    final code = _kleagueCdnEmblems[alias];
    if (code != null) return _e(code);
  }

  final normalizedWithoutAge = _stripAgeGroup(normalizedTeam);
  for (final entry in _kleagueCdnEmblems.entries) {
    final key = entry.key;
    if (normalizedWithoutAge.isNotEmpty &&
        (normalizedWithoutAge.contains(key) || key.contains(normalizedWithoutAge))) {
      return _e(entry.value);
    }
  }

  return '';
}

String _expandTeamName(String shortName) {
  final normalized = _normalizeTeamName(shortName);
  return _displayNameByShortName[normalized] ?? shortName;
}

class KleagueLeague {
  final int leagueId;
  final String leagueName;

  const KleagueLeague({required this.leagueId, required this.leagueName});

  factory KleagueLeague.fromJson(Map<String, dynamic> json) {
    return KleagueLeague(
      leagueId: json['leagueId'] as int,
      leagueName: (json['leagueName'] as String?) ?? '',
    );
  }
}

class KleagueMatch {
  final int leagueId;
  final String matchDate;
  final String matchTime;
  final String matchWeekday;
  final String homeTeamName;
  final String awayTeamName;
  final String? homeScore;
  final String? awayScore;
  final String stadiumName;

  const KleagueMatch({
    required this.leagueId,
    required this.matchDate,
    required this.matchTime,
    required this.matchWeekday,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeScore,
    this.awayScore,
    required this.stadiumName,
  });

  factory KleagueMatch.fromJson(Map<String, dynamic> json) {
    return KleagueMatch(
      leagueId: (json['leagueId'] as num?)?.toInt() ?? 0,
      matchDate: (json['matchDate'] as String?) ?? '',
      matchTime: (json['matchTime'] as String?) ?? '',
      matchWeekday: (json['matchWeekday'] as String?) ?? '',
      homeTeamName: (json['homeTeamName'] as String?) ?? '',
      awayTeamName: (json['awayTeamName'] as String?) ?? '',
      homeScore: json['homeTeamFinalScore'] as String?,
      awayScore: json['awayTeamFinalScore'] as String?,
      stadiumName: (json['stadiumName'] as String?) ?? '',
    );
  }

  String get formattedDate {
    if (matchDate.isEmpty) return '';
    final parts = matchDate.split('/');
    if (parts.length < 3) return matchDate;
    final mmdd = '${parts[1]}.${parts[2]}';
    return matchWeekday.isNotEmpty ? '$mmdd($matchWeekday)' : mmdd;
  }

  String? get score {
    if (homeScore == null || awayScore == null) return null;
    return '$homeScore:$awayScore';
  }

  ScheduleMatch toEntity({Map<String, String>? emblemByTeam}) {
    return ScheduleMatch(
      homeTeam: _expandTeamName(homeTeamName),
      awayTeam: _expandTeamName(awayTeamName),
      homeTeamLogoUrl: _resolveTeamLogoUrl(homeTeamName, emblemByTeam),
      awayTeamLogoUrl: _resolveTeamLogoUrl(awayTeamName, emblemByTeam),
      date: formattedDate,
      time: matchTime,
      venue: stadiumName,
      score: score,
    );
  }
}

class KleagueResponse {
  final List<KleagueLeague> leagues;
  final List<KleagueMatch> matches;

  const KleagueResponse({required this.leagues, required this.matches});

  factory KleagueResponse.fromJson(Map<String, dynamic> json) {
    final leagueList = (json['leagueNameList'] as List<dynamic>? ?? [])
        .where((e) => e['leagueName'] != null)
        .map((e) => KleagueLeague.fromJson(e as Map<String, dynamic>))
        .toList();

    final scheduleList = (json['scheduleList'] as List<dynamic>? ?? [])
        .map((e) => KleagueMatch.fromJson(e as Map<String, dynamic>))
        .where((m) => m.homeTeamName.isNotEmpty)
        .toList();

    return KleagueResponse(leagues: leagueList, matches: scheduleList);
  }

  List<ScheduleEvent> toScheduleEvents({Map<String, String>? emblemByTeam}) {
    if (matches.isEmpty) return [];

    final Map<int, List<KleagueMatch>> grouped = {};
    for (final m in matches) {
      grouped.putIfAbsent(m.leagueId, () => []).add(m);
    }

    final Map<int, String> nameMap = {
      for (final l in leagues) l.leagueId: l.leagueName,
    };

    return grouped.entries.map((entry) {
      final id = entry.key;
      final ms = entry.value..sort((a, b) => a.matchDate.compareTo(b.matchDate));
      final title = nameMap[id] ?? 'K리그 유스';
      final first = ms.first.formattedDate;
      final last = ms.last.formattedDate;
      return ScheduleEvent(
        title: title,
        dateRange: '$first ~ $last',
        venue: ms.first.stadiumName,
        matches: ms.map((m) => m.toEntity(emblemByTeam: emblemByTeam)).toList(),
      );
    }).toList();
  }
}
