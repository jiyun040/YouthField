import 'package:dio/dio.dart';

/// K League 유스 일정 API 프록시 서비스
///
/// 직접 kleague.com을 호출하면 CORS 오류가 발생하므로
/// Vercel에 배포된 프록시 서버를 통해 데이터를 가져옵니다.
class KleagueService {
  KleagueService._();

  static final KleagueService instance = KleagueService._();

  /// 배포 후 Vercel 프록시 URL로 변경하세요.
  /// 예: 'https://youthfield-proxy.vercel.app'
  static const String _proxyBase =
      'https://youthfield.vercel.app';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _proxyBase,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  ));

  /// 연도별 리그 목록과 첫 번째 리그 경기 일정을 반환합니다.
  ///
  /// [year] 조회 연도 (예: '2026')
  /// [style] 리그 스타일 — 고등: 'LEAGUE2', 중등/초등: 확인 필요
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

  /// 특정 리그의 경기 일정을 반환합니다.
  ///
  /// [leagueId] 리그 고유 ID (예: 57659)
  /// [style] 리그 스타일
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
