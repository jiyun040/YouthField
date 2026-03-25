import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const YouthFieldApp());
}

class YouthFieldApp extends StatelessWidget {
  const YouthFieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'YouthField',
      debugShowCheckedModeBanner: false,
      home: OnboardingPage(),
    );
  }
}
