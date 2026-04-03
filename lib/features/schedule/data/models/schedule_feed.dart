import 'package:youthfield/features/schedule/data/models/kleague_models.dart';
import 'package:youthfield/features/schedule/domain/entities/schedule.dart';

class ScheduleFeed {
  final KleagueResponse kleague;
  final Map<String, String> emblemByTeam;

  const ScheduleFeed({
    required this.kleague,
    this.emblemByTeam = const {},
  });

  List<ScheduleEvent> toScheduleEvents() {
    return kleague.toScheduleEvents(emblemByTeam: emblemByTeam);
  }
}
