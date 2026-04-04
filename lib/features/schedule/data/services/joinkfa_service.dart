import 'package:dio/dio.dart';
import 'package:youthfield/features/schedule/data/models/joinkfa_models.dart';

class JoinkfaService {
  JoinkfaService._();

  static final JoinkfaService instance = JoinkfaService._();

  static const String _proxyBase = 'https://youthfield.vercel.app';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _proxyBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<Map<String, String>> fetchTeamEmblems({
    String year = '2026',
    String style = 'LEAGUE2',
    List<String> grades = const ['2', '3'],
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/api/joinkfa',
      queryParameters: {
        'mode': 'teamEmblems',
        'year': year,
        'style': style,
        'grades': grades.join(','),
      },
    );

    final data = res.data ?? const <String, dynamic>{};
    final rawMap = data['emblemByTeam'];
    if (rawMap is! Map) return const <String, String>{};

    return rawMap.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    )..removeWhere((_, value) => value.isEmpty);
  }

  Future<List<JoinKfaCompetition>> fetchAllCompetitions({
    String year = '2026',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/api/joinkfa',
      queryParameters: {'mode': 'allCompetitions', 'year': year},
    );

    final data = res.data ?? const <String, dynamic>{};
    final raw = data['competitions'];
    if (raw is! List) return const [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(JoinKfaCompetition.fromJson)
        .where((c) => c.idx.isNotEmpty && c.title.isNotEmpty)
        .toList();
  }

  Future<List<JoinKfaMatch>> fetchCompetitionMatches({
    required String matchIdx,
    required String yearMonth,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/api/joinkfa',
      queryParameters: {
        'mode': 'singleList',
        'matchIdx': matchIdx,
        'yearMonth': yearMonth,
      },
    );

    final data = res.data ?? const <String, dynamic>{};
    final raw = data['singleList'];
    if (raw is! List) return const [];

    return raw
        .whereType<Map<String, dynamic>>()
        .map(JoinKfaMatch.fromJson)
        .toList();
  }
}
