import 'package:dio/dio.dart';

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
      (key, value) => MapEntry(
        key.toString(),
        value?.toString() ?? '',
      ),
    )..removeWhere((_, value) => value.isEmpty);
  }
}
