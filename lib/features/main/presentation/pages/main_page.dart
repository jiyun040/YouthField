import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/core/services/user_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/providers/auth_provider.dart';
import 'package:youthfield/core/widgets/login_required_dialog.dart';
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

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedTab = 0;

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
    final isLoggedIn = ref.read(authStateProvider).value != null;
    if (isLoggedIn) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '이미 로그인됨',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          content: const Text(
            '이미 로그인된 상태입니다.',
            style: TextStyle(fontSize: 14, color: Color(0xFF707070)),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            TextButton(
              style: TextButton.styleFrom(overlayColor: Colors.transparent),
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                '확인',
                style: YouthFieldTextStyle.smallButton.copyWith(
                  color: YouthFieldColor.blue700,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
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
    final isLoggedIn = ref.read(authStateProvider).value != null;
    if (!isLoggedIn) {
      _showLoginRequiredDialog();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MypagePage(onDiaryMoreTap: () => setState(() => _selectedTab = 2)),
      ),
    );
  }

  void _showLoginRequiredDialog({String? message}) {
    LoginRequiredDialog.show(
      context: context,
      subtitle: message,
      onLogin: _openLogin,
    );
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('로그아웃', style: YouthFieldTextStyle.body4),
        content: Text(
          '로그아웃 하시겠습니까?',
          style: YouthFieldTextStyle.smallButton.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        actions: [
          TextButton(
            style: TextButton.styleFrom(overlayColor: Colors.transparent),
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              '취소',
              style: YouthFieldTextStyle.smallButton.copyWith(
                color: YouthFieldColor.black500,
              ),
            ),
          ),
          const SizedBox(width: 20),
          TextButton(
            style: TextButton.styleFrom(overlayColor: Colors.transparent),
            onPressed: () {
              Navigator.pop(ctx);
              UserSession().clear();
              FirebaseAuth.instance.signOut();
            },
            child: Text(
              '로그아웃',
              style: YouthFieldTextStyle.smallButton.copyWith(
                color: YouthFieldColor.blue700,
              ),
            ),
          ),
        ],
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: YouthFieldColor.background,
              child: _buildHeader(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isLoggedIn = ref.watch(authStateProvider).value != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        YFAppBar(
          isLoggedIn: isLoggedIn,
          onLogin: _openLogin,
          onLogout: () {
            if (!isLoggedIn) {
              _showLoginRequiredDialog(message: '로그인 후 로그아웃이 가능합니다.');
              return;
            }
            _showLogoutConfirmDialog();
          },
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
                    onPressed: () {
                      if (!isLoggedIn) {
                        _showLoginRequiredDialog(
                          message: '일지 작성은 로그인 후 이용할 수 있습니다.',
                        );
                        return;
                      }
                      setState(() => _diaryMode = DiaryMode.write);
                    },
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
          onScheduleTap: (index) => setState(() {
            _selectedScheduleIndex = index;
            _selectedTab = 3;
          }),
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
