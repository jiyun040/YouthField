import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'features/auth/presentation/pages/profile_setup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 로그인 상태 및 프로필 여부를 앱 시작 시 미리 확인
  final home = await _resolveHome();

  runApp(ProviderScope(child: YouthFieldApp(home: home)));
}

/// 앱 시작 시 진입 화면 결정
Future<Widget> _resolveHome() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const OnboardingPage(); // 미로그인 → 온보딩

  final prefs = await SharedPreferences.getInstance();
  final hasProfile =
      prefs.getString('user_name') != null &&
      prefs.getString('user_type') != null;

  if (hasProfile) return const MainPage();        // 기존 유저 → 바로 메인
  return const ProfileSetupPage();                // 프로필 미설정 → 프로필 설정
}

class YouthFieldApp extends StatelessWidget {
  final Widget home;
  const YouthFieldApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouthField',
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
