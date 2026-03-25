import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import '../widgets/skill_card.dart';

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

const List<SkillData> skillMockData = [
  SkillData(
    title: '피지컬',
    subtitle: '경기 중에서 오래 뛸 수 있는 방법',
    steps: [
      SkillStep(
        title: '준비운동',
        description:
            '훈련 전 10분 이상 스트레칭으로 근육을 풀어주세요.\n관절 가동범위를 충분히 확보한 후 본 훈련을 시작하세요.',
      ),
      SkillStep(
        title: '유산소 훈련',
        description:
            '꾸준한 달리기로 심폐 지구력을 키우세요.\n인터벌 트레이닝을 통해 경기 강도에 맞는 체력을 쌓으세요.',
      ),
      SkillStep(
        title: '마무리 스트레칭',
        description:
            '훈련 후 쿨다운 스트레칭으로 피로를 풀어주세요.\n충분한 수분 섭취로 근육 회복을 도와주세요.',
      ),
    ],
    youtubeUrl: 'https://youtube.com',
  ),
  SkillData(
    title: '드리블',
    subtitle: '상대를 제치는 드리블 기술',
    steps: [
      SkillStep(
        title: '기본 터치',
        description: '발 안쪽으로 공을 부드럽게 컨트롤하세요.\n양발을 고르게 사용하는 습관을 들이세요.',
      ),
      SkillStep(
        title: '방향 전환',
        description:
            '빠른 방향 전환이 드리블의 핵심입니다.\n무게 중심을 낮추고 순간적으로 방향을 바꾸세요.',
      ),
      SkillStep(
        title: '1대1 돌파',
        description:
            '상대의 무게 중심을 읽고 빈 공간을 공략하세요.\n속도 변화로 수비수의 타이밍을 흔드세요.',
      ),
    ],
  ),
  SkillData(
    title: '슈팅',
    subtitle: '정확한 슈팅 자세 교정',
    steps: [
      SkillStep(
        title: '발 위치',
        description:
            '디딤발을 공 옆에 적절히 위치시켜 균형을 잡으세요.\n디딤발 방향이 슈팅 방향을 결정합니다.',
      ),
      SkillStep(
        title: '임팩트 포인트',
        description:
            '발등 중앙으로 공을 맞추는 것이 기본입니다.\n임팩트 순간 발목을 고정하고 몸무게를 실어주세요.',
      ),
    ],
    youtubeUrl: 'https://youtube.com',
  ),
  SkillData(
    title: '패스',
    subtitle: '팀원과의 연계 패스 훈련',
    steps: [
      SkillStep(
        title: '숏패스',
        description:
            '짧은 거리 패스부터 차근차근 연습하세요.\n발 안쪽 면으로 정확하게 전달하는 것이 우선입니다.',
      ),
      SkillStep(
        title: '시선 페이크',
        description:
            '시선으로 상대를 속인 후 반대 방향으로 패스하세요.\n눈과 몸의 방향을 분리하는 연습이 필요합니다.',
      ),
      SkillStep(
        title: '원터치 패스',
        description:
            '원터치 패스로 빠른 전개를 만드세요.\n공이 오기 전 미리 다음 패스 방향을 결정하세요.',
      ),
    ],
  ),
  SkillData(
    title: '헤딩',
    subtitle: '공중볼 처리와 헤딩 훈련',
    steps: [
      SkillStep(
        title: '점프 타이밍',
        description:
            '공의 궤적을 미리 읽고 최적의 타이밍에 도약하세요.\n점프 타이밍이 헤딩의 성패를 가릅니다.',
      ),
      SkillStep(
        title: '임팩트',
        description:
            '이마 중앙으로 공을 정확하게 받으세요.\n눈을 감지 말고 공을 끝까지 응시하세요.',
      ),
    ],
  ),
  SkillData(
    title: '수비',
    subtitle: '1대1 수비 기본기',
    steps: [
      SkillStep(
        title: '간격 유지',
        description:
            '상대와 적절한 간격을 유지하며 공간을 차단하세요.\n너무 가까이 붙으면 돌파당하기 쉽습니다.',
      ),
      SkillStep(
        title: '공 집중',
        description:
            '공보다 상대의 발에 집중하세요.\n상체 페이크에 속지 않으려면 하체를 보세요.',
      ),
      SkillStep(
        title: '태클 타이밍',
        description:
            '무리한 태클은 반칙으로 이어집니다.\n상대가 공을 컨트롤하는 순간을 노려 정확하게 태클하세요.',
      ),
    ],
    youtubeUrl: 'https://youtube.com',
  ),
];

class SkillPage extends StatefulWidget {
  const SkillPage({super.key});

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
  int? _selectedIndex;
  int _selectedStepIndex = 0;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: _buildContent())),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                icon: const Icon(Symbols.chevron_left,
                    color: YouthFieldColor.blue700, size: 32),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () {
                  if (_selectedIndex != null) {
                    setState(() {
                      _selectedIndex = null;
                      _selectedStepIndex = 0;
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
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
          onChanged: (val) => setState(() {
            _searchQuery = val;
            _selectedIndex = null;
          }),
          decoration: InputDecoration(
            hintText: '배우고 싶은 스킬을 검색하세요.',
            hintStyle: YouthFieldTextStyle.placeholder
                .copyWith(color: YouthFieldColor.black500),
            border: InputBorder.none,
            isDense: true,
            contentPadding:
                const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedIndex != null) {
      return _buildDetail(skillMockData[_selectedIndex!]);
    }

    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      final results = <MapEntry<int, SkillData>>[];
      for (var i = 0; i < skillMockData.length; i++) {
        final s = skillMockData[i];
        if (s.title.toLowerCase().contains(query) ||
            s.subtitle.toLowerCase().contains(query)) {
          results.add(MapEntry(i, s));
        }
      }
      return _buildSearchResults(results);
    }

    return _buildGrid();
  }

  Widget _buildGrid() {
    const double cardWidth = 260;
    const double cardHeight = cardWidth * 9 / 16;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: List.generate(skillMockData.length, (i) {
          final s = skillMockData[i];
          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: SkillCard(
              title: s.title,
              subtitle: s.subtitle,
              onTap: () => setState(() {
                _selectedIndex = i;
                _selectedStepIndex = 0;
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchResults(List<MapEntry<int, SkillData>> results) {
    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Text('검색 결과가 없습니다.')),
      );
    }
    return Column(
      children: results.map((entry) {
        final s = entry.value;
        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: YouthFieldColor.blue50,
          onTap: () => setState(() {
            _selectedIndex = entry.key;
            _selectedStepIndex = 0;
            _searchQuery = '';
            _searchController.clear();
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title,
                          style: YouthFieldTextStyle.body4
                              .copyWith(color: YouthFieldColor.black800)),
                      const SizedBox(height: 2),
                      Text(s.subtitle,
                          style: YouthFieldTextStyle.placeholder
                              .copyWith(color: YouthFieldColor.black500)),
                    ],
                  ),
                ),
                const Icon(Symbols.chevron_right,
                    color: YouthFieldColor.black500, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetail(SkillData s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.title,
                        style: YouthFieldTextStyle.body3.copyWith(
                            color: YouthFieldColor.black800,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(s.subtitle,
                        style: YouthFieldTextStyle.textCount
                            .copyWith(color: YouthFieldColor.black500)),
                  ],
                ),
              ),
              if (s.youtubeUrl != null)
                GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse(s.youtubeUrl!),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/youtube_logo.svg',
                    width: 32,
                    height: 32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(color: YouthFieldColor.black50),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(s.steps.length, (i) {
              final isSelected = i == _selectedStepIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedStepIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? YouthFieldColor.blue700
                        : YouthFieldColor.blue300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    s.steps[i].title,
                    style: YouthFieldTextStyle.smallButton
                        .copyWith(color: YouthFieldColor.white),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            s.steps[_selectedStepIndex].description,
            style: YouthFieldTextStyle.textCount
                .copyWith(color: YouthFieldColor.black800),
          ),
        ],
      ),
    );
  }
}
