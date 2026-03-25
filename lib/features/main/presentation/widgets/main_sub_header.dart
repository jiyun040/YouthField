import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class MainSubHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final Widget? trailing;

  const MainSubHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: YouthFieldColor.background,
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: YouthFieldTextStyle.body3.copyWith(
                color: YouthFieldColor.black800,
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Symbols.chevron_left,
                  color: YouthFieldColor.blue700,
                  size: 32,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: onBack,
              ),
            ),
          ),
          if (trailing != null)
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Align(alignment: Alignment.centerRight, child: trailing!),
            ),
        ],
      ),
    );
  }
}
