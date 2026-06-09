import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'features/auth/presentation/pages/profile_setup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox<String>('diary');
  await Hive.openBox<dynamic>('user_session');
  await Hive.openBox<String>('history');

  final home = await _resolveHome();

  runApp(ProviderScope(child: YouthFieldApp(home: home)));
}

Future<Widget> _resolveHome() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const OnboardingPage();

  final prefs = Hive.box<dynamic>('user_session');

  // 7일 세션 만료 체크
  final timestampRaw = prefs.get('login_timestamp') as String?;
  if (timestampRaw != null) {
    final loginTime = DateTime.tryParse(timestampRaw);
    if (loginTime != null &&
        DateTime.now().difference(loginTime).inDays >= 7) {
      await _clearSessionAndSignOut(prefs);
      return const OnboardingPage();
    }
  }

  final hasLocalProfile =
      (prefs.get('user_name') as String?) != null &&
      (prefs.get('user_type') as String?) != null;

  if (hasLocalProfile) return const MainPage();

  // 로컬에 프로필 없으면 Firestore에서 복원 시도
  try {
    final restored = await _restoreFromFirestore(user.uid, prefs);
    if (restored) return const MainPage();
  } catch (_) {}

  return const ProfileSetupPage();
}

Future<void> _clearSessionAndSignOut(Box<dynamic> prefs) async {
  for (final key in [
    'user_name',
    'user_type',
    'user_staff_role',
    'user_team',
    'user_position',
    'user_birthdate',
    'user_resolve',
    'user_profile_image_bytes',
    'login_timestamp',
  ]) {
    await prefs.delete(key);
  }
  await FirebaseAuth.instance.signOut();
}

Future<bool> _restoreFromFirestore(String uid, Box<dynamic> prefs) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!doc.exists) return false;

  final data = doc.data()!;
  final name = data['name'] as String?;
  final userType = data['userType'] as String?;
  if (name == null || userType == null) return false;

  await prefs.put('user_name', name);
  await prefs.put('user_type', userType);
  final staffRole = data['staffRole'] as String?;
  final team = data['team'] as String?;
  final position = data['position'] as String?;
  final birthdate = data['birthdate'] as String?;
  final resolve = data['resolve'] as String?;
  if (staffRole != null) await prefs.put('user_staff_role', staffRole);
  if (team != null) await prefs.put('user_team', team);
  if (position != null) await prefs.put('user_position', position);
  if (birthdate != null) await prefs.put('user_birthdate', birthdate);
  if (resolve != null) await prefs.put('user_resolve', resolve);

  return true;
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
