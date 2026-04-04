import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/main/presentation/pages/main_page.dart';
import '../widgets/onboarding_nav_button.dart';
import '../widgets/page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _titles = [
    '당신의 여정을 시작해보세요',
    '미래의 선수를 발견하세요',
    '다음 세대의 선수들이 있습니다',
    '유소년과의 미래를 함께 합니다',
  ];

  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _titles.length - 1;

  void _onNext() {
    if (!_isLastPage) setState(() => _currentPage++);
  }

  void _onStart() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/svg/background.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: YouthFieldColor.blue700),
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xCC00255E), Color(0x6687B6FF)],
              ),
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.55),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      _titles[_currentPage],
                      key: ValueKey(_currentPage),
                      style: YouthFieldTextStyle.body1.copyWith(
                        color: YouthFieldColor.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 28),
                  PageIndicator(
                    pageCount: _titles.length,
                    currentPage: _currentPage,
                  ),
                  const SizedBox(height: 28),
                  OnboardingNavButton(
                    isLastPage: _isLastPage,
                    onNext: _onNext,
                    onStart: _onStart,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
