import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youthfield/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:youthfield/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const YouthFieldApp(home: OnboardingPage()),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
