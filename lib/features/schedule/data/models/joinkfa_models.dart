import 'package:youthfield/features/schedule/domain/entities/schedule.dart';

class JoinKfaCompetition {
  final String idx;
  final String title;
  final String style;
  final String gradeIdx;
  final String? dateFrom;
  final String? dateTo;
  final int? teamCount;
  final String? areaName;

  const JoinKfaCompetition({
    required this.idx,
    required this.title,
    required this.style,
    required this.gradeIdx,
    this.dateFrom,
    this.dateTo,
    this.teamCount,
    this.areaName,
  });

  factory JoinKfaCompetition.fromJson(Map<String, dynamic> json) {
    return JoinKfaCompetition(
      idx: json['IDX']?.toString() ?? '',
      title: (json['TITLE'] as String?) ?? (json['NAME'] as String?) ?? '',
      style: (json['_style'] as String?) ?? 'LEAGUE2',
      gradeIdx: (json['_mgcIdx'] as String?) ?? '',
      dateFrom: _formatDate(json['DATE_FROM'] as String?),
      dateTo: _formatDate(json['DATE_TO'] as String?),
      teamCount: int.tryParse(json['TEAMCNT']?.toString() ?? ''),
      areaName: json['AREANAME'] as String?,
    );
  }

  static String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.length >= 8) {
      return '${raw.substring(0, 4)}.${raw.substring(4, 6)}.${raw.substring(6, 8)}';
    }
    return raw;
  }

  bool get isLeague => style == 'LEAGUE2';

  String get dateRange {
    if (dateFrom != null && dateTo != null) return '$dateFrom ~ $dateTo';
    if (dateFrom != null) return '$dateFrom ~';
    return '-';
  }

  ScheduleEvent toScheduleEvent() {
    return ScheduleEvent(
      title: title,
      dateRange: dateRange,
      venue: areaName ?? '-',
      matches: const [],
    );
  }
}

class JoinKfaMatch {
  final String matchDate;
  final String homeTeamName;
  final String awayTeamName;
  final String? homeTeamEmblemUrl;
  final String? awayTeamEmblemUrl;
  final String? homeScore;
  final String? awayScore;
  final String? stadiumName;
  final String? matchTime;

  const JoinKfaMatch({
    required this.matchDate,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamEmblemUrl,
    this.awayTeamEmblemUrl,
    this.homeScore,
    this.awayScore,
    this.stadiumName,
    this.matchTime,
  });

  factory JoinKfaMatch.fromJson(Map<String, dynamic> json) {
    return JoinKfaMatch(
      matchDate: _formatDate(json['MATCH_DATE']?.toString() ?? json['G_DATE']?.toString() ?? ''),
      homeTeamName: json['TEAM_HOME_NAME']?.toString() ?? json['HOME_TEAM']?.toString() ?? '',
      awayTeamName: json['TEAM_AWAY_NAME']?.toString() ?? json['AWAY_TEAM']?.toString() ?? '',
      homeTeamEmblemUrl: json['TEAM_HOME_EMBLEM_URL'] as String?,
      awayTeamEmblemUrl: json['TEAM_AWAY_EMBLEM_URL'] as String?,
      homeScore: json['HOME_SCORE']?.toString(),
      awayScore: json['AWAY_SCORE']?.toString(),
      stadiumName: json['PLACE_NAME']?.toString() ?? json['STADIUM']?.toString(),
      matchTime: json['START_TIME']?.toString() ?? json['MATCH_TIME']?.toString(),
    );
  }

  static String _formatDate(String raw) {
    if (raw.length >= 8) {
      final mm = raw.substring(4, 6);
      final dd = raw.substring(6, 8);
      return '$mm.$dd';
    }
    return raw;
  }

  String? get score {
    if (homeScore == null || awayScore == null) return null;
    return '$homeScore:$awayScore';
  }

  ScheduleMatch toEntity() {
    return ScheduleMatch(
      homeTeam: homeTeamName,
      awayTeam: awayTeamName,
      homeTeamLogoUrl: homeTeamEmblemUrl,
      awayTeamLogoUrl: awayTeamEmblemUrl,
      date: matchDate,
      time: matchTime ?? '',
      venue: stadiumName ?? '',
      score: score,
    );
  }
}
