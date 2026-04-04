import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/schedule/data/models/joinkfa_models.dart';
import 'package:youthfield/features/schedule/data/models/kleague_models.dart';
import 'package:youthfield/features/schedule/data/models/schedule_feed.dart';
import 'package:youthfield/features/schedule/data/services/joinkfa_service.dart';
import 'package:youthfield/features/schedule/data/services/kleague_service.dart';

final scheduleYearProvider = StateProvider<String>(
  (ref) => DateTime.now().year.toString(),
);

final scheduleProvider = FutureProvider<ScheduleFeed>((ref) async {
  final year = ref.watch(scheduleYearProvider);

  final results = await Future.wait([
    KleagueService.instance.fetchByYear(year: year),
    JoinkfaService.instance.fetchAllCompetitions(year: year).catchError((_) => <JoinKfaCompetition>[]),
    JoinkfaService.instance.fetchTeamEmblems(year: year).catchError((_) => <String, String>{}),
  ]);

  return ScheduleFeed(
    kleague: KleagueResponse.fromJson(results[0] as Map<String, dynamic>),
    joinkfaCompetitions: results[1] as List<JoinKfaCompetition>,
    emblemByTeam: results[2] as Map<String, String>,
  );
});

final competitionMatchesProvider = FutureProvider.family<List<JoinKfaMatch>, (String, String)>(
  (ref, args) async {
    final (matchIdx, yearMonth) = args;
    return JoinkfaService.instance.fetchCompetitionMatches(
      matchIdx: matchIdx,
      yearMonth: yearMonth,
    );
  },
);
