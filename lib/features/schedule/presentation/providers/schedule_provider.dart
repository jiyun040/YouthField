import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/schedule/data/models/kleague_models.dart';
import 'package:youthfield/features/schedule/data/services/kleague_service.dart';

/// 현재 선택된 연도
final scheduleYearProvider = StateProvider<String>((ref) => '2026');

/// 전체 리그 목록 + 첫 번째 리그 경기 일정
final scheduleProvider = FutureProvider<KleagueResponse>((ref) async {
  final year = ref.watch(scheduleYearProvider);
  final json = await KleagueService.instance.fetchByYear(year: year);
  return KleagueResponse.fromJson(json);
});
