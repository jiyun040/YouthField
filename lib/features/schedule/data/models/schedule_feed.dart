import 'package:youthfield/features/schedule/data/models/joinkfa_models.dart';
import 'package:youthfield/features/schedule/data/models/kleague_models.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';

class ScheduleFeed {
  final KleagueResponse kleague;
  final Map<String, String> emblemByTeam;
  final List<JoinKfaCompetition> joinkfaCompetitions;

  const ScheduleFeed({
    required this.kleague,
    this.emblemByTeam = const {},
    this.joinkfaCompetitions = const [],
  });

  List<ScheduleEvent> toScheduleEvents() {
    return kleague.toScheduleEvents(emblemByTeam: emblemByTeam);
  }

  List<JoinKfaCompetition> get joinkfaLeagues =>
      joinkfaCompetitions.where((c) => c.isLeague).toList();

  List<JoinKfaCompetition> get joinkfaTournaments =>
      joinkfaCompetitions.where((c) => !c.isLeague).toList();
}
