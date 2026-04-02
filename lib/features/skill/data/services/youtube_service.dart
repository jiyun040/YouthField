import 'package:dio/dio.dart';
import 'package:youthfield/features/skill/data/models/youtube_video.dart';

class YoutubeService {
  YoutubeService._();

  static final YoutubeService instance = YoutubeService._();

  static const String _proxyBase = 'https://youthfield.vercel.app';
  static const String _defaultQuery = '축구 스킬';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _proxyBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  Future<YoutubeSearchResult> search({
    String query = _defaultQuery,
    int maxResults = 20,
    String? pageToken,
  }) async {
    final params = <String, dynamic>{'q': query, 'maxResults': maxResults};
    if (pageToken != null) params['pageToken'] = pageToken;

    final res = await _dio.get<Map<String, dynamic>>(
      '/api/youtube',
      queryParameters: params,
    );
    final data = res.data;
    if (data == null || data['items'] is! List) {
      throw const FormatException('Invalid YouTube response payload');
    }
    return YoutubeSearchResult.fromJson(data);
  }
}
