import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class OnboardingNavButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onStart;

  const OnboardingNavButton({
    super.key,
    required this.isLastPage,
    required this.onNext,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    if (isLastPage) {
      return TextButton(
        onPressed: onStart,
        child: Text(
          '시작하기',
          style: YouthFieldTextStyle.title3.copyWith(
            color: YouthFieldColor.gold,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onNext,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.double_arrow, color: YouthFieldColor.gold, size: 32),
        ],
      ),
    );
  }
}
