import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/widgets/yf_app_bar.dart';
import 'package:youthfield/core/widgets/yf_menu_bar.dart';
import 'package:youthfield/features/auth/presentation/pages/login_page.dart';
import 'package:youthfield/features/diary/data/repositories/diary_repository_impl.dart';
import 'package:youthfield/features/mypage/presentation/pages/mypage_page.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';
import 'package:youthfield/features/diary/presentation/pages/diary_page.dart';
import 'package:youthfield/features/schedule/presentation/pages/schedule_page.dart';
import '../pages/home_tab.dart';
import '../pages/skill_tab.dart';
import '../widgets/main_sub_header.dart';

const _tabs = ['선수 정보', '스킬', '경기 / 연습 일지', '경기 일정'];
const double _baseHeaderHeight = YFAppBar.barHeight + YFMenuBar.barHeight;
const double _subHeaderHeight = 72;
const double _tabHeaderHeight = _baseHeaderHeight + _subHeaderHeight;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedTab = 0;
  bool _isLoggedIn = false;

  final _skillTabKey = GlobalKey<SkillTabState>();

  int? _selectedScheduleIndex;

  DiaryMode _diaryMode = DiaryMode.list;
  DiaryEntry? _selectedDiaryEntry;
  late List<DiaryEntry> _diaryEntries;
  int _diaryCurrentPage = 0;
  int _diaryWindowStart = 0;

  int get _diaryTotalPages {
    final n = _diaryEntries.length;
    if (n == 0) return 1;
    return (n / kDiaryPageSize).ceil();
  }

  @override
  void initState() {
    super.initState();
    _diaryEntries = List.from(diaryMockEntries);
  }

  double get _headerHeight {
    if (_selectedTab == 0) return _baseHeaderHeight;
    return _tabHeaderHeight;
  }

  Future<void> _openLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    if (result == true && mounted) setState(() => _isLoggedIn = true);
  }

  void _onTabSelected(int i) {
    setState(() {
      _selectedTab = i;
      if (i != 2) {
        _diaryMode = DiaryMode.list;
        _selectedDiaryEntry = null;
        _diaryCurrentPage = 0;
        _diaryWindowStart = 0;
      }
      if (i != 3) _selectedScheduleIndex = null;
    });
  }

  void _onLogoTap() {
    Navigator.popUntil(context, (route) => route.isFirst);
    setState(() {
      _selectedTab = 0;
      _selectedScheduleIndex = null;
    });
  }

  void _openMyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MypagePage(
          onDiaryMoreTap: () => setState(() => _selectedTab = 2),
        ),
      ),
    );
  }

  void _onDiaryPageTap(int page) => setState(() {
    _diaryCurrentPage = page;
    _diaryWindowStart = (page ~/ kDiaryWindowSize) * kDiaryWindowSize;
  });

  void _onDiaryPrevWindow() =>
      setState(() => _diaryWindowStart -= kDiaryWindowSize);

  void _onDiaryNextWindow() =>
      setState(() => _diaryWindowStart += kDiaryWindowSize);

  void _onSkillBack() {
    final handled = _skillTabKey.currentState?.handleBack() ?? false;
    if (!handled) setState(() => _selectedTab = 0);
  }

  void _onDiaryBack() {
    setState(() {
      if (_diaryMode != DiaryMode.list) {
        _diaryMode = DiaryMode.list;
        _selectedDiaryEntry = null;
      } else {
        _selectedTab = 0;
      }
    });
  }

  void _onScheduleBack() {
    setState(() {
      if (_selectedScheduleIndex != null) {
        _selectedScheduleIndex = null;
      } else {
        _selectedTab = 0;
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
          if (_selectedTab == 2 &&
              _diaryMode == DiaryMode.list &&
              _diaryTotalPages > 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DiaryPaginationBar(
                currentPage: _diaryCurrentPage,
                totalPages: _diaryTotalPages,
                windowStart: _diaryWindowStart,
                onPageTap: _onDiaryPageTap,
                onPrevWindow: _onDiaryPrevWindow,
                onNextWindow: _onDiaryNextWindow,
              ),
            ),
          Positioned(top: 0, left: 0, right: 0, child: _buildHeader()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        YFAppBar(
          isLoggedIn: _isLoggedIn,
          onLogin: _openLogin,
          onLogout: () => setState(() => _isLoggedIn = false),
          onLogoTap: _onLogoTap,
          onProfileTap: _openMyPage,
        ),
        YFMenuBar(
          tabs: _tabs,
          selectedIndex: _selectedTab,
          onTabSelected: _onTabSelected,
        ),
        if (_selectedTab == 1) MainSubHeader(title: '스킬', onBack: _onSkillBack),
        if (_selectedTab == 2)
          MainSubHeader(
            title: '경기 / 연습 일지',
            onBack: _onDiaryBack,
            trailing: _diaryMode == DiaryMode.list
                ? IconButton(
                    icon: const Icon(
                      Symbols.stylus_note,
                      color: YouthFieldColor.blue700,
                      size: 30,
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onPressed: () =>
                        setState(() => _diaryMode = DiaryMode.write),
                  )
                : null,
          ),
        if (_selectedTab == 3)
          MainSubHeader(title: '경기일정', onBack: _onScheduleBack),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedTab) {
      case 0:
        return HomeTab(
          onScheduleMoreTap: () => setState(() => _selectedTab = 3),
        );
      case 1:
        return SkillTab(key: _skillTabKey);
      case 2:
        return DiaryBody(
          mode: _diaryMode,
          entries: _diaryEntries,
          currentPage: _diaryCurrentPage,
          selectedEntry: _selectedDiaryEntry,
          onEntryTap: (entry) => setState(() {
            _selectedDiaryEntry = entry;
            _diaryMode = DiaryMode.detail;
          }),
          onSave: (entry) => setState(() {
            _diaryEntries.insert(0, entry);
            _diaryMode = DiaryMode.list;
            _diaryCurrentPage = 0;
            _diaryWindowStart = 0;
          }),
        );
      case 3:
        return ScheduleBody(
          selectedIndex: _selectedScheduleIndex,
          onSelect: (i) => setState(() => _selectedScheduleIndex = i),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
