import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/core/widgets/yf_app_bar.dart';
import 'package:youthfield/core/widgets/yf_menu_bar.dart';
import 'package:youthfield/features/auth/presentation/pages/login_page.dart';
import 'package:youthfield/features/skill/presentation/pages/skill_page.dart';
import 'package:youthfield/features/skill/presentation/widgets/skill_card.dart';
import '../widgets/player_card.dart';
import '../widgets/schedule_item.dart';

const _mockPlayers = [
  (
    name: '박지훈',
    school: '부산체고',
    location: '부산광역시 해운대구',
    position: 'GK',
    age: 'U-15',
    number: 1,
  ),
  (
    name: '이서준',
    school: '오산고',
    location: '경기도 오산시 원동',
    position: 'DF',
    age: 'U-17',
    number: 4,
  ),
  (
    name: '한승민',
    school: '수원매탄고',
    location: '경기도 수원시 영통구',
    position: 'DF',
    age: 'U-15',
    number: 5,
  ),
  (
    name: '신재민',
    school: '대구체고',
    location: '대구광역시 달서구',
    position: 'DF',
    age: 'U-16',
    number: 6,
  ),
  (
    name: '오준혁',
    school: '인천대건고',
    location: '인천광역시 미추홀구',
    position: 'DF',
    age: 'U-18',
    number: 3,
  ),
  (
    name: '김민준',
    school: '경복고',
    location: '서울특별시 종로구 사직동',
    position: 'MF',
    age: 'U-15',
    number: 7,
  ),
  (
    name: '정도윤',
    school: '포항제철고',
    location: '경상북도 포항시',
    position: 'MF',
    age: 'U-17',
    number: 10,
  ),
  (
    name: '강태양',
    school: '울산중앙고',
    location: '울산광역시 중구',
    position: 'MF',
    age: 'U-17',
    number: 8,
  ),
  (
    name: '백가온',
    school: '보인고',
    location: '서울특별시 송파구 오금동',
    position: 'FW',
    age: 'U-15',
    number: 18,
  ),
  (
    name: '최현우',
    school: '광양제철고',
    location: '전라남도 광양시',
    position: 'FW',
    age: 'U-18',
    number: 9,
  ),
  (
    name: '윤재원',
    school: '전주고',
    location: '전라북도 전주시 완산구',
    position: 'FW',
    age: 'U-18',
    number: 11,
  ),
];

const _mockSchedules = [
  (
    title: '2026년도 부산 초,중학생체육대회 (구 소년체전 선발전)',
    date: '2026.03.05 ~ 03.13',
    venue: '기장월드컵빌리지 인조B',
  ),
  (
    title: '2026 전국 U-15 클럽챔피언십',
    date: '2026.04.01 ~ 04.10',
    venue: '서울 월드컵경기장 보조구장',
  ),
  (
    title: '2026 경기도 유소년 축구 리그 1라운드',
    date: '2026.04.15 ~ 04.20',
    venue: '수원종합운동장 B구장',
  ),
  (
    title: '2026 전국소년체육대회 예선전',
    date: '2026.05.02 ~ 05.08',
    venue: '대전월드컵경기장 인조잔디',
  ),
  (
    title: '2026 AFC U-17 아시안컵 국내 선발전',
    date: '2026.05.20 ~ 05.25',
    venue: '파주 국가대표 트레이닝센터',
  ),
];

const _tabs = ['선수 정보', '스킬', '경기 / 연습 일지', '경기 일정'];

// 컴포넌트 내 barHeight 상수 기반으로 계산
const double _baseHeaderHeight = YFAppBar.barHeight + YFMenuBar.barHeight;
const double _skillSubHeaderHeight = 72.0;
const double _skillHeaderHeight = _baseHeaderHeight + _skillSubHeaderHeight;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedTab = 0;
  bool _isLoggedIn = false;

  int? _selectedSkillIndex;
  int _selectedStepIndex = 0;
  String _skillSearchQuery = '';
  final _skillSearchController = TextEditingController();

  @override
  void dispose() {
    _skillSearchController.dispose();
    super.dispose();
  }

  double get _headerHeight =>
      _selectedTab == 1 ? _skillHeaderHeight : _baseHeaderHeight;

  Future<void> _openLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    if (result == true && mounted) setState(() => _isLoggedIn = true);
  }

  void _logout() => setState(() => _isLoggedIn = false);

  void _onTabSelected(int i) {
    setState(() {
      _selectedTab = i;
      if (i != 1) {
        _selectedSkillIndex = null;
        _selectedStepIndex = 0;
        _skillSearchQuery = '';
        _skillSearchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YouthFieldColor.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: _headerHeight),
                  _buildBody(),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                YFAppBar(
                  isLoggedIn: _isLoggedIn,
                  onLogin: _openLogin,
                  onLogout: _logout,
                  onLogoTap: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    setState(() {
                      _selectedTab = 0;
                      _selectedSkillIndex = null;
                      _selectedStepIndex = 0;
                      _skillSearchQuery = '';
                      _skillSearchController.clear();
                    });
                  },
                ),
                YFMenuBar(
                  tabs: _tabs,
                  selectedIndex: _selectedTab,
                  onTabSelected: _onTabSelected,
                ),
                if (_selectedTab == 1) _buildSkillSubHeader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildSkillContent();
      case 2:
        return _buildPlaceholder('경기 / 연습 일지');
      case 3:
        return _buildPlaceholder('경기 일정');
      default:
        return const SizedBox.shrink();
    }
  }

  DateTime _parseStartDate(String dateRange) {
    final parts = dateRange.split(' ~ ').first.trim().split('.');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  Widget _buildSkillSubHeader() {
    return Container(
      height: 72,
      color: YouthFieldColor.background,
      child: Stack(
        children: [
          Center(
            child: Text(
              '스킬',
              style: YouthFieldTextStyle.body3.copyWith(
                color: YouthFieldColor.black800,
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: YouthFieldColor.blue700,
                  size: 32,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: () {
                  setState(() {
                    if (_selectedSkillIndex != null) {
                      _selectedSkillIndex = null;
                      _selectedStepIndex = 0;
                    } else {
                      _selectedTab = 0;
                    }
                    _skillSearchQuery = '';
                    _skillSearchController.clear();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillContent() {
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
              controller: _skillSearchController,
              onChanged: (val) => setState(() {
                _skillSearchQuery = val;
                _selectedSkillIndex = null;
              }),
              decoration: InputDecoration(
                hintText: '배우고 싶은 스킬을 검색하세요.',
                hintStyle: YouthFieldTextStyle.placeholder.copyWith(
                  color: YouthFieldColor.black500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildSkillBody(),
      ],
    );
  }

  Widget _buildSkillBody() {
    if (_selectedSkillIndex != null) {
      return _buildSkillDetail(skillMockData[_selectedSkillIndex!]);
    }

    final query = _skillSearchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      final results = <MapEntry<int, SkillData>>[];
      for (var i = 0; i < skillMockData.length; i++) {
        final s = skillMockData[i];
        if (s.title.toLowerCase().contains(query) ||
            s.subtitle.toLowerCase().contains(query)) {
          results.add(MapEntry(i, s));
        }
      }
      return _buildSkillSearchResults(results);
    }

    return _buildSkillGrid();
  }

  Widget _buildSkillGrid() {
    const double spacing = 12;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = (constraints.maxWidth / 240).floor().clamp(2, 4);
          final cardWidth =
              (constraints.maxWidth - spacing * (cols - 1)) / cols;
          final cardHeight = cardWidth * 9 / 16;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(skillMockData.length, (i) {
              final s = skillMockData[i];
              return SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: SkillCard(
                  title: s.title,
                  subtitle: s.subtitle,
                  onTap: () => setState(() {
                    _selectedSkillIndex = i;
                    _selectedStepIndex = 0;
                  }),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildSkillSearchResults(List<MapEntry<int, SkillData>> results) {
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
            _selectedSkillIndex = entry.key;
            _selectedStepIndex = 0;
            _skillSearchQuery = '';
            _skillSearchController.clear();
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        style: YouthFieldTextStyle.body4.copyWith(
                          color: YouthFieldColor.black800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.subtitle,
                        style: YouthFieldTextStyle.placeholder.copyWith(
                          color: YouthFieldColor.black500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: YouthFieldColor.black500,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillDetail(SkillData s) {
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
                    Text(
                      s.title,
                      style: YouthFieldTextStyle.body3.copyWith(
                        color: YouthFieldColor.black800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.subtitle,
                      style: YouthFieldTextStyle.textCount.copyWith(
                        color: YouthFieldColor.black500,
                      ),
                    ),
                  ],
                ),
              ),
              if (s.youtubeUrl != null)
                GestureDetector(
                  onTap: () async {
                    final url = Uri.tryParse(s.youtubeUel!);
                    if (url != null && await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
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
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? YouthFieldColor.blue700
                        : YouthFieldColor.blue300,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    s.steps[i].title,
                    style: YouthFieldTextStyle.smallButton.copyWith(
                      color: YouthFieldColor.white,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            s.steps[_selectedStepIndex].description,
            style: YouthFieldTextStyle.textCount.copyWith(
              color: YouthFieldColor.black800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOP PLAYERS',
            style: YouthFieldTextStyle.body3.copyWith(
              color: YouthFieldColor.black800,
            ),
          ),
          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = (constraints.maxWidth / 220).floor().clamp(
                2,
                6,
              );
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: _mockPlayers.length,
                itemBuilder: (_, i) {
                  final p = _mockPlayers[i];
                  return PlayerCard(
                    name: p.name,
                    school: p.school,
                    location: p.location,
                    position: p.position,
                    ageGroup: p.age,
                    number: p.number,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '경기 일정',
                style: YouthFieldTextStyle.body3.copyWith(
                  color: YouthFieldColor.black800,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedTab = 3),
                child: Text('더보기', style: YouthFieldTextStyle.smallButton),
              ),
            ],
          ),
          const SizedBox(height: 20),

          ...(([..._mockSchedules]..sort(
                (a, b) =>
                    _parseStartDate(a.date).compareTo(_parseStartDate(b.date)),
              ))
              .take(5)
              .map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ScheduleItem(
                    title: s.title,
                    dateRange: s.date,
                    venue: s.venue,
                  ),
                ),
              )),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String label) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Text(
          label,
          style: YouthFieldTextStyle.title4.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
      ),
    );
  }
}
