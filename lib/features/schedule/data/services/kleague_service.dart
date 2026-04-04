import 'package:dio/dio.dart';

class KleagueService {
  KleagueService._();

  static final KleagueService instance = KleagueService._();

  static const String _proxyBase =
      'https://youthfield.vercel.app';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _proxyBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  ));

  Future<Map<String, dynamic>> fetchByYear({
    String year = '2026',
    String style = 'LEAGUE2',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/api/schedule',
      queryParameters: {'year': year, 'style': style},
    );
    return res.data ?? {};
  }

  Future<Map<String, dynamic>> fetchByLeague({
    required int leagueId,
    String style = 'LEAGUE2',
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/api/schedule',
      queryParameters: {'leagueId': leagueId, 'style': style},
    );
    return res.data ?? {};
  }
}
