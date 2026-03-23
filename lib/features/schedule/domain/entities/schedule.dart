enum MatchEventType { goal, yellowCard, redCard, substitution }

class MatchEvent {
  final int minute;
  final MatchEventType type;
  final String playerName;
  final bool isHomeTeam;
  final String? subPlayerName;

  const MatchEvent({
    required this.minute,
    required this.type,
    required this.playerName,
    required this.isHomeTeam,
    this.subPlayerName,
  });
}

class PlayerRecord {
  final int number;
  final String position;
  final String name;
  final int goals;
  final int assists;
  final int yellowCards;
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

class ScheduleMatch {
  final String homeTeam;
  final String awayTeam;
  final String date;
  final String time;
  final String venue;
  final String? score;
  final String? firstHalfScore;
  final String? secondHalfScore;
  final List<MatchEvent> events;
  final List<PlayerRecord> homePlayers;
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

  int get month =>
      int.parse(date.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 2));
}

class ScheduleEvent {
  final String title;
  final String dateRange;
  final String venue;
  final List<ScheduleMatch> matches;

  const ScheduleEvent({
    required this.title,
    required this.dateRange,
    required this.venue,
    required this.matches,
  });
}
