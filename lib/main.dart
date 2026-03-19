import 'package:flutter/material.dart';

import 'features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
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
