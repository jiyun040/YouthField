class ScheduleMatch {
  final String homeTeam;
  final String awayTeam;
  final String date;
  final String time;
  final String venue;
  final String? score;

  const ScheduleMatch({
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.time,
    required this.venue,
    this.score,
  });

  int get month => int.parse(date.substring(0, 2));
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
