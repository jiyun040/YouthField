import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';

class DiaryPageIndicator extends StatelessWidget {
  final int activeIndex;

  const DiaryPageIndicator({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == activeIndex
                ? YouthFieldColor.blue700
                : YouthFieldColor.black50,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
