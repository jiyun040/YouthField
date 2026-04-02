import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/presentation/pages/diary_page.dart';
import 'package:youthfield/features/skill/data/models/youtube_video.dart';
import 'package:youthfield/features/skill/presentation/providers/skill_provider.dart';
import '../widgets/skill_card.dart';

const int kSkillPageSize = 8;
const int kSkillWindowSize = 5;

// 기존 SkillData / skillMockData — 하위 호환성을 위해 유지
class SkillStep {
  final String title;
  final String description;
  const SkillStep({required this.title, required this.description});
}

class SkillData {
  final String title;
  final String subtitle;
  final List<SkillStep> steps;
  final String? youtubeUrl;
  const SkillData({
    required this.title,
    required this.subtitle,
    required this.steps,
    this.youtubeUrl,
  });
}

const List<SkillData> skillMockData = [];

// ─────────────────────────────────────────────

class SkillPage extends ConsumerStatefulWidget {
  const SkillPage({super.key});

  @override
  ConsumerState<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends ConsumerState<SkillPage> {
  final _searchController = TextEditingController();
  int _currentPage = 0;
  int _windowStart = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String val) {
    final query = val.trim().isEmpty ? '축구 스킬' : val.trim();
    ref.read(skillSearchQueryProvider.notifier).state = query;
    setState(() {
      _currentPage = 0;
      _windowStart = 0;
    });
  }

  void _onPageTap(int page) {
    setState(() {
      _currentPage = page;
      _windowStart = (page ~/ kSkillWindowSize) * kSkillWindowSize;
    });
  }

  void _onPrevWindow() => setState(() => _windowStart -= kSkillWindowSize);
  void _onNextWindow() => setState(() => _windowStart += kSkillWindowSize);

  @override
  Widget build(BuildContext context) {
    final videosAsync = ref.watch(skillVideosProvider);

    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(
              child: videosAsync.when(
                loading: () => const _LoadingView(),
                error: (err, _) => _ErrorView(
                  onRetry: () => ref.invalidate(skillVideosProvider),
                ),
                data: (result) => _buildGrid(result.videos),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        children: [
          Center(
            child: Text(
              '스킬',
              style: YouthFieldTextStyle.body3
                  .copyWith(color: YouthFieldColor.black800),
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Symbols.arrow_back_ios,
                    color: YouthFieldColor.blue700, size: 32),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _onSearch,
          textInputAction: TextInputAction.search,
          style: YouthFieldTextStyle.placeholder.copyWith(
            color: YouthFieldColor.black800,
          ),
          decoration: InputDecoration(
            hintText: '배우고 싶은 스킬을 검색하세요.',
            hintStyle: YouthFieldTextStyle.placeholder
                .copyWith(color: YouthFieldColor.black500),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: IconButton(
              icon: const Icon(Symbols.search,
                  color: YouthFieldColor.blue700, size: 20),
              onPressed: () => _onSearch(_searchController.text),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<YoutubeVideo> videos) {
    if (videos.isEmpty) {
      return const Center(
        child: Text('검색 결과가 없습니다.'),
      );
    }

    final totalPages = (videos.length / kSkillPageSize).ceil();
    final start = _currentPage * kSkillPageSize;
    final end = (start + kSkillPageSize).clamp(0, videos.length);
    final pageItems = videos.sublist(start, end);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 0, 24, totalPages > 1 ? 72 : 40),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: pageItems.map((v) {
              const double cardWidth = 260;
              const double cardHeight = cardWidth * 9 / 16;
              return SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: SkillCard(
                  title: v.title,
                  subtitle: v.channelTitle,
                  thumbnailUrl: v.thumbnailUrl,
                  onTap: () => _openYoutube(v.youtubeUrl),
                ),
              );
            }).toList(),
          ),
        ),
        if (totalPages > 1)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: DiaryPaginationBar(
              currentPage: _currentPage,
              totalPages: totalPages,
              windowStart: _windowStart,
              onPageTap: _onPageTap,
              onPrevWindow: _onPrevWindow,
              onNextWindow: _onNextWindow,
            ),
          ),
      ],
    );
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─── 상태 뷰 ────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: YouthFieldColor.blue700),
          SizedBox(height: 16),
          Text('영상을 불러오는 중...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Symbols.wifi_off, size: 48, color: YouthFieldColor.black300),
          const SizedBox(height: 12),
          Text(
            '영상을 불러오지 못했습니다.',
            style: YouthFieldTextStyle.body4
                .copyWith(color: YouthFieldColor.black500),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: YouthFieldColor.blue700,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '다시 시도',
                style: YouthFieldTextStyle.smallButton
                    .copyWith(color: YouthFieldColor.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
