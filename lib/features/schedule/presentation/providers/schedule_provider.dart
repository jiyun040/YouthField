import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/schedule/data/models/kleague_models.dart';
import 'package:youthfield/features/schedule/data/services/kleague_service.dart';

final scheduleYearProvider = StateProvider<String>(
  (ref) => DateTime.now().year.toString(),
);

final scheduleProvider = FutureProvider<KleagueResponse>((ref) async {
  final year = ref.watch(scheduleYearProvider);
  final json = await KleagueService.instance.fetchByYear(year: year);
  return KleagueResponse.fromJson(json);
});
