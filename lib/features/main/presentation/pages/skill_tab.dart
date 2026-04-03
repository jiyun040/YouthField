import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/core/services/history_service.dart';
import 'package:youthfield/features/mypage/domain/entities/watched_skill.dart';
import 'package:youthfield/features/diary/presentation/pages/diary_page.dart';
import 'package:youthfield/features/skill/data/models/youtube_video.dart';
import 'package:youthfield/features/skill/presentation/providers/skill_provider.dart';
import 'package:youthfield/features/skill/presentation/widgets/skill_card.dart';

const int kSkillPageSize = 12;
const int kSkillWindowSize = 5;

class SkillTab extends ConsumerStatefulWidget {
  final ValueChanged<bool>? onSkillSelected;

  const SkillTab({super.key, this.onSkillSelected});

  @override
  ConsumerState<SkillTab> createState() => SkillTabState();
}

class SkillTabState extends ConsumerState<SkillTab> {
  final _searchController = TextEditingController();
  int _currentPage = 0;
  int _windowStart = 0;

  bool handleBack() => false;

  bool get hasSelection => false;

  void _onPageTap(int page) {
    setState(() {
      _currentPage = page;
      _windowStart = (page ~/ kSkillWindowSize) * kSkillWindowSize;
    });
  }

  void _onPrevWindow() => setState(() => _windowStart -= kSkillWindowSize);

  void _onNextWindow() => setState(() => _windowStart += kSkillWindowSize);

  void _onSearch(String val) {
    final query = val.trim().isEmpty ? '축구 스킬' : val.trim();
    ref.read(skillSearchQueryProvider.notifier).state = query;
    setState(() {
      _currentPage = 0;
      _windowStart = 0;
    });
  }

  Future<void> _openYoutube(YoutubeVideo video) async {
    await HistoryService.addWatchedSkill(
      WatchedSkill(
        id: video.videoId.isNotEmpty ? video.videoId : video.title,
        title: video.title,
        subtitle: video.channelTitle,
        thumbnailUrl: video.thumbnailUrl,
      ),
    );
    final uri = Uri.parse(video.youtubeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(skillVideosProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Container(
            decoration: BoxDecoration(
              color: YouthFieldColor.blue50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '배우고 싶은 스킬을 검색하세요.',
                hintStyle: YouthFieldTextStyle.placeholder.copyWith(
                  color: YouthFieldColor.black500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Symbols.search,
                    color: YouthFieldColor.blue700,
                    size: 20,
                  ),
                  onPressed: () => _onSearch(_searchController.text),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        videosAsync.when(
          loading: () => Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 12.0;
                final cols = (constraints.maxWidth / 240).floor().clamp(2, 4);
                final cardWidth =
                    (constraints.maxWidth - spacing * (cols - 1)) / cols;
                final cardHeight = cardWidth * 9 / 16;
                return Shimmer.fromColors(
                  baseColor: YouthFieldColor.background,
                  highlightColor: YouthFieldColor.white,
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(
                      cols * 3,
                      (_) => Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: YouthFieldColor.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          error: (_, __) => SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Symbols.wifi_off,
                    size: 40,
                    color: YouthFieldColor.black300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '영상을 불러오지 못했습니다.',
                    style: YouthFieldTextStyle.body4.copyWith(
                      color: YouthFieldColor.black500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => ref.invalidate(skillVideosProvider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: YouthFieldColor.blue700,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '다시 시도',
                        style: YouthFieldTextStyle.smallButton.copyWith(
                          color: YouthFieldColor.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          data: (result) => _buildGrid(result.videos),
        ),
      ],
    );
  }

  Widget _buildGrid(List<YoutubeVideo> videos) {
    if (videos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Text('검색 결과가 없습니다.')),
      );
    }

    final totalPages = (videos.length / kSkillPageSize).ceil();
    final safePage = _currentPage.clamp(0, totalPages - 1).toInt();
    final safeWindowStart = (safePage ~/ kSkillWindowSize) * kSkillWindowSize;
    final start = safePage * kSkillPageSize;
    final end = (start + kSkillPageSize).clamp(0, videos.length).toInt();
    final pageItems = videos.sublist(start, end);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 12.0;
              final cols = (constraints.maxWidth / 240).floor().clamp(2, 4);
              final cardWidth =
                  (constraints.maxWidth - spacing * (cols - 1)) / cols;
              final cardHeight = cardWidth * 9 / 16;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: pageItems.map((v) {
                  return SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: SkillCard(
                      title: v.title,
                      subtitle: v.channelTitle,
                      thumbnailUrl: v.thumbnailUrl,
                      onTap: () => _openYoutube(v),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        if (totalPages > 1)
          DiaryPaginationBar(
            currentPage: safePage,
            totalPages: totalPages,
            windowStart: safeWindowStart,
            onPageTap: _onPageTap,
            onPrevWindow: _onPrevWindow,
            onNextWindow: _onNextWindow,
          ),
        const SizedBox(height: 40),
      ],
    );
  }
}
