import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youthfield/features/skill/data/models/youtube_video.dart';
import 'package:youthfield/features/skill/data/services/youtube_service.dart';

final skillSearchQueryProvider = StateProvider<String>((ref) => '축구 스킬');

final skillVideosProvider = FutureProvider<YoutubeSearchResult>((ref) async {
  final query = ref.watch(skillSearchQueryProvider);
  return YoutubeService.instance.search(query: query, maxResults: 20);
});
