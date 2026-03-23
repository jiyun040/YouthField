/// 경기 이벤트 유형
/// - goal: 득점
/// - yellowCard: 경고
/// - redCard: 퇴장
/// - substitution: 교체
enum MatchEventType { goal, yellowCard, redCard, substitution }

/// 경기 중 발생한 단일 이벤트 (득점·카드·교체 등)
class MatchEvent {
  /// 이벤트 발생 시각 (분)
  final int minute;

  /// 이벤트 유형
  final MatchEventType type;

  /// 이벤트의 주인공 선수 이름
  /// - 교체의 경우: OUT 되는 선수
  final String playerName;

  /// 홈팀 선수 여부 (false 이면 어웨이팀)
  final bool isHomeTeam;

  /// 교체 투입 선수 이름 (substitution 타입일 때만 사용)
  final String? subPlayerName;

  const MatchEvent({
    required this.minute,
    required this.type,
    required this.playerName,
    required this.isHomeTeam,
    this.subPlayerName,
  });
}

/// 경기에 출전한 선수 한 명의 기록
class PlayerRecord {
  /// 등번호
  final int number;

  /// 포지션 (예: FW, MF, DF, GK)
  final String position;

  /// 선수 이름
  final String name;

  /// 득점 수
  final int goals;

  /// 도움 수
  final int assists;

  /// 경고 누적 수
  final int yellowCards;

  /// 퇴장 여부
  final bool redCard;

  const PlayerRecord({
    required this.number,
    required this.position,
    required this.name,
    this.goals = 0,
    this.assists = 0,
    this.yellowCards = 0,
    this.redCard = false,
  });
}

/// 단일 경기 데이터
class ScheduleMatch {
  /// 홈팀 이름
  final String homeTeam;

  /// 어웨이팀 이름
  final String awayTeam;

  /// 경기 날짜 (예: "03.05(목)")
  final String date;

  /// 킥오프 시각 (예: "12:00")
  final String time;

  /// 경기장 이름
  final String venue;

  /// 최종 스코어 (예: "2:1"), 미정이면 null
  final String? score;

  /// 전반전 스코어, 미정이면 null
  final String? firstHalfScore;

  /// 후반전 스코어, 미정이면 null
  final String? secondHalfScore;

  /// 경기 이벤트 목록 (득점·카드·교체 순서 무관하게 저장, 표시 시 분 기준 정렬)
  final List<MatchEvent> events;

  /// 홈팀 출전 선수 목록
  final List<PlayerRecord> homePlayers;

  /// 어웨이팀 출전 선수 목록
  final List<PlayerRecord> awayPlayers;

  const ScheduleMatch({
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.time,
    required this.venue,
    this.score,
    this.firstHalfScore,
    this.secondHalfScore,
    this.events = const [],
    this.homePlayers = const [],
    this.awayPlayers = const [],
  });

  /// date 문자열에서 숫자만 추출해 앞 두 자리를 월(month)로 반환
  /// 예: "03.05(목)" → 3
  int get month =>
      int.parse(date.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 2));
}

/// 대회·리그 단위 일정 묶음
class ScheduleEvent {
  /// 대회·리그 이름
  final String title;

  /// 전체 일정 기간 (예: "2026.03.01 ~ 09.30")
  final String dateRange;

  /// 주 경기장 이름
  final String venue;

  /// 해당 대회에 속한 경기 목록
  final List<ScheduleMatch> matches;

  const ScheduleEvent({
    required this.title,
    required this.dateRange,
    required this.venue,
    required this.matches,
  });
}
