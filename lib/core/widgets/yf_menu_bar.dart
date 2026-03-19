import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class YFMenuBar extends StatelessWidget {
  static const double barHeight = 56.0;

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const YFMenuBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: YouthFieldColor.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (i) {
          final isSelected = i == selectedIndex;
          return InkWell(
            onTap: () => onTabSelected(i),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? YouthFieldColor.gold
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tabs[i],
                style: YouthFieldTextStyle.body4.copyWith(
                  color: isSelected
                      ? YouthFieldColor.black800
                      : YouthFieldColor.black500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
