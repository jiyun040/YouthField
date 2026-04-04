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

  final home = await _resolveHome();

  runApp(ProviderScope(child: YouthFieldApp(home: home)));
}

Future<Widget> _resolveHome() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const OnboardingPage();

  final prefs = await SharedPreferences.getInstance();
  final hasProfile =
      prefs.getString('user_name') != null &&
      prefs.getString('user_type') != null;

  if (hasProfile) return const MainPage();
  return const ProfileSetupPage();
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
