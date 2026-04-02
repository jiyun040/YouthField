class YoutubeVideo {
  final String videoId;
  final String title;
  final String channelTitle;
  final String? thumbnailUrl;
  final String? publishedAt;

  const YoutubeVideo({
    required this.videoId,
    required this.title,
    required this.channelTitle,
    this.thumbnailUrl,
    this.publishedAt,
  });

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$videoId';

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    return YoutubeVideo(
      videoId: json['videoId'] as String? ?? '',
      title: _decodeTitle(json['title'] as String? ?? ''),
      channelTitle: json['channelTitle'] as String? ?? '',
      thumbnailUrl: json['thumbnail'] as String?,
      publishedAt: json['publishedAt'] as String?,
    );
  }

  /// YouTube API가 HTML 엔티티를 반환할 때 디코딩
  static String _decodeTitle(String raw) {
    return raw
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
  }
}

class YoutubeSearchResult {
  final List<YoutubeVideo> videos;
  final String? nextPageToken;

  const YoutubeSearchResult({required this.videos, this.nextPageToken});

  factory YoutubeSearchResult.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => YoutubeVideo.fromJson(e as Map<String, dynamic>))
        .where((v) => v.videoId.isNotEmpty)
        .toList();
    return YoutubeSearchResult(
      videos: items,
      nextPageToken: json['nextPageToken'] as String?,
    );
  }
}
