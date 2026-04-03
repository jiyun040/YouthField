import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/schedule/data/models/kleague_models.dart';
import 'package:youthfield/features/schedule/data/models/schedule_feed.dart';
import 'package:youthfield/features/schedule/data/services/joinkfa_service.dart';
import 'package:youthfield/features/schedule/data/services/kleague_service.dart';

final scheduleYearProvider = StateProvider<String>(
  (ref) => DateTime.now().year.toString(),
);

final scheduleProvider = FutureProvider<ScheduleFeed>((ref) async {
  final year = ref.watch(scheduleYearProvider);
  final kleagueJson = await KleagueService.instance.fetchByYear(year: year);

  Map<String, String> emblemByTeam = const {};
  try {
    emblemByTeam = await JoinkfaService.instance.fetchTeamEmblems(year: year);
  } catch (_) {
    emblemByTeam = const {};
  }

  return ScheduleFeed(
    kleague: KleagueResponse.fromJson(kleagueJson),
    emblemByTeam: emblemByTeam,
  );
});
