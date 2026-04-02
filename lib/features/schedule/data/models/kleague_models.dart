import 'package:youthfield/features/schedule/domain/entities/schedule.dart';

/// API 응답에서 받은 리그 정보
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

/// API 응답에서 받은 경기 일정 한 건
class KleagueMatch {
  final int leagueId;
  final String matchDate;   // "2026/03/07"
  final String matchTime;   // "15:00"
  final String matchWeekday; // "토"
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

  /// "2026/03/07" + "토" → "03.07(토)"
  String get formattedDate {
    if (matchDate.isEmpty) return '';
    final parts = matchDate.split('/');
    if (parts.length < 3) return matchDate;
    final mmdd = '${parts[1]}.${parts[2]}';
    return matchWeekday.isNotEmpty ? '$mmdd($matchWeekday)' : mmdd;
  }

  /// 스코어 문자열, 미정이면 null
  String? get score {
    if (homeScore == null || awayScore == null) return null;
    return '$homeScore:$awayScore';
  }

  /// 도메인 엔티티로 변환
  ScheduleMatch toEntity() {
    return ScheduleMatch(
      homeTeam: homeTeamName,
      awayTeam: awayTeamName,
      date: formattedDate,
      time: matchTime,
      venue: stadiumName,
      score: score,
    );
  }
}

/// API 응답 전체를 파싱한 결과
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

  /// 리그별로 경기를 묶어 ScheduleEvent 목록으로 변환
  List<ScheduleEvent> toScheduleEvents() {
    if (matches.isEmpty) return [];

    // leagueId → 경기 목록
    final Map<int, List<KleagueMatch>> grouped = {};
    for (final m in matches) {
      grouped.putIfAbsent(m.leagueId, () => []).add(m);
    }

    // leagueId → leagueName 매핑
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
        matches: ms.map((m) => m.toEntity()).toList(),
      );
    }).toList();
  }
}
